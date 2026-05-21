SELECT
    -- Columnas para la etiqueta y la ordenación
    COALESCE(sub.Agrupamiento, 'Total General') AS Nivel_Reporte,
    COALESCE(sub.Ruta, ' - ') AS Ruta,
    COALESCE(sub.Parada, ' - ') AS Parada,
    COALESCE(sub.Sentido, ' - ') AS Sentido,
    COALESCE(sub.Perfil, ' - ') AS Perfil,
    -- Columnas de datos agregados
    sub.Importe_Total,
    sub.Totales
FROM (
    -- Nivel 1: Totales por Ruta
    (SELECT 'Total Ruta' AS Agrupamiento, Ruta, NULL AS Parada, NULL AS Sentido, NULL AS Perfil, SUM(importe) AS Importe_Total, COUNT(id) AS Totales 
     FROM validacion GROUP BY Ruta)
    
    UNION ALL
    
    -- Nivel 2: Totales por Parada dentro de cada Ruta
    (SELECT 'Total Parada', Ruta, Parada, NULL, NULL, SUM(importe), COUNT(id) 
     FROM validacion GROUP BY Ruta, Parada)
    
    UNION ALL
    
    -- Nivel 3: Totales por Sentido dentro de cada Parada
    (SELECT 'Total Sentido', Ruta, Parada, Sentido, NULL, SUM(importe), COUNT(id) 
     FROM validacion GROUP BY Ruta, Parada, Sentido)
    
    UNION ALL
    
    -- Nivel 4: Totales por Perfil (Nivel de detalle más profundo)
    (SELECT 'Detalle Perfil', Ruta, Parada, Sentido, Perfil, SUM(importe), COUNT(id) 
     FROM validacion GROUP BY Ruta, Parada, Sentido, Perfil)

) AS sub

-- El ORDER BY es crucial para que los totales aparezcan en el orden correcto
ORDER BY sub.Ruta, sub.Parada, sub.Sentido, sub.Perfil, sub.Agrupamiento ASC;