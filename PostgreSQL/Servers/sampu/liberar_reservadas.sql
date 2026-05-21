
SELECT ide_solicitud_detalle, ide_bocam, cantidad_solicitada, cantidad_reservada  FROM solicitud_detalle_item  WHERE ide_solicitud = 8616

new_cantidad_reservado 

SELECT cantidad_reservada - (SUM(det.cantidad_solicitada), 0) FROM solicitud_detalle_item  det 
JOIN solicitud_items sol ON det.ide_solicitud = sol.ide_solicitud 
WHERE det.ide_bocam = 8808  AND sol.ide_boubi = 4 AND sol.estado_solicitud NOT IN ('RECHAZADA','DESPACHADO', 'RECHAZADA BODEGA' ) 



UPDATE  solicitud_detalle_item SET cantidad_reservada = new_cantidad_reservado 