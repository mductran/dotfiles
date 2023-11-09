CREATE FUNCTION dbo.GenerateTrigrams (@string VARCHAR(255))
RETURNS TABLE
	WITH SCHEMABINDING
AS
RETURN
WITH N16 AS (
		SELECT V.v
		FROM (
			VALUES (0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
				,(0)
			) AS V(v)
		)
	,
	-- Numbers table (256)
	Nums AS (
		SELECT n = ROW_NUMBER() OVER (
				ORDER BY A.v
				)
		FROM N16 AS A
		CROSS JOIN N16 AS B
		)
	,Trigrams AS (
		-- Every 3-character substring
		SELECT TOP (
				CASE 
					WHEN LEN(@string) > 2
						THEN LEN(@string) - 2
					ELSE 0
					END
				) trigram = SUBSTRING(@string, N.n, 3)
		FROM Nums AS N
		ORDER BY N.n
		)

-- Remove duplicates and ensure all three characters are alphanumeric
SELECT DISTINCT T.trigram
FROM Trigrams AS T
WHERE
	-- Binary collation comparison so ranges work as expected
	T.trigram COLLATE Latin1_General_BIN2 NOT LIKE '%[^A-Z0-9a-z]%';
