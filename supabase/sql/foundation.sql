-- Foundation only. Competitive play stays disabled until a real validator is deployed.
create schema ranked_private;
revoke all on schema ranked_private from public, anon, authenticated;
grant usage on schema ranked_private to service_role;

create table public.ranked_categories (
  id text primary key,
  mode text not null check(mode in ('campaign','chaos','infinite')),
  difficulty text not null check(difficulty in ('normal','hardcore','masochist')),
  name text not null,
  ordering text not null check(ordering in ('time_asc','battalions_desc_time_asc')),
  finish_rule text not null check(finish_rule in ('void_world6','chaos_wave30','cleared_battalion')),
  ranked_enabled boolean not null default false,
  unique(mode,difficulty),
  check(id=mode||'_'||difficulty),
  check((mode='campaign' and ordering='time_asc' and finish_rule='void_world6')
    or (mode='chaos' and ordering='time_asc' and finish_rule='chaos_wave30')
    or (mode='infinite' and ordering='battalions_desc_time_asc' and finish_rule='cleared_battalion'))
);
alter table public.ranked_categories enable row level security;
revoke all on public.ranked_categories from public,anon,authenticated,service_role;
grant select on public.ranked_categories to anon,authenticated,service_role;
create policy ranked_categories_read on public.ranked_categories for select to anon,authenticated using(true);

create table public.ranked_seasons (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  game_build text,
  validator_build text,
  status text not null default 'draft' check(status in ('draft','active','closed')),
  created_at timestamptz not null default now(),
  check(status<>'active' or (game_build is not null and validator_build is not null))
);
alter table public.ranked_seasons enable row level security;
revoke all on public.ranked_seasons from public,anon,authenticated,service_role;
grant select on public.ranked_seasons to anon,authenticated,service_role;
create policy ranked_seasons_read on public.ranked_seasons for select to anon,authenticated using(true);

create table ranked_private.runs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id text not null references public.ranked_categories(id),
  season_id uuid not null references public.ranked_seasons(id),
  status text not null default 'created' check(status in ('created','active','finished','rejected','abandoned')),
  seed text not null,
  game_build text not null,
  validator_build text not null,
  created_at timestamptz not null default now(),
  started_at timestamptz,
  finished_at timestamptz,
  elapsed_ms bigint check(elapsed_ms>0),
  cleared_battalions integer not null default 0 check(cleared_battalions>=0),
  last_sequence bigint not null default 0 check(last_sequence>=0),
  federico_used boolean not null default false,
  verified_at timestamptz,
  evidence_digest text,
  checkpoint jsonb,
  unique(id,user_id,category_id,season_id),
  check(finished_at is null or (started_at is not null and finished_at>=started_at)),
  check(verified_at is null or (status='finished' and not federico_used and finished_at is not null
    and elapsed_ms is not null and evidence_digest is not null))
);
create index ranked_runs_user_created_idx on ranked_private.runs(user_id,created_at desc);
create index ranked_runs_category_idx on ranked_private.runs(category_id);
create index ranked_runs_season_idx on ranked_private.runs(season_id);
create unique index ranked_one_active_run_per_user_idx on ranked_private.runs(user_id) where status in ('created','active');
alter table ranked_private.runs enable row level security;
revoke all on ranked_private.runs from public,anon,authenticated;
grant select,insert,update on ranked_private.runs to service_role;

create table ranked_private.input_batches (
  run_id uuid not null references ranked_private.runs(id) on delete cascade,
  sequence bigint not null check(sequence>0),
  received_at timestamptz not null default now(),
  digest text not null,
  payload jsonb not null,
  primary key(run_id,sequence),
  check(octet_length(payload::text)<=65536)
);
alter table ranked_private.input_batches enable row level security;
revoke all on ranked_private.input_batches from public,anon,authenticated;
grant select,insert on ranked_private.input_batches to service_role;

