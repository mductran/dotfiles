create function GenerateTrigram(string varchar) 
returns table (trigram varchar)
language plpgsql
as 
$$
	declare top int;
	begin
		top = case
				when length(string) > 2 then length(string) - 2
				else 0
		end;
		with 
			N16 as
	        (
	            SELECT V.v 
	            FROM 
	            (
	                VALUES 
	                    (0),(0),(0),(0),(0),(0),(0),(0),
	                    (0),(0),(0),(0),(0),(0),(0),(0)
	            ) AS V (v)
	        ),
			Nums as
			(
	            SELECT n = ROW_NUMBER() OVER (ORDER BY A.v)
	            FROM N16 AS A 
	            CROSS JOIN N16 AS B
			),
			Trigrams as 
			(
				select trigrams = substring(string, N.n, 3) from Nums as N order by N.n limit top;
			)
		
		select distinct T.trigram from Trigrams as T where T.trigram collate Latin1_General_BIN2 NOT LIKE '%[^A-Z0-9a-z]%';

	end;
$$ ;