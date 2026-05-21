SELECT
    cols.table_schema,
    cols.table_name,
    cols.column_name,
    cols.ordinal_position,
    cols.data_type,
    cols.character_maximum_length,
    cols.numeric_precision,
    cols.is_nullable,
    pgd.description AS column_description
FROM information_schema.columns cols
LEFT JOIN pg_catalog.pg_statio_all_tables st
    ON st.schemaname = cols.table_schema
   AND st.relname = cols.table_name
LEFT JOIN pg_catalog.pg_description pgd
    ON pgd.objoid = st.relid
   AND pgd.objsubid = cols.ordinal_position
WHERE cols.table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY cols.table_schema, cols.table_name, cols.ordinal_position;
