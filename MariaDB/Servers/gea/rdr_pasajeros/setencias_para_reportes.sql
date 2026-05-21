/********************SIN FECHAS ********************/
-- Concentrador
SELECT COUNT(id) as totales, concentrador FROM validacion GROUP BY concentrador ORDER BY 2 ASC;

-- Estacion
SELECT COUNT(id) as totales, estacion FROM validacion GROUP BY estacion ORDER BY 2 ASC;

-- Fecha/Hora (fh)
SELECT COUNT(id) as totales, fh FROM validacion GROUP BY fh ORDER BY 2 ASC;

-- Sentido
SELECT COUNT(id) as totales, sentido FROM validacion GROUP BY sentido ORDER BY 2 ASC;

-- Terminal
SELECT COUNT(id) as totales, terminal FROM validacion GROUP BY terminal ORDER BY 2 ASC;

-- Ruta
SELECT COUNT(id) as totales, ruta FROM validacion GROUP BY ruta ORDER BY 2 ASC;

-- Parada
SELECT COUNT(id) as totales, parada FROM validacion GROUP BY parada ORDER BY 2 ASC;

-- Tipo de Medio
SELECT COUNT(id) as totales, tipo_medio FROM validacion GROUP BY tipo_medio ORDER BY 2 ASC;

-- Num Medio
SELECT COUNT(id) as totales, num_medio FROM validacion GROUP BY num_medio ORDER BY 2 ASC;

-- Secuencial
SELECT COUNT(id) as totales, secuencial FROM validacion GROUP BY secuencial ORDER BY 2 ASC;

-- ID QR
SELECT COUNT(id) as totales, id_qr FROM validacion GROUP BY id_qr ORDER BY 2 ASC;

-- Num Envio
SELECT COUNT(id) as totales, num_envio FROM validacion GROUP BY num_envio ORDER BY 2 ASC;

-- Fecha Envio N4
SELECT COUNT(id) as totales, fh_envio_n4 FROM validacion GROUP BY fh_envio_n4 ORDER BY 2 ASC;

-- Firma
SELECT COUNT(id) as totales, firma FROM validacion GROUP BY firma ORDER BY 2 ASC;

-- Factura
SELECT COUNT(id) as totales, factura FROM validacion GROUP BY factura ORDER BY 2 ASC;

-- Fecha Facturacion
SELECT COUNT(id) as totales, fh_facturacion FROM validacion GROUP BY fh_facturacion ORDER BY 2 ASC;

-- Fecha Conciliacion
SELECT COUNT(id) as totales, fh_conciliacion FROM validacion GROUP BY fh_conciliacion ORDER BY 2 ASC;

-- Importe
SELECT COUNT(id) as totales, importe FROM validacion GROUP BY importe ORDER BY 2 ASC;

-- ID Lote
SELECT COUNT(id) as totales, id_lote FROM validacion GROUP BY id_lote ORDER BY 2 ASC;

-- Estado
SELECT COUNT(id) as totales, estado FROM validacion GROUP BY estado ORDER BY 2 ASC;

-- Perfil
SELECT COUNT(id) as totales, perfil FROM validacion GROUP BY perfil ORDER BY 2 ASC;

-- ID N4
SELECT COUNT(id) as totales, id_n4 FROM validacion GROUP BY id_n4 ORDER BY 2 ASC;

-- ID Movimiento
SELECT COUNT(id) as totales, id_movimiento FROM validacion GROUP BY id_movimiento ORDER BY 2 ASC;

-- ID Tap Ext
SELECT COUNT(id) as totales, id_tap_ext FROM validacion GROUP BY id_tap_ext ORDER BY 2 ASC;

-- Tipo Comprobante
SELECT COUNT(id) as totales, tipo_comprobante FROM validacion GROUP BY tipo_comprobante ORDER BY 2 ASC;

/*************Consolidada*********************/


SELECT 'concentrador' AS campo, CAST(concentrador AS CHAR) AS criterio, COUNT(id) AS total FROM validacion GROUP BY concentrador
UNION ALL
SELECT 'estacion', CAST(estacion AS CHAR), COUNT(id) FROM validacion GROUP BY estacion

UNION ALL
SELECT 'sentido', CAST(sentido AS CHAR), COUNT(id) FROM validacion GROUP BY sentido
UNION ALL
SELECT 'terminal', CAST(terminal AS CHAR), COUNT(id) FROM validacion GROUP BY terminal
UNION ALL
SELECT 'ruta', CAST(ruta AS CHAR), COUNT(id) FROM validacion GROUP BY ruta
UNION ALL
SELECT 'parada', CAST(parada AS CHAR), COUNT(id) FROM validacion GROUP BY parada
UNION ALL
SELECT 'tipo_medio', CAST(tipo_medio AS CHAR), COUNT(id) FROM validacion GROUP BY tipo_medio
UNION ALL
SELECT 'num_medio', CAST(num_medio AS CHAR), COUNT(id) FROM validacion GROUP BY num_medio
UNION ALL
SELECT 'secuencial', CAST(secuencial AS CHAR), COUNT(id) FROM validacion GROUP BY secuencial

UNION ALL
SELECT 'num_envio', CAST(num_envio AS CHAR), COUNT(id) FROM validacion GROUP BY num_envio

