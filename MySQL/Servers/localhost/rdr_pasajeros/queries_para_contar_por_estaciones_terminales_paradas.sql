/*****/

SELECT  all_estation.categoria_lugar, COUNT(all_estation.categoria_lugar) FROM  (
SELECT  DISTINCT 
    CASE 
        WHEN vld.estacion LIKE '%CARCELEN%' THEN 'TERMINAL'
        WHEN vld.estacion LIKE '%QUITUMBE%' THEN 'TERMINAL'
        WHEN vld.estacion LIKE '%RECREO%'   THEN 'ESTACION'
        WHEN vld.estacion LIKE '%Morán Valverde%' THEN 'ESTACION'
        WHEN vld.estacion LIKE '%LABRADOR%' THEN 'ESTACION'
        ELSE 'PARADA'
    END AS categoria_lugar,
		vld.estacion
		
FROM validacion vld
INNER JOIN busmatick.estaciones estc1 
    ON vld.terminal = estc1.validadora_id
INNER JOIN busmatick.estaciones_config etconf1 
    ON estc1.estacion = etconf1.id
INNER JOIN busmatick.estaciones_tipos_pasillo tp1 
    ON estc1.Tipo_pasillo_id = tp1.id	
		
) as all_estation

GROUP BY  all_estation.categoria_lugar


/********************1 **************/

SELECT 
    CASE vld.tipo_medio
        WHEN 'TJ_TR' THEN 'TARJETA TRANSPORTE'
        WHEN 'TJ_CI' THEN 'TARJETA CIUDAD'
        WHEN 'SM_QR' THEN 'QR FISICO' -- Ajustado según la imagen adjunta
        WHEN 'ABTQR' THEN 'QR DIGITAL' -- Ajustado según la imagen adjunta
        WHEN 'CEDID' THEN 'CEDULA DE IDENTIDAD'
        ELSE vld.tipo_medio 
    END AS MEDIO_DE_ACESO,
    
    -- Columna ESTACIONES Y TERMINALES
    COUNT(CASE 
        WHEN vld.estacion LIKE '%CARCELEN%' 
          OR vld.estacion LIKE '%QUITUMBE%' 
          OR vld.estacion LIKE '%RECREO%' 
          OR vld.estacion LIKE '%Morán Valverde%' 
          OR vld.estacion LIKE '%LABRADOR%' 
        THEN 1 
    END) AS ESTACIONES_Y_TERMINALES,
    
    -- Columna PARADAS
    COUNT(CASE 
        WHEN vld.estacion NOT LIKE '%CARCELEN%' 
         AND vld.estacion NOT LIKE '%QUITUMBE%' 
         AND vld.estacion NOT LIKE '%RECREO%' 
         AND vld.estacion NOT LIKE '%Morán Valverde%' 
         AND vld.estacion NOT LIKE '%LABRADOR%' 
        THEN 1 
    END) AS PARADAS,
    
    -- Columna TOTAL (Suma de ambas)
    COUNT(*) AS TOTAL

FROM validacion vld
INNER JOIN busmatick.estaciones estc1 
    ON vld.terminal = estc1.validadora_id
INNER JOIN busmatick.estaciones_config etconf1 
    ON estc1.estacion = etconf1.id
INNER JOIN busmatick.estaciones_tipos_pasillo tp1 
    ON estc1.Tipo_pasillo_id = tp1.id
WHERE vld.sentido = 1
GROUP BY MEDIO_DE_ACESO
ORDER BY TOTAL DESC;


/***************2*******************/
SELECT 
    -- Clasificación separada por tipo de infraestructura
    CASE 
        WHEN vld.estacion LIKE '%CARCELEN%' THEN 'Terminales'
        WHEN vld.estacion LIKE '%QUITUMBE%' THEN 'Terminales'
        WHEN vld.estacion LIKE '%RECREO%'   THEN 'Estaciones'
        WHEN vld.estacion LIKE '%Morán Valverde%' THEN 'Estaciones'
        WHEN vld.estacion LIKE '%LABRADOR%' THEN 'Estaciones'
        ELSE 'Paradas'
    END AS UBICACION,

    -- Columnas de Medios de Acceso (Pivote)
    COUNT(CASE WHEN vld.tipo_medio = 'BOL'   THEN 1 END) AS 'BOLETO FÍSICO',
    COUNT(CASE WHEN vld.tipo_medio = 'SM_QR' THEN 1 END) AS 'QR FÍSICO',
    COUNT(CASE WHEN vld.tipo_medio = 'ABTQR' THEN 1 END) AS 'QR DIGITAL',
    COUNT(CASE WHEN vld.tipo_medio = 'TJ_CI' THEN 1 END) AS 'TARJETA CIUDAD',
    COUNT(CASE WHEN vld.tipo_medio = 'TJ_TR' THEN 1 END) AS 'TARJETA TRANSPORTE',

    -- Total por fila
    COUNT(*) AS TOTAL

