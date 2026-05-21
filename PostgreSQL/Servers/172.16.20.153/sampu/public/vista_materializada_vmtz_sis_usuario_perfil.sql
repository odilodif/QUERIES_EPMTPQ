/*SELECT DISTINCT nick_usua  FROM sis_usuario usr
INNER JOIN vmtz_sis_usuario_perfil vm ON vm.ide_usua= usr.ide_usua
 
 
 UPDATE sis_usuario_perfil SET ide_perf = NULL  WHERE ide_uspe=1038; --ide_perf = 132
 
 
SELECT * from sis_usuario_perfil WHERE ide_uspe=1038;*/




/**************  1. PREPARACION DEL SELECT CON LOS PERFILES RESPECTIVOS ******************************/

SELECT *  FROM sis_usuario_perfil WHERE ide_perf IN (
128
,127
,131
,128
,122
,134
,132
,139
,125
,126
,138
,133
,120
)

/********************* 2.- CREACION DE LA VISTA MATERIALIZADA *********************/

--DROP  MATERIALIZED VIEW  vmtz_sis_usuario_perfil
 CREATE MATERIALIZED VIEW vmtz_sis_usuario_perfil 
 AS
SELECT *  FROM sis_usuario_perfil WHERE ide_perf IN (
128
,127
,131
,128
,122
,134
,132
,139
,125
,126
,138
,133
,120
)

/***********************   3.- VERIFICACION DE LA CREACION DE LA VISTA MATERIALIZADA ****************************/

SELECT * FROM vmtz_sis_usuario_perfil WHERE ide_usua = 352



/****************************************************** 
 4. DESHABILITAR
 
 *******************************************************/
 




DO $$
DECLARE
    _ide_uspe INT;
    _ide_usua INT;
BEGIN
    -- 1. Iterar sobre los resultados de la consulta
    FOR _ide_uspe, _ide_usua IN SELECT ide_uspe, ide_usua FROM vmtz_sis_usuario_perfil
    LOOP
        -- 2. La lógica de la condición
        IF _ide_usua <> 352 THEN
            -- 3. Actualización de la tabla
            UPDATE sis_usuario_perfil
            SET ide_perf = NULL
            WHERE ide_uspe = _ide_uspe;

            -- 4. Notificación
            RAISE NOTICE 'Data for ID % is NULL', _ide_uspe;
        END IF;
    END LOOP;
END $$;



/**************************************
5. REHABILITAR
****************************************/


 DO $f$
DECLARE  
    _ide_uspe INT; 
    _ide_perf INT;
BEGIN
			FOR _ide_uspe, _ide_perf IN SELECT ide_uspe,ide_perf FROM vmtz_sis_usuario_perfil LOOP
					BEGIN
					UPDATE sis_usuario_perfil SET ide_perf = _ide_perf  WHERE ide_uspe=_ide_uspe;
							RAISE NOTICE 'Data for _ide_uspe % and _ide_perf % is updated', _ide_uspe,_ide_perf ;
					END;
			END LOOP;
END;
$f$
 
 
 