CREATE OR REPLACE FUNCTION f_enumerate_toastable_columns( tablez oid )
 RETURNS SETOF text
 AS $CODE$

DECLARE
BEGIN
-- the pg_attribute.attstorage stores a letter
-- to indicate the type of storage. Usually this is a clone
-- of what is set up in the pg_type catalog, but can be changed
-- depending on the value of the column field

RETURN QUERY
SELECT attname::text
FROM   pg_attribute
WHERE  attrelid = tablez
AND    attstorage IN ('x', 'e')  -- x = extended,  e = external
;
END

$CODE$
LANGUAGE plpgsql;
