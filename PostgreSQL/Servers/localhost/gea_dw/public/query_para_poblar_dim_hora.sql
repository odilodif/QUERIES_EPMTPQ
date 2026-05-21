INSERT INTO DIM_HORA (ID_HORA, HORA_COMPLETA, SOLO_HORA, MINUTO, SEGUNDO, TURNO)
SELECT 
    -- ID en formato HHMMSS (ej: 130545)
    to_char(serie_hora, 'HH24MISS')::int AS ID_HORA,
    -- El tiempo real tipo TIME
    serie_hora::time AS HORA_COMPLETA,
    -- Componentes separados para filtros rápidos
    extract(hour from serie_hora) AS SOLO_HORA,
    extract(minute from serie_hora) AS MINUTO,
    extract(second from serie_hora) AS SEGUNDO,
    -- Clasificación por turnos (útil para administración de estaciones)
    CASE 
        WHEN extract(hour from serie_hora) BETWEEN 0 AND 5 THEN 'Madrugada'
        WHEN extract(hour from serie_hora) BETWEEN 6 AND 11 THEN 'Mañana'
        WHEN extract(hour from serie_hora) BETWEEN 12 AND 17 THEN 'Tarde'
        WHEN extract(hour from serie_hora) BETWEEN 18 AND 23 THEN 'Noche'
    END AS TURNO
FROM generate_series(
    '2026-01-01 00:00:00'::timestamp, -- Fecha arbitraria para la serie
    '2026-01-01 23:59:59'::timestamp, 
    '1 second'::interval              -- Saltos de 1 segundo
) AS serie_hora;