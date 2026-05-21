DO
$$
DECLARE
    r RECORD;
    qry TEXT;
    v TEXT := 'Electronicos';  -- valor que estás buscando
BEGIN
    FOR r IN  SELECT table_schema, table_name, column_name FROM information_schema.columns WHERE data_type IN ('character varying', 'text', 'char')
        AND table_schema NOT IN ('information_schema', 'pg_catalog')
    LOOP
       qry := format('SELECT %L as valor_buscado, %L as tabla, %L as columna FROM %I.%I WHERE %I::text ILIKE %L LIMIT 1',
                      v, r.table_name, r.column_name, r.table_schema, r.table_name, r.column_name, '%' || v || '%');
        EXECUTE qry INTO r;
       /* IF FOUND THEN
            RAISE NOTICE 'Valor encontrado en: %.% columna: %', r.table_schema, r.table_name, r.column_name;
        END IF;*/
    END LOOP;
END
$$;
