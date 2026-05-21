CREATE OR REPLACE f_create_record_bodt_bodega_inv_resumen_whether_not_exist(  idbocam INT, idyear_active INT, usersis VARCHAR  )  
RETURNS INT
AS
$BODY$
DECLARE
_idbocam INT;
_idyear_active INT; 
_usersis VARCHAR;

BEGIN
_idbocam = idbocam;
_idyear_active = idyear_active; 
_usersis = _usersis;

IF NOT EXISTS (SELECT ide_bocam,* FROM bodt_inventario_resumen WHERE id_bocam = ||_idbocam AND ide_geani = || _idyear_active   )

			INSERT INTO bodt_inventario_resumen (
					ide_inres,
					ide_bocam,
					ide_geani,
					costo_medio_unidad_inres,
					costo_medio_unidad_inc_iva_inres,
					pmp_existencia_inres,
					usuario_ingre,
					fecha_ingre,
					hora_ingre,
					usuario_actua,
					fecha_actua,
					hora_actua
			)
			VALUES (
					(SELECT COALESCE(MAX(ide_inres), 0) + 1 FROM bodt_inventario_resumen),
					_idbocam,
					9,
					0,
					0,
					0,
					_usersis,
					CURRENT_DATE,
					NOW()::time,
					_usersis,
					CURRENT_DATE,
					NOW()::time
			);
END IF;


END
$BODY$
LANGUAGE plpgsql


/***************PROCEDURE *******************/

CREATE OR REPLACE PROCEDURE p_create_record_bodt_bodega_inv_resumen_whether_not_exist(  IN p_idbocam INT, IN p_idyear_active INT, IN p_usersis VARCHAR)
LANGUAGE plpgsql
AS
$$
BEGIN
    -- Validación de existencia
    IF NOT EXISTS (SELECT 1 FROM bodt_inventario_resumen WHERE ide_bocam = p_idbocam AND ide_geani = p_idyear_active ) THEN
        -- Inserción si no existe
        INSERT INTO bodt_inventario_resumen (
            ide_inres,
            ide_bocam,
            ide_geani,
            costo_medio_unidad_inres,
            costo_medio_unidad_inc_iva_inres,
            pmp_existencia_inres,
            usuario_ingre,
            fecha_ingre,
            hora_ingre,
            usuario_actua,
            fecha_actua,
            hora_actua
        )
        VALUES (
            (SELECT COALESCE(MAX(ide_inres), 0) + 1 FROM bodt_inventario_resumen),
            p_idbocam,
            p_idyear_active,
            0,
            0,
            0,
            p_usersis,
            CURRENT_DATE,
            NOW()::time,
            p_usersis,
            CURRENT_DATE,
            NOW()::time
        );
    END IF;
END;
$$;


SELECT 1 FROM bodt_inventario_resumen WHERE ide_bocam = 10254 AND ide_geani = p_idyear_active


CALL p_create_record_bodt_bodega_inv_resumen_whether_not_exist(8019, 9, 'admin');


