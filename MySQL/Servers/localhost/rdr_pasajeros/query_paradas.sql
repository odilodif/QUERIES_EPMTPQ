
SELECT estacion as parada FROM
(
SELECT DISTINCT
CASE
WHEN vld.estacion LIKE '%CARCELEN%' THEN 'TERMINAL'
WHEN vld.estacion LIKE '%QUITUMBE%' THEN 'TERMINAL'
WHEN vld.estacion LIKE '%RECREO%' THEN 'ESTACION'
WHEN vld.estacion LIKE '%Morán Valverde%' THEN 'ESTACION'
WHEN vld.estacion LIKE '%LABRADOR%' THEN 'ESTACION'
ELSE 'PARADA'
END AS categoria_lugar,
vld.estacion
FROM validacion vld  
) paradas WHERE categoria_lugar = 'PARADA'