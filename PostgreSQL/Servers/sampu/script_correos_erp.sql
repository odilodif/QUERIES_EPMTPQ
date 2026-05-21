DO $f$
DECLARE
    query_excel TEXT;
    query_erp TEXT;
    _cedula_excel TEXT;
    _correo_excel TEXT;
    _cedula_erp TEXT;
    _correo_erp TEXT;

BEGIN

query_excel= 'SELECT cedula_excel,correo_excel FROM temp_cruce_correo';
query_erp  = 'select cedula_erp, correo_erp from temp_cruce_correo_erp';


FOR _cedula_excel, _correo_excel   IN EXECUTE query_excel LOOP

FOR _cedula_erp, _correo_erp   IN EXECUTE query_erp LOOP

IF _cedula_excel = _cedula_erp THEN
UPDATE temp_cruce_correo_erp SET correo_erp =  _correo_excel WHERE  _cedula_erp = _cedula_excel;
RAISE NOTICE ' update cedula_excel % cedula_erp  % ',  _cedula_excel, _cedula_erp ;

END IF;

END LOOP;

END LOOP;
END;
$f$