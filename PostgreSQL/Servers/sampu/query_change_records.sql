 SELECT
 cod_anterior_afact /* AS "CODIGO UNICO"*/,
 valor_neto_afact /* AS "VALOR SIN IVA"*/, 
 valor_compra_afact /*AS "VALOR CON IVA"*/,
 valor_unitario_afact /*AS "COSTO DE ADQUISICION"*/,
 valor_compra_afact_temp /* AS "VALOR_COMPRA_AFACT_TEMP"*/,
 VALOR_INC_IVA_AFACT /*AS "VALOR_INC_IVA_AFACT"*/
 FROM public.afi_activo   
 WHERE cod_anterior_afact IN (25655,25656,25657);
 
 /************************************************/
 
 UPDATE 
 public.afi_activo
 SET 
 valor_neto_afact = 49695.3500 , 
 valor_compra_afact = 49695.3500,
 valor_unitario_afact = 49695.3500,
 valor_compra_afact_temp = 49695.3500,
 VALOR_INC_IVA_AFACT = 49695.3500 
 WHERE cod_anterior_afact IN (25655,25656,25657);