-- Apply only after the deployed GitHub OIDC worker has successfully checked the queue.
update public.ranked_seasons set name='Rankeds BETA · v87',game_build='87-replay-v1',validator_build='87-replay-v1',status='active' where slug='prelaunch-v1' and status='draft';
update public.ranked_categories set ranked_enabled=true;