create table public.ranked_records (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null unique,
  user_id uuid not null,
  category_id text not null,
  season_id uuid not null,
  alias text not null check(char_length(alias) between 3 and 24 and alias !~ '[[:cntrl:]<>]'),
  elapsed_ms bigint not null check(elapsed_ms>0),
  cleared_battalions integer not null check(cleared_battalions>=0),
  achieved_at timestamptz not null,
  is_listed boolean not null default true,
  foreign key(run_id,user_id,category_id,season_id) references ranked_private.runs(id,user_id,category_id,season_id) on delete cascade,
  unique(user_id,category_id,season_id)
);
create index ranked_records_category_time_idx on public.ranked_records(category_id,season_id,elapsed_ms,achieved_at,id) where is_listed;
create index ranked_records_category_battalion_idx on public.ranked_records(category_id,season_id,cleared_battalions desc,elapsed_ms,achieved_at,id) where is_listed;
create index ranked_records_season_idx on public.ranked_records(season_id);
alter table public.ranked_records enable row level security;
revoke all on public.ranked_records from public,anon,authenticated,service_role;
grant select(id,category_id,season_id,alias,elapsed_ms,cleared_battalions,achieved_at) on public.ranked_records to anon,authenticated;
grant select,insert,update on public.ranked_records to service_role;
create policy ranked_records_read on public.ranked_records for select to anon,authenticated using(is_listed);

-- Invoker rights: no publicly executable privileged function, and no trust in client claims.
create function ranked_private.guard_record_publish() returns trigger
language plpgsql security invoker set search_path='' as $$
declare r ranked_private.runs%rowtype; s public.ranked_seasons%rowtype; c public.ranked_categories%rowtype;
begin
  select * into r from ranked_private.runs where id=new.run_id;
  if not found then raise exception 'Unknown ranked run'; end if;
  select * into s from public.ranked_seasons where id=new.season_id;
  select * into c from public.ranked_categories where id=new.category_id;
  if s.status<>'active' or not c.ranked_enabled then raise exception 'Ranked is not accepting records'; end if;
  if r.status<>'finished' or r.verified_at is null or r.federico_used or r.evidence_digest is null
     or r.game_build is distinct from s.game_build or r.validator_build is distinct from s.validator_build
     or r.user_id is distinct from new.user_id or r.category_id is distinct from new.category_id
     or r.season_id is distinct from new.season_id or r.elapsed_ms is distinct from new.elapsed_ms
     or r.cleared_battalions is distinct from new.cleared_battalions or r.finished_at is distinct from new.achieved_at
     then raise exception 'The run has not been verified by the matching server'; end if;
  if (c.mode='chaos' and new.cleared_battalions<>30) or (c.mode='infinite' and new.cleared_battalions<1)
    then raise exception 'Invalid completion for category'; end if;
  return new;
end $$;
revoke all on function ranked_private.guard_record_publish() from public,anon,authenticated;
create trigger ranked_records_verified_only before insert or update on public.ranked_records
  for each row execute function ranked_private.guard_record_publish();

insert into public.ranked_categories(id,mode,difficulty,name,ordering,finish_rule)
select m.mode||'_'||d.difficulty,m.mode,d.difficulty,m.label||' · '||d.label,
  case when m.mode='infinite' then 'battalions_desc_time_asc' else 'time_asc' end,m.finish_rule
from (values ('campaign','Campaña','void_world6'),('chaos','Caos','chaos_wave30'),('infinite','Caos infinito','cleared_battalion')) as m(mode,label,finish_rule)
cross join (values ('normal','Normal'),('hardcore','Hardcore'),('masochist','Masoquista')) as d(difficulty,label);
insert into public.ranked_seasons(slug,name) values('prelaunch-v1','Preparación de Ranked');
comment on schema ranked_private is 'Internal ranked data. No access for anon/authenticated. No validator is deployed yet.';
comment on table public.ranked_records is 'Server-verified best marks only. Empty until the authoritative game validator is ready.';

-- Follow-up hardening, also applied as a separate database migration.
create policy ranked_runs_clients_denied on ranked_private.runs for all to anon,authenticated using(false) with check(false);
create policy ranked_inputs_clients_denied on ranked_private.input_batches for all to anon,authenticated using(false) with check(false);
create index ranked_records_run_identity_idx on public.ranked_records(run_id,user_id,category_id,season_id);
