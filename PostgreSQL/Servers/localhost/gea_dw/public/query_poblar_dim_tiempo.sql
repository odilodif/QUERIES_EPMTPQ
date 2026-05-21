INSERT INTO dim_tiempo (

fecha,
anio,
trimestre,
mes,
nombre_mes,
dia,
dia_semana,
nombre_dia,
anio_fiscal,
trimestre_fiscal
 
)
SELECT 
                
    fecha_serie::date,                                  
    extract(year from fecha_serie),                     
    extract(quarter from fecha_serie),                  
    extract(month from fecha_serie),
    -- Traducción manual del mes
    CASE extract(month from fecha_serie)
        WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
    END,
    extract(day from fecha_serie),                      
    extract(isodow from fecha_serie),
    -- Traducción manual del día (1=Lunes según ISODOW)
    CASE extract(isodow from fecha_serie)
        WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END,
    CASE 
        WHEN extract(month from fecha_serie) < 7 THEN extract(year from fecha_serie)
        ELSE extract(year from fecha_serie) + 1 
    END,
    CASE 
        WHEN extract(month from fecha_serie) IN (1, 2, 3) THEN 3
        WHEN extract(month from fecha_serie) IN (4, 5, 6) THEN 4
        WHEN extract(month from fecha_serie) IN (7, 8, 9) THEN 1
        WHEN extract(month from fecha_serie) IN (10, 11, 12) THEN 2
    END
FROM generate_series(
    '2026-01-01'::timestamp,      
    CURRENT_DATE::timestamp,      
    '1 day'::interval             
) AS fecha_serie;