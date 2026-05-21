SELECT nro_ingreso::TEXT,	fecha_ingeg::TEXT,	descripcion_bocam ,	bodega ,	ingreso_cantidad::TEXT ,	egreso_cantidad 
FROM view_kardex_details
WHERE ide_bocam=8808 AND ide_geani=9 

UNION ALL

SELECT ' ',		' ',inicial,	inicial_cantidad::TEXT  ,	total_ingresos ,	total_egresos FROM view_only_kardex


