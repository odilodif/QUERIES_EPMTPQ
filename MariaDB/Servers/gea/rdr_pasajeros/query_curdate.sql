SELECT  
estacion,
COUNT(id) AS total_pasajeros
FROM qr
WHERE DATE(fh) = CURDATE()
GROUP BY estacion
UNION ALL
SELECT  ' TOTALES ', COUNT(id) FROM qr 
WHERE DATE(fh) = CURDATE()

/***************************/
SELECT
    SUM(
        CASE
            WHEN importe IN (0.35, 0.17, 0.10)
            THEN importe
            ELSE 0
        END
    ) AS total_importe
FROM qr
WHERE fh >= CURDATE()
  AND fh < CURDATE() + INTERVAL 1 DAY;
	
	
/*******************************/

SELECT *  FROM  qr 
WHERE importe NOT IN (0.35, 0.17, 0.10)



SELECT SUM(importe) 
FROM qr 
WHERE fh >= CURDATE() 
AND fh < CURDATE() + INTERVAL 1 DAY;
	
	
	
	SELECT COUNT(importe) 
FROM qr 
WHERE fh >= CURDATE() 
AND fh < CURDATE() + INTERVAL 1 DAY;
	
	
	
	
	
	