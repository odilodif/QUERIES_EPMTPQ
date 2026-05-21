--DROP function f_calcule_porcentage_and_get_table_elapsed_percentage60(integer);
CREATE OR REPLACE FUNCTION f_calcule_porcentage_and_get_table_elapsed_percentage60 (crs_id  INT DEFAULT 0)
  RETURNS SETOF  porcentaje_cumplido
	AS $BODY$
	DECLARE 
	_date_inq date;
    _yearsq INT;
		_monthsq INT;
		_daysq INT;		
		_prontuarioq TEXT;
		_number_dtq  TEXT;
		_name_pplq VARCHAR;
		_last_name_pplq VARCHAR;
		_name_crsq  TEXT;
		_crs_idq int;  
		_query TEXT;
		
		
		_days_calcule_now INT;
		_years_to_days int;
		_months_to_days int;
		_days_to_days int;
		_total_days_judgment INT;
		_porcent FLOAT;
		_porcent_around numeric;
		_crs_id int;
		
BEGIN
_years_to_days=0;
_months_to_days=0;
_days_to_days=0;
_crs_id= crs_id;
TRUNCATE TABLE porcentaje_cumplido;
IF _crs_id = 0 THEN 
_query= 'SELECT * FROM detention_all'; 
	FOR _date_inq, _yearsq, _monthsq, _daysq, _prontuarioq, _name_pplq,_last_name_pplq, _number_dtq, _name_crsq,_crs_idq   IN EXECUTE _query LOOP
					BEGIN
					
					_days_calcule_now= (SELECT get_judicial_year_now(_date_inq));

						IF _yearsq > 0 THEN
							_years_to_days =(SELECT years_to_days_judicial(_yearsq));							
							
						END IF;
						IF _monthsq > 0 THEN	
							_months_to_days=(SELECT months_to_days(_monthsq));
							
						END IF;
						_days_to_days=_daysq;
					END;
					_total_days_judgment=_years_to_days+_months_to_days+_days_to_days;
					_porcent=   CAST(_days_calcule_now*100 AS FLOAT)/_total_days_judgment;
					_porcent_around = (SELECT ROUND(cast(_porcent as numeric),2)) ;
					
					--RAISE NOTICE 'procesando % -> % -> % -> % -> %' , _porcent || '%', _days_calcule_now, _total_days_judgment, _prontuarioq, _number_dtq  ;
					INSERT INTO porcentaje_cumplido (porcent_cumplido,dias_a_la_fecha,total_dias_judiciales_impuestos,prontuario,name_ppl, last_name_ppl,numero_detencion,nombre_crs,fecha_in) VALUES(_porcent_around,_days_calcule_now,_total_days_judgment,_prontuarioq,_name_pplq,_last_name_pplq,_number_dtq,_name_crsq,_date_inq);				
					
			END LOOP;	
	RETURN QUERY	 
 SELECT * FROM porcentaje_cumplido WHERE porcent_cumplido BETWEEN 60 AND 69.99;

ELSE
_query= 'SELECT * FROM detention_all WHERE crs_id=' || _crs_id ; 
	FOR _date_inq, _yearsq, _monthsq, _daysq, _prontuarioq, _name_pplq,_last_name_pplq, _number_dtq, _name_crsq,_crs_idq   IN EXECUTE _query LOOP
					BEGIN
					
					_days_calcule_now= (SELECT get_judicial_year_now(_date_inq));

						IF _yearsq > 0 THEN
							_years_to_days =(SELECT years_to_days_judicial(_yearsq));							
							
						END IF;
						IF _monthsq > 0 THEN	
							_months_to_days=(SELECT months_to_days(_monthsq));
							
						END IF;
						_days_to_days=_daysq;
					END;
					_total_days_judgment=_years_to_days+_months_to_days+_days_to_days;
					_porcent=   CAST(_days_calcule_now*100 AS FLOAT)/_total_days_judgment;
					_porcent_around = (SELECT ROUND(cast(_porcent as numeric),2)) ;
					
					--RAISE NOTICE 'procesando % -> % -> % -> % -> %' , _porcent || '%', _days_calcule_now, _total_days_judgment, _prontuarioq, _number_dtq  ;
					
					INSERT INTO porcentaje_cumplido (porcent_cumplido,dias_a_la_fecha,total_dias_judiciales_impuestos,prontuario,name_ppl, last_name_ppl,numero_detencion,nombre_crs,fecha_in) VALUES(_porcent_around,_days_calcule_now,_total_days_judgment,_prontuarioq,_name_pplq,_last_name_pplq,_number_dtq,_name_crsq,_date_inq);				
					
			END LOOP;	
	RETURN QUERY	 
 SELECT * FROM porcentaje_cumplido WHERE porcent_cumplido BETWEEN 60 AND 69.99;
 
 END IF;
END;
$BODY$
language plpgsql;


SELECT f_calcule_porcentage_and_get_table_elapsed_percentage60();