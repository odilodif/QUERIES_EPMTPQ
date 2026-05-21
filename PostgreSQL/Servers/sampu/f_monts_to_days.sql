DO $f$
DECLARE
   
		_months INT;
		_days INT;
	
		
BEGIN
_months= 1;
_days=0;
FOR counter IN  1.._months LOOP
_days=_days+60;
	RAISE NOTICE 'procesando % ' , _days;
END LOOP;
END;
$f$

CREATE OR REPLACE FUNCTION months_to_days(months integer) RETURNS integer AS $$
DECLARE 
_days INT;
BEGIN
_days=0;
  FOR counter IN  1..months LOOP
		_days=_days+30;
	  --RAISE NOTICE 'procesando % ' , _days;
	END LOOP; 
	
	RETURN _days;

END;
$$ LANGUAGE plpgsql;


SELECT months_to_days(1);
