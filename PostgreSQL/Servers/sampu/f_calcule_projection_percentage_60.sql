CREATE OR REPLACE FUNCTION f_calcule_projection_percentage_60 (crs_id  INT DEFAULT 0, date_projection date DEFAULT '1900-01-01')  RETURNS SETOF  projection_percentage
	AS $BODY$
	DECLARE 
	_projection_date date;
    _date_inq date;
    _yearsq INT;
		_monthsq INT;
		_daysq INT;		
		_prontuarioq TEXT;
		_nameppl VARCHAR;	
		_last_nameppl VARCHAR;
		_number_dtq  VARCHAR;
		_name_crsq  TEXT;
		_crs_idq int;
		_query TEXT;
		
		
		_days_calcule_projection INT;
		_years_to_days int;
		_months_to_days int;
		_days_to_days int;
		_total_days_judgment INT;
		_porcent FLOAT;
		_crs_id int;
BEGIN
_years_to_days=0;
_months_to_days=0;
_days_to_days=0;
_crs_id= crs_id;
_projection_date=date_projection;
TRUNCATE TABLE projection_percentage;
IF _crs_id = 0 THEN 
_query= 'SELECT * FROM detention_all'; 
	FOR _date_inq, _yearsq, _monthsq, _daysq, _prontuarioq,_nameppl,_last_nameppl, _number_dtq, _name_crsq,_crs_id   IN EXECUTE _query LOOP
					BEGIN
					
					_days_calcule_projection= (SELECT f_get_judicial_days_proyection(_projection_date,_date_inq));

						IF _yearsq > 0 THEN
							_years_to_days =(SELECT years_to_days_judicial(_yearsq));							
							
						END IF;
						IF _monthsq > 0 THEN	
							_months_to_days=(SELECT months_to_days(_monthsq));
							
						END IF;
						_days_to_days=_daysq;
					END;
					_total_days_judgment=_years_to_days+_months_to_days+_days_to_days;
					_porcent=   CAST(_days_calcule_projection*100 AS FLOAT)/_total_days_judgment;
					
					
					INSERT INTO projection_percentage (porcent_cumplido,dias_proyectados,total_dias_judiciales_impuestos,prontuario,name_ppl,last_name_ppl,numero_detencion,nombre_crs,fecha_in,date_projection) 
					VALUES(_porcent,_days_calcule_projection,_total_days_judgment,_prontuarioq,_nameppl,_last_nameppl,_number_dtq,_name_crsq,_date_inq,_projection_date);		
					
			END LOOP;	
	RETURN QUERY	 
 SELECT * FROM projection_percentage WHERE porcent_cumplido BETWEEN 60 AND 69.99;

ELSE
_query= 'SELECT * FROM detention_all WHERE crs_id=' || _crs_id ; 
	FOR _date_inq, _yearsq, _monthsq, _daysq, _prontuarioq,_nameppl,_last_nameppl, _number_dtq, _name_crsq,_crs_id   IN EXECUTE _query LOOP
					BEGIN
					
					_days_calcule_projection= (SELECT f_get_judicial_days_proyection(_projection_date,_date_inq));

						IF _yearsq > 0 THEN
							_years_to_days =(SELECT years_to_days_judicial(_yearsq));							
							
						END IF;
						IF _monthsq > 0 THEN	
							_months_to_days=(SELECT months_to_days(_monthsq));
							
						END IF;
						_days_to_days=_daysq;
					END;
					_total_days_judgment=_years_to_days+_months_to_days+_days_to_days;
					_porcent=   CAST(_days_calcule_projection*100 AS FLOAT)/_total_days_judgment;
					
					
					INSERT INTO projection_percentage (porcent_cumplido,dias_proyectados,total_dias_judiciales_impuestos,prontuario,name_ppl,last_name_ppl,numero_detencion,nombre_crs,fecha_in,date_projection) 
					VALUES(_porcent,_days_calcule_projection,_total_days_judgment,_prontuarioq,_nameppl,_last_nameppl,_number_dtq,_name_crsq,_date_inq,_projection_date);		
					
			END LOOP;	
	RETURN QUERY	 
  SELECT * FROM projection_percentage WHERE porcent_cumplido BETWEEN 60 AND 69.99;
 
 END IF;
END;
$BODY$
LANGUAGE plpgsql;


SELECT f_calcule_projection_percentage_60(0,'2021-11-01');