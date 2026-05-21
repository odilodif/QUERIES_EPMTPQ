DO $f$
DECLARE
    _date_in date;
    _years INT;
		_months INT;
		_days INT;
		_query TEXT;
		
BEGIN
_years= 2;
_days=0;
FOR counter IN  1.._years LOOP
_days=_days+360;
	RAISE NOTICE 'procesando % ' , _days;
END LOOP;
END;
$f$

CREATE OR REPLACE FUNCTION years_to_days_judicial(years INTEGER) RETURNS INTEGER AS	$$
DECLARE
_days int;

BEGIN
_days=0;
FOR counter IN  1..years LOOP
_days=_days+360;
	--RAISE NOTICE 'procesando % ' , _days;
END LOOP;
RETURN _days;
END;
$$ LANGUAGE plpgsql;


SELECT years_to_days_judicial(12);

