-- Run with a database administrator in a test session. All fixtures are rolled back.
-- No auth signup/email endpoint is called and no fixture survives this transaction.
begin;
do $test$
declare users uuid[]:=array[gen_random_uuid(),gen_random_uuid(),gen_random_uuid()];
 season uuid:=gen_random_uuid(); run uuid; c record; i int; ms bigint; waves int; first_alias text; n int; blocked boolean;
begin
 if exists(select 1 from pg_trigger where tgrelid='auth.users'::regclass and not tgisinternal) then
  raise exception 'Run these fixtures in an isolated test project when custom auth triggers exist';
 end if;
 for i in 1..3 loop insert into auth.users(id,aud,role) values(users[i],'authenticated','authenticated'); end loop;
 insert into public.ranked_seasons(id,slug,name,game_build,validator_build,status)
 values(season,'test-'||season,'Rollback test','test','test','active');
 update public.ranked_categories set ranked_enabled=true;
 for c in select * from public.ranked_categories loop
  for i in 1..3 loop
   run:=gen_random_uuid();ms:=case i when 1 then 10000 when 2 then 20000 else 1000 end;
   waves:=case c.mode when 'chaos' then 30 when 'infinite' then 6+i else 0 end;
   insert into ranked_private.runs(id,user_id,category_id,season_id,status,seed,game_build,validator_build,
    started_at,finished_at,elapsed_ms,cleared_battalions,verified_at,evidence_digest)
   values(run,users[i],c.id,season,'finished','test-seed','test','test',now()-ms*interval '1 millisecond',now(),ms,waves,now(),'test-only-rollback');
   insert into public.ranked_records(run_id,user_id,category_id,season_id,alias,elapsed_ms,cleared_battalions,achieved_at,is_listed)
   values(run,users[i],c.id,season,case i when 1 then 'First' when 2 then 'Second' else 'Hidden' end,ms,waves,now(),i<3);
  end loop;
  execute 'set local role anon';
  select count(*) into n from public.ranked_leaderboard(c.id,season,50);
  if n<>2 then raise exception 'RLS/row count failed for %',c.id;end if;
  select alias into first_alias from public.ranked_leaderboard(c.id,season,1);
  if first_alias is distinct from (case c.mode when 'infinite' then 'Second' else 'First' end) then raise exception 'Ranking order failed for %',c.id;end if;
  blocked:=false;begin update public.ranked_categories set ranked_enabled=false;exception when insufficient_privilege then blocked:=true;end;
  if not blocked then raise exception 'Client can change categories';end if;
  blocked:=false;begin insert into public.ranked_records(run_id,user_id,category_id,season_id,alias,elapsed_ms,cleared_battalions,achieved_at)
   values(gen_random_uuid(),users[1],c.id,season,'Forged',1,999,now());exception when insufficient_privilege then blocked:=true;end;
  if not blocked then raise exception 'Client can insert forged scores';end if;
  blocked:=false;begin perform checkpoint from ranked_private.runs limit 1;exception when insufficient_privilege then blocked:=true;end;
  if not blocked then raise exception 'Client can see private progress';end if;
  execute 'reset role';
 end loop;
 execute 'set local role authenticated';
 blocked:=false;begin perform user_id from public.ranked_records limit 1;exception when insufficient_privilege then blocked:=true;end;
 if not blocked then raise exception 'Account IDs are public';end if;
 blocked:=false;begin perform * from public.ranked_leaderboard('invalid;drop table ranked_records',season,50);exception when invalid_parameter_value then blocked:=true;end;
 if not blocked then raise exception 'Invalid category accepted';end if;
 blocked:=false;begin perform * from public.ranked_leaderboard('campaign_normal',season,101);exception when invalid_parameter_value then blocked:=true;end;
 if not blocked then raise exception 'Unbounded leaderboard accepted';end if;
 blocked:=false;begin perform * from public.ranked_leaderboard('campaign_normal',season,0);exception when invalid_parameter_value then blocked:=true;end;
 if not blocked then raise exception 'Zero limit accepted';end if;
 execute 'reset role';
end $test$;
rollback;
select 'passed; fixtures rolled back' as ranked_tests,
 (select count(*) from public.ranked_categories) as categories,
 (select count(*) from public.ranked_categories where ranked_enabled) as competitive_categories,
 (select count(*) from public.ranked_records) as public_records;
