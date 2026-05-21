WITH param AS (     

SELECT     3  as ide_inttr_t_ingreso,     4  as ide_inttr_t_egreso,     8725 as ide_ingeg     

 ),
 nuevo_pk AS 
(    

SELECT 1 AS ide,(CASE WHEN max(ide_ingeg) IS NULL THEN 0 ELSE max(ide_ingeg) END) + 1 AS codigo FROM bodt_ingreso_egreso 

), cabecera_transferencia_ingreso AS ( 
    
SELECT (SELECT ide_inttr_t_ingreso FROM param) as ide_inttr, 
ide_adfac, 
ide_adfac_antigua, 
ide_boubi as ide_boubi_transferencia,       
ide_geani, 
ide_gtemp,
ide_gtemp_jefe_solicitante, 
ide_gtemp_solicitante,       
ide_prcer, 
fecha_ingeg,
observacion_ingeg, 
activo_ingeg, 
subtotal_ingeg,     
valor_iva_ingeg, 
total_ingeg,
usuario_ingre, 
fecha_ingre, 
hora_ingre,      
usuario_actua, fecha_actua, 
hora_actua, numero_documento_ingeg,     
ide_boubi_transferencia as ide_boubi, 
ide_ingeg_ref     
FROM bodt_ingreso_egreso     
WHERE ide_ingeg = (SELECT ide_ingeg FROM param)  	
AND ide_inttr =  (SELECT ide_inttr_t_egreso FROM param) 

)
--SELECT * FROM cabecera_transferencia_ingreso
,

 insert_cabecera_ingreso AS (    

INSERT INTO bodt_ingreso_egreso( 	    
ide_ingeg,             
ide_inttr, 
ide_adfac, 
ide_adfac_antigua, 
ide_boubi,              
ide_geani, 
ide_gtemp, 
ide_gtemp_jefe_solicitante, 
ide_gtemp_solicitante,             
ide_prcer, 
fecha_ingeg, 
observacion_ingeg, 
activo_ingeg, 
subtotal_ingeg,             
valor_iva_ingeg, 
total_ingeg, 
usuario_ingre, 
fecha_ingre, 
hora_ingre,            
usuario_actua, 
fecha_actua, 
hora_actua, 
numero_documento_ingeg,              
ide_boubi_transferencia,  
ide_ingeg_ref

) 
 SELECT         
(SELECT codigo FROM nuevo_pk),        
ide_inttr, 
ide_adfac, 
ide_adfac_antigua, 
ide_boubi,         
ide_geani, 
ide_gtemp, 
ide_gtemp_jefe_solicitante, 
ide_gtemp_solicitante,         
ide_prcer, 
fecha_ingeg, 
observacion_ingeg, 
activo_ingeg, 
subtotal_ingeg,         
valor_iva_ingeg, 
total_ingeg,
usuario_ingre, 
fecha_ingre, 
hora_ingre,         
usuario_actua, 
fecha_actua, 
hora_actua, 
numero_documento_ingeg,         
ide_boubi_transferencia, 
(SELECT ide_ingeg FROM param) as ide_ingeg_ref      
FROM cabecera_transferencia_ingreso       
WHERE ide_inttr = SELECT ide_inttr_t_ingreso FROM param 

)

--SELECT * FROM insert_cabecera_ingreso

