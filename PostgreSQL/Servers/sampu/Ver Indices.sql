		

SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename,
    indexname;
		
		/**************************************************************************************/
		SELECT
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    tablename = 'prison_person';