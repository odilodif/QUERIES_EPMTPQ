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
_date_proyection='2021-09-09';
_days=0;

_days=(SELECT
   (CASE WHEN DATE_PART('year', AGE(now(), '2011-09-13')) >0 THEN DATE_PART('year', AGE(now(), '2011-09-13')) * 360 ELSE 0 END) + (CASE WHEN DATE_PART('month', AGE(now(), '2011-09-13')) >0 THEN DATE_PART('month', AGE(now(), '2011-09-13')) * 30 ELSE 0 END) + ( DATE_PART('day', AGE(now(), '2011-09-13')))  AS total_days);
RAISE NOTICE 'result= %' _days;
END;
$f$


--DROP function get_judicial_year(date);

CREATE OR REPLACE FUNCTION get_judicial_year_now(dat date) RETURNS integer AS $$
        BEGIN
              RETURN  (SELECT (CASE WHEN DATE_PART('year', AGE(now(), dat)) >0 THEN DATE_PART('year', AGE(now(), dat)) * 360 ELSE 0 END) + (CASE WHEN DATE_PART('month', AGE(now(), dat)) >0 THEN DATE_PART('month', AGE(now(), dat)) * 30 ELSE 0 END) + ( DATE_PART('day', AGE(now(), dat))));
        END;
$$ LANGUAGE plpgsql;


SELECT get_judicial_year_now('2019-02-02');




SELECT ('2021-07-28'::date -  '2019-02-02'::date) AS days;


SELECT
  AGE(now(), '2011-09-13') as age_nomal,
  CASE WHEN DATE_PART('year', AGE(now(), '2011-09-13')) >0 THEN DATE_PART('year', AGE(now(), '2011-09-13')) * 360 ELSE 0 END  AS years_to_days,
   CASE WHEN DATE_PART('month', AGE(now(), '2011-09-13')) >0 THEN DATE_PART('month', AGE(now(), '2011-09-13')) * 60 ELSE 0 END AS months_to_days,
  DATE_PART('day', AGE(now(), '2011-09-13')) AS days, (CASE WHEN DATE_PART('year', AGE(now(), '2011-09-13')) >0 THEN DATE_PART('year', AGE(now(), '2011-09-13')) * 360 ELSE 0 END) + (CASE WHEN DATE_PART('month', AGE(now(), '2011-09-13')) >0 THEN DATE_PART('month', AGE(now(), '2011-09-13')) * 60 ELSE 0 END) + ( DATE_PART('day', AGE(now(), '2011-09-13')))  AS total_days;
	
	
	
SELECT  AGE(now(), '2019-02-02') as age_nomal;