,update_cabecera_egreso AS (     

UPDATE bodt_ingreso_egreso SET ide_ingeg_ref = (SELECT codigo FROM nuevo_pk) WHERE ide_ingeg = (SELECT ide_ingeg FROM param)  

), nuevo_pk_detalle AS (    

SELECT 1 AS ide,(CASE WHEN max(ide_inegd) IS NULL THEN 0 ELSE max(ide_inegd) END) + 1 AS codigo FROM bodt_ingreso_egreso_det 


)    INSERT INTO bodt_ingreso_egreso_det(
  ide_inegd, 
	ide_bocam, 
	ide_ingeg, 
	ide_inttr, 
	ide_addef, 
	ide_afest,              
	costo_unitario_inegd, 
	costo_unitario_inc_iva_inegd, 
	subtotal_inegd, 
	valor_iva_inegd, 
	cantidad_inegd,              
	aplica_iva_inegd, 
	total_inegd, 
	usuario_ingre, 
	fecha_ingre, 
	hora_ingre,         
	usuario_actua, 
	fecha_actua, 
	hora_actua, 
	marca_inegd, 
	modelo_inegd,             
	color_inegd, 
	fecha_vencimiento_inegd, 
	peligro_salud_inegd, 
	peligro_inflamabilidad_inegd,              
	peligro_reactividad_inegd, 
	manejo_especial_inegd, 
	saldo_disponible_inegd,              
	ide_bounm, 
	ide_bounm_presentacion, 
	valor_existencia_inegd
	
	)     SELECT
	
	 (SELECT codigo FROM nuevo_pk_detalle) +ROW_NUMBER() OVER (ORDER BY ide_inegd) -1 , 
	 ide_bocam,
	(SELECT codigo FROM nuevo_pk) AS ide_ingeg,
	 (SELECT ide_inttr_t_ingreso FROM param) as ide_inttr, 
	 ide_addef, 
	 ide_afest,         
	 costo_unitario_inegd, 
	 costo_unitario_inc_iva_inegd, 
	 subtotal_inegd, 
	 valor_iva_inegd, 
	 cantidad_inegd,         
	 aplica_iva_inegd, 
	 total_inegd, 
	 usuario_ingre, 
	 fecha_ingre, 
	 hora_ingre,         
	 usuario_actua, 
	 fecha_actua, 
	 hora_actua, 
	 marca_inegd, 
	 modelo_inegd,         
	 color_inegd, 
	 fecha_vencimiento_inegd, 
	 peligro_salud_inegd, 
	 peligro_inflamabilidad_inegd,         
	 peligro_reactividad_inegd, 
	 manejo_especial_inegd, 
	 saldo_disponible_inegd,         
	 ide_bounm, 
	 ide_bounm_presentacion, 
	 valor_existencia_inegd    
	 FROM bodt_ingreso_egreso_det     
	 WHERE ide_ingeg = (SELECT ide_ingeg FROM param) 
	 AND ide_inttr = (SELECT ide_inttr_t_egreso FROM param) 
	
	
	 
	 
	 /**********************************************/
	 
	 drop procedure p_sent_transfer_to_bod_destination(INT,INT,INT);
	 
	 /******************************************************/
	 
	 CREATE OR REPLACE PROCEDURE p_sent_transfer_to_bod_destination(
    IN p_ide_ingeg INT,
    IN p_ide_inttr_t_egreso INT, --4
    IN p_ide_inttr_t_ingreso INT --3
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_new_ide_ingeg   INT;
    v_new_ide_inegd   INT;
BEGIN
    ------------------------------------------------------------------
    -- 1. Generar nuevo PK para cabecera (bodt_ingreso_egreso)
    ------------------------------------------------------------------
    SELECT COALESCE(MAX(ide_ingeg), 0) + 1
    INTO v_new_ide_ingeg --8726
    FROM bodt_ingreso_egreso;

    ------------------------------------------------------------------
    -- 2. Insertar cabecera de ingreso copiando de la cabecera de egreso
    ------------------------------------------------------------------
    INSERT INTO bodt_ingreso_egreso(
        ide_ingeg,
        ide_inttr,
        ide_adfac,
        ide_adfac_antigua,
        ide_boubi_transferencia,
        ide_geani,
        ide_gtemp,
        ide_gtemp_jefe_solicitante,
        ide_gtemp_solicitante,
        ide_prcer,
        fecha_ingeg,
        observacion_ingeg,
        activo_ingeg,
        subtotal_ingeg,
        valor_iva_ingeg,
        total_ingeg,
        usuario_ingre,
        fecha_ingre,
        hora_ingre,
        usuario_actua,
        fecha_actua,
        hora_actua,
        numero_documento_ingeg,
        ide_boubi,
        ide_ingeg_ref
    )
    SELECT 
        v_new_ide_ingeg,
				p_ide_inttr_t_ingreso,
        ide_adfac,
        ide_adfac_antigua,
        ide_boubi,
        ide_geani,
        ide_gtemp,
        ide_gtemp_jefe_solicitante,
        ide_gtemp_solicitante,
        ide_prcer,
        fecha_ingeg,
        observacion_ingeg,
        activo_ingeg,
        subtotal_ingeg,
        valor_iva_ingeg,
        total_ingeg,
        usuario_ingre,
        fecha_ingre,
        hora_ingre,
        usuario_actua,
        fecha_actua,
        hora_actua,
        numero_documento_ingeg,
        ide_boubi_transferencia,
        p_ide_ingeg
    FROM bodt_ingreso_egreso
    WHERE ide_ingeg =  p_ide_ingeg::INT
      AND ide_inttr =  p_ide_inttr_t_egreso::INT;

    ------------------------------------------------------------------
    -- 3. Actualizar cabecera de egreso con referencia al nuevo ingreso
    ------------------------------------------------------------------
    UPDATE bodt_ingreso_egreso
    SET ide_ingeg_ref = v_new_ide_ingeg
    WHERE ide_ingeg = p_ide_ingeg::INT;

    ------------------------------------------------------------------
    -- 4. Generar nuevo PK para detalle (bodt_ingreso_egreso_det)
    ------------------------------------------------------------------
    SELECT COALESCE(MAX(ide_inegd), 0) + 1
    INTO v_new_ide_inegd
    FROM bodt_ingreso_egreso_det;

    ------------------------------------------------------------------
    -- 5. Insertar detalles
    ------------------------------------------------------------------
    INSERT INTO bodt_ingreso_egreso_det(
        ide_inegd,
        ide_bocam,
        ide_ingeg,
        ide_inttr,
        ide_addef,
        ide_afest,
        costo_unitario_inegd,
        costo_unitario_inc_iva_inegd,
        subtotal_inegd,
        valor_iva_inegd,
        cantidad_inegd,
        aplica_iva_inegd,
        total_inegd,
        usuario_ingre,
        fecha_ingre,
        hora_ingre,
        usuario_actua,
        fecha_actua,
        hora_actua,
        marca_inegd,
        modelo_inegd,
        color_inegd,
        fecha_vencimiento_inegd,
        peligro_salud_inegd,
        peligro_inflamabilidad_inegd,
        peligro_reactividad_inegd,
        manejo_especial_inegd,
        saldo_disponible_inegd,
        ide_bounm,
        ide_bounm_presentacion,
        valor_existencia_inegd
    )
    SELECT
        v_new_ide_inegd + ROW_NUMBER() OVER (ORDER BY ide_inegd) - 1,
        ide_bocam,
        v_new_ide_ingeg,
        p_ide_inttr_t_ingreso::INT,
        ide_addef,
        ide_afest,
        costo_unitario_inegd,
        costo_unitario_inc_iva_inegd,
        subtotal_inegd,
        valor_iva_inegd,
        cantidad_inegd,
        aplica_iva_inegd,
        total_inegd,
        usuario_ingre,
        fecha_ingre,
        hora_ingre,
        usuario_actua,
        fecha_actua,
        hora_actua,
        marca_inegd,
        modelo_inegd,
        color_inegd,
        fecha_vencimiento_inegd,
        peligro_salud_inegd,
        peligro_inflamabilidad_inegd,
        peligro_reactividad_inegd,
        manejo_especial_inegd,
        saldo_disponible_inegd,
        ide_bounm,
        ide_bounm_presentacion,
        valor_existencia_inegd
    FROM bodt_ingreso_egreso_det
    WHERE ide_ingeg = p_ide_ingeg::INT
      AND ide_inttr = p_ide_inttr_t_egreso::INT;

    RAISE NOTICE 'Nuevo ide_ingeg creado: %', v_new_ide_ingeg;
END;
$$;



--call p_sent_transfer_to_bod_destination(  8725 , 4 ,   3  );

