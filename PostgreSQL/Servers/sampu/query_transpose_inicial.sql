WITH bodegas_h as ( SELECT  --CTE
	(CASE 	WHEN ide_boubi = 1  THEN	detalle_boubi ELSE	NULL END ) as columna_1,
	(CASE 	WHEN ide_boubi = 2  THEN	detalle_boubi ELSE	NULL END) AS columna_2 ,
	CASE 	WHEN ide_boubi = 3  THEN	detalle_boubi ELSE	NULL END as columna_3,
	CASE 	WHEN ide_boubi = 4  THEN	detalle_boubi ELSE	NULL END AS columna_4 ,
	CASE 	WHEN ide_boubi = 5  THEN	detalle_boubi ELSE	NULL END AS columna_5 ,
	CASE 	WHEN ide_boubi = 6  THEN	detalle_boubi ELSE	NULL END  AS columna_6,
	CASE 	WHEN ide_boubi = 7 THEN	detalle_boubi ELSE	NULL END AS columna_7 ,
	CASE 	WHEN ide_boubi = 8 THEN	detalle_boubi ELSE	NULL END  AS columna_8,
	CASE 	WHEN ide_boubi = 9 THEN	detalle_boubi ELSE	NULL END AS columna_9,
	CASE 	WHEN ide_boubi = 10 THEN	detalle_boubi ELSE	NULL END  AS columna_10,
	CASE 	WHEN ide_boubi = 11 THEN	detalle_boubi ELSE	NULL END AS columna_11 ,
	CASE 	WHEN ide_boubi = 12 THEN	detalle_boubi ELSE	NULL END AS columna_12,
	CASE 	WHEN ide_boubi = 13 THEN	detalle_boubi ELSE	NULL END AS columna_13,
	CASE 	WHEN ide_boubi = 14 THEN	detalle_boubi ELSE	NULL END AS columna_14
FROM bodt_bodega_ubicacion 

) 

SELECT *
FROM bodegas_h
WHERE
    columna_1 IS NOT NULL 
		AND columna_2 IS NOT NULL
    

/*************************************/

SELECT * FROM bodt_bodega_ubicacion ORDER BY 1