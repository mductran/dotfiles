create or replace function GenerateTrigram(string text)
returns table (trigram text)
language plpgsql
as
$$
	declare top int;
	begin
		top = case
			when length(string) > 2 then length(string) - 2
			else 0
		end;
		return query with N16 as 
		(
			select V.v from 
			(
				values
					(0),(0),(0),(0),(0),(0),(0),(0),
					(0),(0),(0),(0),(0),(0),(0),(0)
			) as V (v)
		),
		Nums as
		(
			select cast(row_number() over (order by A.v) as int) n
			from N16 as A
			cross join N16 as B
		),
		Trigrams as 
		(
			select substring(string, N.n, 3) trigram from Nums as N order by N.n limit top
		) 	
		
		select distinct T.trigram
			from Trigrams as T 
--			where T.trigram collate Latin1_General_BIN2 
			where T.trigram not like '%[^A-Z0-9a-z]%';
	end;
$$;


--select * from generatetrigram('hello world');