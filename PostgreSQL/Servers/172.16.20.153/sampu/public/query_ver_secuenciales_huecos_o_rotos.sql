SELECT *
FROM (
    SELECT ide_solicitud_detalle, 
           LAG(ide_solicitud_detalle) OVER (ORDER BY ide_solicitud_detalle) AS previo,
           ide_solicitud_detalle - LAG(ide_solicitud_detalle) OVER (ORDER BY ide_solicitud_detalle) AS diferencia
    FROM solicitud_detalle_item 
) sub
WHERE diferencia > 1;