DO $f$
DECLARE
    _date_in date;
		_date_proyection date;
    _years INT;
		_months INT;
		_days INT;
		_query TEXT;
		
BEGIN
_date_in = '2011-09-13';
_date_proyection='2021-10-09';
_days=0;

_days=(SELECT
   (CASE WHEN DATE_PART('year', AGE(_date_proyection, '2011-09-13')) >0 THEN DATE_PART('year', AGE(_date_proyection, '2011-09-13')) * 360 ELSE 0 END) + (CASE WHEN DATE_PART('month', AGE(_date_proyection, '2011-09-13')) >0 THEN DATE_PART('month', AGE(_date_proyection, '2011-09-13')) * 30 ELSE 0 END) + ( DATE_PART('day', AGE(_date_proyection, '2011-09-13')))  AS total_days);
RAISE NOTICE 'result= %', _days;
END;
$f$

SELECT  AGE('2021-10-09', '2011-09-13') as age_nomal;



CREATE OR REPLACE FUNCTION f_get_judicial_days_proyection(date_proyection date, date_in date)
RETURNS INTEGER
AS $f$
DECLARE
    _date_proyection date;
		_date_in date;		
    _years INT;
		_months INT;
		_days INT;
		_query TEXT;
		
BEGIN
_date_proyection=date_proyection;	
_date_in = date_in;
_days=0;
				
              
RETURN  (SELECT (CASE WHEN DATE_PART('year', AGE(now(), dat)) >0 THEN DATE_PART('year', AGE(now(), dat)) * 360 ELSE 0 END) + (CASE WHEN DATE_PART('month', AGE(now(), dat)) >0 THEN DATE_PART('month', AGE(now(), dat)) * 30 ELSE 0 END) + ( DATE_PART('day', AGE(now(), dat))));
        
				
END;
$f$ LANGUAGE plpgsql;