FROM validacion vld
INNER JOIN busmatick.estaciones estc1 
    ON vld.terminal = estc1.validadora_id
INNER JOIN busmatick.estaciones_config etconf1 
    ON estc1.estacion = etconf1.id
INNER JOIN busmatick.estaciones_tipos_pasillo tp1 
    ON estc1.Tipo_pasillo_id = tp1.id
WHERE vld.sentido = 1
GROUP BY UBICACION
ORDER BY 
    CASE UBICACION 
        WHEN 'Terminales' THEN 1 
        WHEN 'Estaciones' THEN 2 
        ELSE 3 
    END ASC;



/************************************/


		
			
	

SELECT	   CASE 
        WHEN vld.estacion LIKE '%CARCELEN%' THEN 'TERMINAL'
        WHEN vld.estacion LIKE '%QUITUMBE%' THEN 'TERMINAL'
        WHEN vld.estacion LIKE '%RECREO%'   THEN 'ESTACION'
        WHEN vld.estacion LIKE '%Morán Valverde%' THEN 'ESTACION'
        WHEN vld.estacion LIKE '%LABRADOR%' THEN 'ESTACION'
        ELSE 'PARADA'
    END AS categoria_lugar,
	  CASE vld.tipo_medio
        WHEN 'TJ_TR' THEN 'TARJETA TRANSPORTE'
        WHEN 'TJ_CI' THEN 'TARJETA CIUDAD'
        WHEN 'SM_QR' THEN 'QR SECRETARIA DE M'
        WHEN 'CEDID' THEN 'CEDULA DE IDENTIDAD'
        WHEN 'ABTQR' THEN 'QR DIGITAL -CUENTA'
        ELSE vld.tipo_medio 
    END AS tipo_medio_pago,
		vld.estacion,
		 COUNT(vld.estacion) AS totales	
FROM validacion vld
INNER JOIN busmatick.estaciones estc1 
    ON vld.terminal = estc1.validadora_id
INNER JOIN busmatick.estaciones_config etconf1 
    ON estc1.estacion = etconf1.id
INNER JOIN busmatick.estaciones_tipos_pasillo tp1 
    ON estc1.Tipo_pasillo_id = tp1.id			
WHERE vld.sentido=1				
GROUP BY categoria_lugar, tipo_medio_pago,vld.estacion


/****/

SELECT  all_estation.categoria_lugar, COUNT(all_estation.categoria_lugar) FROM  (
SELECT  DISTINCT 
    CASE 
        WHEN vld.estacion LIKE '%CARCELEN%' THEN 'TERMINAL'
        WHEN vld.estacion LIKE '%QUITUMBE%' THEN 'TERMINAL'
        WHEN vld.estacion LIKE '%RECREO%'   THEN 'ESTACION'
        WHEN vld.estacion LIKE '%Morán Valverde%' THEN 'ESTACION'
        WHEN vld.estacion LIKE '%LABRADOR%' THEN 'ESTACION'
        ELSE 'PARADA'
    END AS categoria_lugar,
		vld.estacion
		
FROM validacion vld
INNER JOIN busmatick.estaciones estc1 
    ON vld.terminal = estc1.validadora_id
INNER JOIN busmatick.estaciones_config etconf1 
    ON estc1.estacion = etconf1.id
INNER JOIN busmatick.estaciones_tipos_pasillo tp1 
    ON estc1.Tipo_pasillo_id = tp1.id	
		
) as all_estation

GROUP BY  all_estation.categoria_lugar


-- SELECT DISTINCT estacion FROM validacion;