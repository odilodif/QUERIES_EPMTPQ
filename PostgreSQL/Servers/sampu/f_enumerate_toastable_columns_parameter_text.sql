CREATE OR REPLACE FUNCTION f_enumerate_toastable_columns( tablez text )
RETURNS SETOF text
AS $CODE$

DECLARE
BEGIN
  RETURN QUERY SELECT f_enumerate_toastable_columns( tablez::regclass );
END

$CODE$
LANGUAGE plpgsql;
