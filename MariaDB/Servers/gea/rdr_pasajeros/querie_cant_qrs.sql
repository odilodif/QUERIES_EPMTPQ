SELECT 
    CASE qrs.concentrador
        WHEN '13000400' THEN 'Morán Valverde'
        WHEN '1000' THEN 'LA COLINA'
        WHEN '1001' THEN 'Laboratorio EPMTPQ'        
        ELSE 'NO-DEFINIDO' 
    END AS nombre_estacion,
    trfs.nombre_tarifa,
    qrs.importe,
    COUNT(qrs.id) AS cantidad_qrs
FROM qr qrs
INNER JOIN n4_tarifas trfs 
    ON qrs.tarifa = trfs.codigo_tarifa
GROUP BY nombre_estacion,   trfs.nombre_tarifa,     qrs.importe
UNION ALL
SELECT  ' ' ,' ', 'TOTAL',  COUNT(id) 
FROM qr qrs, n4_tarifas trfs
WHERE  qrs.tarifa = trfs.codigo_tarifa


/******************************************/
SELECT qrs.concentrador, qrs.importe, trfs.nombre_tarifa ,COUNT(id) cantidad_qrs
FROM qr qrs, n4_tarifas trfs
WHERE  qrs.tarifa = trfs.codigo_tarifa
GROUP BY trfs.nombre_tarifa, qrs.importe,qrs.concentrador
UNION ALL
SELECT ' ', ' ' ,' ', 'TOTAL',  COUNT(id) 
FROM qr qrs, n4_tarifas trfs
WHERE  qrs.tarifa = trfs.codigo_tarifa
/************************************/



SELECT
     CASE concentrador
        WHEN '13000400' THEN 'Morán Valverde'
        WHEN '1000' THEN 'LA COLINA'
        WHEN '1001' THEN 'Laboratorio EPMTPQ'        
        ELSE 'NO-DEFINIDO ' 
    END AS  concentrador,
    SUM(importe) AS total_usd
FROM qr
GROUP BY concentrador
ORDER BY total_usd DESC;


SELECT * FROM agencias WHERE identidad_n4 = 2

/*****************************/
SELECT * FROM recarga





