-- most selective trigram for search string
-- always return a row (NULL if no trigrams found)

create or replace function getBestTrigrams(string text)
returns table(trgm1 text, trgm2 text, trgm3 text)
language plpgsql
as $function$
	begin
		return query
		select 
			max(case when bt.n = 1 then bt.trigram end) as trgm1,
			max(case when bt.n = 2 then bt.trigram end) as trgm2,
			max(case when bt.n = 3 then bt.trigram end) as trgm3
		from (
			SELECT 
				cast(row_number() over (order by tcv.cnt asc) as int) n,
				gt.trigram as trigram
			from
				-- TODO: wrap unnest in a function
				trigramCountView tcv
					join (select * from unnest(show_trgm(string)) as trigram where length(trim(trigram)) = 3) gt 
					on gt.trigram = tcv.trigram order by tcv.cnt asc 
		) bt;
	end;
$function$;