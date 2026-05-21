CREATE OR REPLACE FUNCTION f_find_bad_toast( tablez text,
                                             pk text,
                                             tuple_limit bigint  DEFAULT 0,
                                             tuple_offset bigint DEFAULT 0 )
RETURNS TABLE( total bigint,
               ok bigint,
               ko bigint,
               health_ratio float,
               damage_ratio float,
               description text,
               damage_tuple_ids bigint[] )
AS $CODE$

DECLARE
  toast_oid      oid;
  toast_tablez   text;
  toast_filename text;

  query_pk text;
  query_detoast text;
  column_counter int := 0;

  current_column_to_detoast  text;
  current_pk bigint;

  current_detoasted_data text;

  ok_counter bigint := 0;
  ko_counter bigint := 0;
  total_counter bigint := 0;
  damage_ratio float := 0;

  wrong_tuple_ids bigint[];
BEGIN

  -- first of all, find out the toastable table
  SELECT reltoastrelid, reltoastrelid::regclass, pg_relation_filepath( reltoastrelid::regclass )
  INTO   toast_oid, toast_tablez, toast_filename
  FROM   pg_class
  WHERE  relname = tablez
  AND    relkind = 'r';

  -- check that the table has the potential data toasted!
  IF toast_oid IS NULL OR toast_oid = 0 THEN
     RAISE NOTICE 'The table % does not have any toast data associated!', tablez;
     RETURN;
  END IF;



  RAISE DEBUG 'Toast table % with OID % (on disk [%])',
                     toast_tablez,
                     toast_oid,
                     toast_filename;


  -- dynamically create a query to select all the records
  query_pk = format( 'SELECT %I FROM %I ORDER BY 1', pk, tablez );
  IF tuple_limit > 0 THEN
     query_pk = format( '%s LIMIT %s', query_pk, tuple_limit );
  END IF;
  IF tuple_offset > 0 THEN
     query_pk = format( '%s OFFSET %s', query_pk, tuple_offset );
  END IF;
  RAISE DEBUG 'Prepared query [%]', query_pk;

  FOR current_pk IN EXECUTE query_pk LOOP
      RAISE DEBUG 'Preparing to de-toast record pk = %', current_pk;
      total_counter = total_counter + 1;

      column_counter = 0;
      query_detoast = 'SELECT ';
      FOR current_column_to_detoast IN SELECT f_enumerate_toastable_columns( tablez ) LOOP

          IF column_counter > 0 THEN
             query_detoast = query_detoast || ' || ';
          END IF;
          query_detoast = query_detoast || format( ' lower( %I::text ) ', current_column_to_detoast );
          column_counter = column_counter + 1;
      END LOOP;

      query_detoast = query_detoast || format( ' FROM %I WHERE %I = %L', tablez, pk, current_pk );
      RAISE DEBUG 'Prepared query [%]', query_detoast;

      BEGIN
         EXECUTE query_detoast
         INTO    current_detoasted_data;

        PERFORM  length( current_detoasted_data );
        RAISE DEBUG 'Succesfully executed query [%]', query_detoast;
        ok_counter = ok_counter + 1;
      EXCEPTION
        WHEN OTHERS THEN
             ko_counter = ko_counter + 1;
             wrong_tuple_ids = array_append( wrong_tuple_ids, current_pk );
             RAISE NOTICE 'Record with % = % of table % has corrupted toast data!', pk, current_pk, tablez;

      END;

  END LOOP;

  RAISE INFO '% record analyzed in table %, % healthy, % with corrupted toast data',
                total_counter,
                tablez,
                ok_counter,
                ko_counter;


  -- compute the damage ratio, only
  -- if tuples have been effecively read
  IF total_counter > 0 THEN
     damage_ratio = ( total_counter - ok_counter ) / total_counter::float * 100;
  END IF;

  RETURN QUERY
  SELECT total_counter AS total,
         ok_counter    AS ok,
         ko_counter    AS ko,
         100 - damage_ratio AS health_ratio,
         damage_ratio       AS damage_ratio,
         format( 'Table %I has %s%% toast data damaged (toast relation %s on disk file [%s])',
                  tablez,
                  damage_ratio,
                  toast_tablez,
                  toast_filename ) AS description,
        wrong_tuple_ids AS damaged_tuple_ids;

END

$CODE$
LANGUAGE plpgsql;
