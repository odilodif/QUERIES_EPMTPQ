
SELECT DISTINCT  estacion FROM(
		SELECT estacion, 
CASE 
        WHEN qr.estacion LIKE '%CARCELEN%' THEN 'TERMINAL'
        WHEN qr.estacion LIKE '%QUITUMBE%' THEN 'TERMINAL'        
        
    END AS categoria_lugar
FROM 	qr qr HAVING categoria_lugar IS NOT NULL
) terminales



