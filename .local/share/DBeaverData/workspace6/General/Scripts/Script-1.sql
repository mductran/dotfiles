-- search implementation
create or replace function trigramSearch(searchterm text) 
returns table (string text)
language plpgsql
as $function$
	
	begin
		
		return query 
			select r.string from getbesttrigrams(searchterm) gbt,
			lateral (
				-- trigram search
				select e.id, e.phash from getmatchingtrigramid() as mid
				join bstrings20 as e on e.id = mid.id
				where gbt.trgm1 is not null and e.phash like searchterm
				
				union all
				
				-- non-trigram search
				select e.id, e.phash from bstrings20 as e where
					-- no trigram found
					gbt.trgm1 is null and e.phash like searchterm
			) as r;
		
	end;
	

$function$