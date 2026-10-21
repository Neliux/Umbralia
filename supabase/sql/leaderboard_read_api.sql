-- Read-only RPC. It cannot create runs, approve evidence or write scores.
create function public.ranked_leaderboard(p_category text, p_season uuid default null, p_limit integer default 50)
returns table("position" bigint, alias text, elapsed_ms bigint, cleared_battalions integer,
 achieved_at timestamptz, category_id text, season_id uuid)
language plpgsql stable security invoker set search_path='' as $$
declare category_order text; chosen_season uuid;
begin
 if p_limit is null or p_limit<1 or p_limit>100 then raise exception 'Invalid leaderboard limit' using errcode='22023'; end if;
 select c.ordering into category_order from public.ranked_categories c where c.id=p_category;
 if not found then raise exception 'Unknown ranked category' using errcode='22023'; end if;
 if p_season is null then
   select s.id into chosen_season from public.ranked_seasons s where s.status in ('active','closed')
   order by (s.status='active') desc,s.created_at desc,s.id limit 1;
 else
   select s.id into chosen_season from public.ranked_seasons s where s.id=p_season and s.status in ('active','closed');
 end if;
 if chosen_season is null then return; end if;
 return query select row_number() over(order by
   case when category_order='battalions_desc_time_asc' then r.cleared_battalions end desc,
   r.elapsed_ms,r.achieved_at,r.id),r.alias,r.elapsed_ms,r.cleared_battalions,r.achieved_at,r.category_id,r.season_id
 from public.ranked_records r where r.category_id=p_category and r.season_id=chosen_season
 order by case when category_order='battalions_desc_time_asc' then r.cleared_battalions end desc,
 r.elapsed_ms,r.achieved_at,r.id limit p_limit;
end $$;
revoke all on function public.ranked_leaderboard(text,uuid,integer) from public,anon,authenticated,service_role;
grant execute on function public.ranked_leaderboard(text,uuid,integer) to anon,authenticated,service_role;
comment on function public.ranked_leaderboard(text,uuid,integer) is 'Read-only, invoker RLS. Finished modes: fastest verified time; infinite: highest cleared battalion then fastest time.';