UNION ALL
SELECT 'firma', CAST(firma AS CHAR), COUNT(id) FROM validacion GROUP BY firma
UNION ALL
SELECT 'factura', CAST(factura AS CHAR), COUNT(id) FROM validacion GROUP BY factura

UNION ALL
SELECT 'importe', CAST(importe AS CHAR), COUNT(id) FROM validacion GROUP BY importe
UNION ALL
SELECT 'id_lote', CAST(id_lote AS CHAR), COUNT(id) FROM validacion GROUP BY id_lote
UNION ALL
SELECT 'estado', CAST(estado AS CHAR), COUNT(id) FROM validacion GROUP BY estado
UNION ALL
SELECT 'perfil', CAST(perfil AS CHAR), COUNT(id) FROM validacion GROUP BY perfil


/*************CON FECHAS ***************************/


-- 1. Concentrador
SELECT COUNT(id) AS totales, concentrador FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY concentrador ORDER BY 2 ASC;

-- 2. Estación
SELECT COUNT(id) AS totales, estacion FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY estacion ORDER BY 2 ASC;

-- 3. Fecha/Hora (fh) - Agrupado por el timestamp exacto
SELECT COUNT(id) AS totales, fh FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY fh ORDER BY 2 ASC;

-- 4. Sentido
SELECT COUNT(id) AS totales,
CASE sentido
        WHEN 1 THEN 'ENTRADA'
        WHEN 2 THEN 'SALIDA'       
        ELSE 'NO-DEFINIDO' 
    END AS sentido_entrada_salida
FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY sentido ORDER BY 2 ASC;

-- 5. Terminal
SELECT COUNT(id) AS totales, terminal FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY terminal ORDER BY 2 ASC;

-- 6. Ruta
SELECT COUNT(id) AS totales, ruta FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY ruta ORDER BY 2 ASC;

-- 7. Parada
SELECT COUNT(id) AS totales, parada FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY parada ORDER BY 2 ASC;

-- 8. Tipo de Medio
SELECT COUNT(id) AS totales, tipo_medio FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY tipo_medio ORDER BY 2 ASC;

-- 9. Número de Medio
SELECT COUNT(id) AS totales, num_medio FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY num_medio ORDER BY 2 ASC;

-- 10. Secuencial
SELECT COUNT(id) AS totales, secuencial FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY secuencial ORDER BY 2 ASC;

-- 11. ID QR
SELECT COUNT(id) AS totales, id_qr FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY id_qr ORDER BY 2 ASC;

-- 12. Número de Envío
SELECT COUNT(id) AS totales, num_envio FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY num_envio ORDER BY 2 ASC;

-- 13. Fecha/Hora Envío N4
SELECT COUNT(id) AS totales, fh_envio_n4 FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY fh_envio_n4 ORDER BY 2 ASC;

-- 14. Firma
SELECT COUNT(id) AS totales, firma FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY firma ORDER BY 2 ASC;

-- 15. Factura
SELECT COUNT(id) AS totales, factura FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY factura ORDER BY 2 ASC;

-- 16. Fecha/Hora Facturación
SELECT COUNT(id) AS totales, fh_facturacion FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY fh_facturacion ORDER BY 2 ASC;

-- 17. Fecha/Hora Conciliación
SELECT COUNT(id) AS totales, fh_conciliacion FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY fh_conciliacion ORDER BY 2 ASC;

-- 18. Importe
SELECT COUNT(id) AS totales, importe FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY importe ORDER BY 2 ASC;

-- 19. ID Lote
SELECT COUNT(id) AS totales, id_lote FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY id_lote ORDER BY 2 ASC;

-- 20. Estado
SELECT COUNT(id) AS totales, estado FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY estado ORDER BY 2 ASC;

-- 21. Perfil
SELECT COUNT(id) AS totales, perfil FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY perfil ORDER BY 2 ASC;

-- 22. ID N4
SELECT COUNT(id) AS totales, id_n4 FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY id_n4 ORDER BY 2 ASC;

-- 23. ID Movimiento
SELECT COUNT(id) AS totales, id_movimiento FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY id_movimiento ORDER BY 2 ASC;

-- 24. ID Tap Ext
SELECT COUNT(id) AS totales, id_tap_ext FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY id_tap_ext ORDER BY 2 ASC;

-- 25. Tipo Comprobante
SELECT COUNT(id) AS totales, tipo_comprobante FROM validacion 
WHERE fh BETWEEN '2026-03-01 00:00:00' AND '2026-03-31 23:59:59' 
GROUP BY tipo_comprobante ORDER BY 2 ASC;


/************************con fechas****************/
(SELECT 'concentrador' AS categoria, concentrador AS valor, COUNT(id) AS total 
 FROM validacion WHERE fh BETWEEN '2026-03-01' AND '2026-03-31' GROUP BY concentrador)
UNION ALL
(SELECT 'estacion', estacion, COUNT(id) 
 FROM validacion WHERE fh BETWEEN '2026-03-01' AND '2026-03-31' GROUP BY estacion)
UNION ALL
(SELECT 'sentido', CAST(sentido AS CHAR), COUNT(id) 
 FROM validacion WHERE fh BETWEEN '2026-03-01' AND '2026-03-31' GROUP BY sentido)
-- Repetir para el resto de columnas...
ORDER BY categoria ASC, total DESC;

/**************




