-- Backend-only entry point. Browser roles cannot call this function.
create function public.ranked_backend87(p_action text,p_user uuid default null,p_body jsonb default '{}'::jsonb) returns jsonb
language plpgsql security invoker set search_path='' as $$
declare r ranked_private.runs%rowtype; s public.ranked_seasons%rowtype; c public.ranked_categories%rowtype; meta jsonb; token uuid; data jsonb; n bigint; alias_name text; elapsed bigint; cleared int; ok boolean;
begin
 if p_action='begin' then
  select * into c from public.ranked_categories where id=p_body->>'category' and ranked_enabled;
  if not found then raise exception 'Category unavailable'; end if;
  select * into s from public.ranked_seasons where status='active' order by created_at desc limit 1;
  if not found then raise exception 'Season unavailable'; end if;
  if (select count(*) from ranked_private.runs where user_id=p_user and created_at>now()-interval '1 hour')>=12 then raise exception 'Too many attempts'; end if;
  alias_name:=p_body->>'alias';
  if char_length(alias_name) not between 3 and 24 or alias_name ~ '[[:cntrl:]<>]' or alias_name is null then raise exception 'Invalid alias'; end if;
  meta:=p_body->'meta';
  if jsonb_typeof(meta)<>'object' or octet_length(meta::text)>2048 then raise exception 'Invalid configuration'; end if;
  meta:=meta||jsonb_build_object('mode',c.mode,'difficulty',c.difficulty,'seed',(floor(random()*4294967294)+1)::bigint,'epoch',floor(extract(epoch from clock_timestamp())*1000)::bigint);
  update ranked_private.runs set status='abandoned',finished_at=now() where user_id=p_user and status in ('active','created');
  insert into ranked_private.runs(user_id,category_id,season_id,status,seed,game_build,validator_build,started_at,checkpoint)
   values(p_user,c.id,s.id,'active',meta->>'seed',s.game_build,s.validator_build,now(),jsonb_build_object('meta',meta,'alias',alias_name)) returning * into r;
  return jsonb_build_object('id',r.id,'meta',meta,'build',r.game_build);
 elsif p_action in ('append','finish','status','abandon') then
  select * into r from ranked_private.runs where user_id=p_user and (id=(p_body->>'id')::uuid or (p_action='status' and p_body->>'id' is null)) order by created_at desc limit 1 for update;
  if not found then if p_action='status' and p_body->>'id' is null then return '{"status":"none"}'::jsonb;end if;raise exception 'Unknown attempt'; end if;
  if p_action='status' then return jsonb_build_object('id',r.id,'status',r.status,'verified',r.verified_at is not null,'reason',r.checkpoint->>'reason','code',r.checkpoint->>'code'); end if;
  if p_action='abandon' then
   update ranked_private.runs set status='abandoned',finished_at=now() where id=r.id and status='active';return '{"ok":true}'::jsonb;
  end if;
  if p_action='finish' and r.status='finished' and r.last_sequence=(p_body->>'sequence')::bigint then return '{"status":"pending"}'::jsonb;end if;
  if r.status<>'active' or r.started_at<now()-interval '24 hours' then raise exception 'Attempt closed'; end if;
  if p_action='append' then
   n:=(p_body->>'sequence')::bigint;data:=p_body->'events';
   if n<1 or n>2048 or jsonb_typeof(data)<>'array' or jsonb_array_length(data)>512 or octet_length(data::text)>60000 then raise exception 'Batch limit'; end if;
   if n<=r.last_sequence then
    if exists(select 1 from ranked_private.input_batches where run_id=r.id and sequence=n and digest=p_body->>'digest') then return jsonb_build_object('sequence',n); end if;
    raise exception 'Batch mismatch';
   end if;
   if n<>r.last_sequence+1 then raise exception 'Batch sequence'; end if;
   if coalesce((r.checkpoint->>'input_bytes')::bigint,0)+octet_length(data::text)>33554432 then raise exception 'Input budget';end if;
   insert into ranked_private.input_batches(run_id,sequence,digest,payload) values(r.id,n,p_body->>'digest',data);
   update ranked_private.runs set last_sequence=n,checkpoint=checkpoint||jsonb_build_object('input_bytes',coalesce((checkpoint->>'input_bytes')::bigint,0)+octet_length(data::text)) where id=r.id;return jsonb_build_object('sequence',n);
  end if;
  if r.last_sequence<1 or r.last_sequence<>(p_body->>'sequence')::bigint then raise exception 'Missing inputs'; end if;
  update ranked_private.runs set status='finished',finished_at=now() where id=r.id;return '{"status":"pending"}'::jsonb;
 elsif p_action='claim' then
  select * into r from ranked_private.runs where status='finished' and verified_at is null and
    coalesce((checkpoint->>'lease_until')::timestamptz,'epoch'::timestamptz)<now() order by finished_at limit 1 for update skip locked;
  if not found then return 'null'::jsonb;end if;
  token:=gen_random_uuid();
  update ranked_private.runs set checkpoint=checkpoint||jsonb_build_object('lease',token,'worker',p_body->>'worker','lease_until',now()+interval '20 minutes') where id=r.id;
  select coalesce(jsonb_agg(jsonb_build_object('sequence',sequence,'digest',digest,'events',payload) order by sequence),'[]'::jsonb) into data from ranked_private.input_batches where run_id=r.id;
  return jsonb_build_object('id',r.id,'lease',token,'meta',r.checkpoint->'meta','build',r.game_build,'wall_ms',floor(extract(epoch from r.finished_at-r.started_at)*1000)::bigint,'batches',data);
 elsif p_action='verdict' then
  select * into r from ranked_private.runs where id=(p_body->>'id')::uuid for update;
  if not found or r.status<>'finished' or r.verified_at is not null or r.checkpoint->>'lease' is distinct from p_body->>'lease' or r.checkpoint->>'worker' is distinct from p_body->>'worker' then raise exception 'Invalid lease';end if;
  ok:=coalesce((p_body->>'ok')::boolean,false);elapsed:=(p_body->>'elapsed_ms')::bigint;cleared:=(p_body->>'cleared_battalions')::int;
  if not ok then
   if p_body->>'code'='service_retry' then
    update ranked_private.runs set checkpoint=checkpoint||jsonb_build_object('reason','El verificador está reintentando la partida; aún no ha sido rechazada.','code','service_retry','lease_until',now()+interval '10 minutes') where id=r.id;
   else
    update ranked_private.runs set status='rejected',checkpoint=checkpoint||jsonb_build_object('code',case when p_body->>'code' in ('input_integrity','input_limit','replay_control','replay_end','rules_changed') then p_body->>'code' else 'replay_end' end,'reason',case p_body->>'code' when 'input_integrity' then 'El registro de controles llegó incompleto o alterado.' when 'input_limit' then 'El intento superó los límites de registro de la beta.' when 'replay_control' then 'No se pudo reproducir un control. Actualiza el juego antes de iniciar otro intento.' when 'rules_changed' then 'La partida utilizó códigos o cambió las reglas de su categoría.' else 'La reproducción no confirmó el final de esta categoría.' end) where id=r.id;
   end if;
   return '{"ok":true}'::jsonb;
  end if;
  if elapsed<=0 or cleared<0 or length(p_body->>'digest')<>64 then raise exception 'Invalid verdict'; end if;
  update ranked_private.runs set elapsed_ms=elapsed,cleared_battalions=cleared,verified_at=now(),evidence_digest=p_body->>'digest' where id=r.id returning * into r;
  insert into public.ranked_records(run_id,user_id,category_id,season_id,alias,elapsed_ms,cleared_battalions,achieved_at)
   values(r.id,r.user_id,r.category_id,r.season_id,r.checkpoint->>'alias',elapsed,cleared,r.finished_at)
   on conflict(user_id,category_id,season_id) do update set run_id=excluded.run_id,alias=excluded.alias,elapsed_ms=excluded.elapsed_ms,cleared_battalions=excluded.cleared_battalions,achieved_at=excluded.achieved_at
   where case when excluded.category_id like 'infinite_%' then excluded.cleared_battalions>ranked_records.cleared_battalions or (excluded.cleared_battalions=ranked_records.cleared_battalions and excluded.elapsed_ms<ranked_records.elapsed_ms) else excluded.elapsed_ms<ranked_records.elapsed_ms end;
  return '{"ok":true}'::jsonb;
 end if;
 raise exception 'Unsupported action';
end $$;
revoke all on function public.ranked_backend87(text,uuid,jsonb) from public,anon,authenticated;
grant execute on function public.ranked_backend87(text,uuid,jsonb) to service_role;
create index ranked_pending87 on ranked_private.runs(finished_at) where status='finished' and verified_at is null;
