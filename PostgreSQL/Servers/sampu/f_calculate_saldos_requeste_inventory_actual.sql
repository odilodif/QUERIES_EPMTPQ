
--DROP function f_calculate_saldos_request_inventory_actual(INTEGER);
CREATE OR REPLACE FUNCTION f_calculate_saldos_request_inventory_actual( idsol INT )
RETURNS INT
AS 
$BODY$
DECLARE 

_cantidad_saldo_boinv NUMERIC;
testsql text;
_idsol INT;
_ide_bocam INT;
_ide_boubi INT;
_ide_geani INT;
_ide_solicitud INT;
estado_solicitud TEXT;
cantidad_solicitada NUMERIC;
cantidad_disponible NUMERIC;
_cant_reservada NUMERIC;
_cantidad_disponible_real NUMERIC;
_ide_solicitud_detalle INT;
_flag INT;


BEGIN
_idsol= idsol; 
_flag = 1;

testsql =' SELECT 
solcab.ide_solicitud,	
solcab.ide_boubi,
solcab.ide_geani,
soldet.ide_bocam,
soldet.ide_solicitud_detalle,
soldet.cantidad_solicitada,	
soldet.cantidad_disponible,
soldet.cantidad_reservada,	
soldet.cantidad_disponible_real,
soldet.ide_bounm,
solcab.estado_solicitud	
FROM solicitud_items solcab
INNER JOIN  solicitud_detalle_item soldet  ON   solcab.ide_solicitud = soldet.ide_solicitud
WHERE solcab.ide_solicitud =' || _idsol ;
FOR  _ide_solicitud, _ide_boubi , _ide_geani, _ide_bocam,_ide_solicitud_detalle  IN EXECUTE testsql 
LOOP 

		_cant_reservada = (SELECT COALESCE(SUM(det.cantidad_solicitada), 0) AS total FROM solicitud_detalle_item det JOIN solicitud_items sol ON det.ide_solicitud = sol.ide_solicitud  WHERE det.ide_bocam = _ide_bocam AND sol.ide_boubi = ide_boubi  AND sol.estado_solicitud NOT IN ('RECHAZADA','DESPACHADO', 'RECHAZADA BODEGA' ) );

		_cantidad_saldo_boinv = ( SELECT inv1.cantidad_saldo_boinv   FROM bodt_bodega_inventario inv1 WHERE inv1.ide_bocam = _ide_bocam AND  inv1.ide_boubi = _ide_boubi  AND inv1.ide_geani = _ide_geani );

		_cantidad_disponible_real = _cantidad_saldo_boinv -_cant_reservada;


		UPDATE solicitud_detalle_item  SET cantidad_reservada =  _cant_reservada,  cantidad_disponible =  _cantidad_saldo_boinv , cantidad_disponible_real =  _cantidad_disponible_real WHERE ide_solicitud_detalle = _ide_solicitud_detalle;

				IF _cantidad_disponible_real <  0 THEN
							_flag = 0;							
							
				END IF;
				
				IF _cantidad_disponible_real = 0 THEN	
							_flag = 0;
							
				END IF;

		--RAISE NOTICE  'PROCESANDO %  % % %  % ', _ide_solicitud , _ide_bocam, _cantidad_disponible_real , _cantidad_saldo_boinv,_cant_reservada ;


END LOOP;

RETURN _flag;
END
$BODY$
language plpgsql;

SELECT f_calculate_saldos_request_inventory_actual(8460);


DO $$ BEGIN PERFORM f_calculate_saldos_request_inventory_actual(8460); END; $$;




/******************************************************************************/

--drop PROCEDURE p_calculate_saldos_request_inventory_actual(INT);


/**************************************************************************/

CREATE OR REPLACE PROCEDURE p_calculate_saldos_request_inventory_actual(idsol INT)
LANGUAGE plpgsql
AS $$
DECLARE 
    _cantidad_saldo_boinv NUMERIC;
    testsql TEXT;
    _ide_bocam INT;
    _ide_boubi INT;
    _ide_geani INT;
    _ide_solicitud INT;
    _ide_solicitud_detalle INT;
    _cant_reservada NUMERIC;
    _cantidad_disponible_real NUMERIC;
    _flag INT := 1;
BEGIN
    testsql := 'SELECT 
        solcab.ide_solicitud,	
        solcab.ide_boubi,
        solcab.ide_geani,
        soldet.ide_bocam,
        soldet.ide_solicitud_detalle
    FROM solicitud_items solcab
    INNER JOIN solicitud_detalle_item soldet  
        ON solcab.ide_solicitud = soldet.ide_solicitud
    WHERE solcab.ide_solicitud = ' || idsol;

    FOR _ide_solicitud, _ide_boubi, _ide_geani, _ide_bocam, _ide_solicitud_detalle  
    IN EXECUTE testsql 
    LOOP 
        _cant_reservada := COALESCE((
            SELECT SUM(det.cantidad_solicitada)
            FROM solicitud_detalle_item det 
            JOIN solicitud_items sol 
                ON det.ide_solicitud = sol.ide_solicitud
            WHERE det.ide_bocam = _ide_bocam 
              AND sol.ide_boubi = _ide_boubi  
              AND sol.estado_solicitud NOT IN ('RECHAZADA','DESPACHADO','RECHAZADA BODEGA')
        ),0);

        _cantidad_saldo_boinv := (
            SELECT inv1.cantidad_saldo_boinv   
            FROM bodt_bodega_inventario inv1 
            WHERE inv1.ide_bocam = _ide_bocam 
              AND inv1.ide_boubi = _ide_boubi  
              AND inv1.ide_geani = _ide_geani
        );

        _cantidad_disponible_real := _cantidad_saldo_boinv - _cant_reservada;

        UPDATE solicitud_detalle_item  
        SET cantidad_reservada = _cant_reservada,  
            cantidad_disponible = _cantidad_saldo_boinv, 
            cantidad_disponible_real = _cantidad_disponible_real 
        WHERE ide_solicitud_detalle = _ide_solicitud_detalle;

        IF _cantidad_disponible_real <= 0 THEN
            _flag := 0;
        END IF;
    END LOOP;
END;
$$;




call p_calculate_saldos_request_inventory_actual(8460)




