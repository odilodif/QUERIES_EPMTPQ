SELECT descripcion_bocam FROM bodt_catalogo_material WHERE ide_bocam = 9409

SELECT descripcion_bocam FROM bodt_catalogo_material WHERE ide_bocam = 9409

SELECT ide_corr, smtp_corr, puerto_corr, usuario_corr, correo_corr, clave_corr from sis_correo where ide_corr=3;



SELECT * FROM bodt_catalogo_material WHERE ide_bocam = 9409;
SELECT  * FROM solicitud_detalle_item

SELECT  * FROM solicitud_detalle_item   sd WHERE sd.ide_solicitud = 73 ORDER BY 1 ASC;


SELECT COALESCE(SUM(det.cantidad_solicitada), 0) AS total 
FROM solicitud_detalle_item det 
JOIN solicitud_items sol ON det.ide_solicitud = sol.ide_solicitud  
WHERE det.ide_bocam = 7 AND sol.estado_solicitud IN ('PROCESADA', 'APROBADA')