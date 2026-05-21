	CREATE VIEW v_proveedores_subquery
		AS
		SELECT 
            b.ide_tepro, 
            COALESCE(ruc_representante_tepro, ruc_tepro) AS ruc_tepro,
            SUBSTRING(nombre_tepro FROM 1 FOR 30) AS nombre_tepro 
        FROM tes_proveedor b 
/*****************************************************************/		
	CREATE VIEW v_empleados_subquery
		AS
SELECT 
            par.ide_geedp,
            SUBSTRING(
                APELLIDO_PATERNO_GTEMP || ' ' || 
                (CASE WHEN APELLIDO_MATERNO_GTEMP IS NULL THEN '' ELSE APELLIDO_MATERNO_GTEMP END) || ' ' || 
                PRIMER_NOMBRE_GTEMP || ' ' || 
                (CASE WHEN SEGUNDO_NOMBRE_GTEMP IS NULL THEN '' ELSE SEGUNDO_NOMBRE_GTEMP END)  
            FROM 1 FOR 30) AS NOMBRES,
            DOCUMENTO_IDENTIDAD_GTEMP AS ruc_emp    
        FROM GEN_EMPLEADOS_DEPARTAMENTO_PAR par    
        LEFT JOIN GTH_EMPLEADO emp ON par.ide_gtemp = emp.ide_gtemp
				
/**********************v_detalle_movimiento_auxiliar_111_06**************************/

CREATE VIEW v_detalle_movimiento_auxiliar_111_06
AS
 SELECT DISTINCT 
            dmov.ide_comov,
            ide_gelua, 
            CAST('111.06.00' AS CHARACTER(25)) AS cue_codigo_cocac    
        FROM cont_detalle_movimiento dmov    
        JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac AND (cue_codigo_cocac LIKE '111.06%')    
        WHERE COALESCE(haber_codem, 0) > 0
				
				