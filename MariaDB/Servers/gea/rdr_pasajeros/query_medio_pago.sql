SELECT
    tipo_medio_limpio AS CodigoMedioFuente,

    CASE
        WHEN tipo_medio_limpio IS NULL THEN 'NO IDENTIFICADO'
        WHEN UPPER(tipo_medio_limpio) = 'BILQR' THEN 'QRBIL'
        WHEN UPPER(tipo_medio_limpio) = 'TJ_TR' THEN 'TJTR'
        WHEN UPPER(tipo_medio_limpio) = 'TJ_CI' THEN 'TJCI'
        WHEN UPPER(tipo_medio_limpio) = 'CEDID' THEN 'CEDID'
        WHEN UPPER(tipo_medio_limpio) = 'ABTQR' THEN 'QRABT'
        ELSE 'OTRO'
    END AS TipoMedioPersonalizado,

    CASE
        WHEN tipo_medio_limpio IS NULL THEN 'Medio no identificado'
        WHEN UPPER(tipo_medio_limpio) = 'BILQR' THEN 'BILLETE QR FISICO'
        WHEN UPPER(tipo_medio_limpio) = 'TJ_TR' THEN 'TARJETA TRANSPORTE'
        WHEN UPPER(tipo_medio_limpio) = 'TJ_CI' THEN 'TARJETA CIUDAD'
        WHEN UPPER(tipo_medio_limpio) IN ('CEDULA', 'CI', 'CED', 'CEDID') THEN 'CEDULA IDENTIDAD'
        WHEN UPPER(tipo_medio_limpio) = 'ABTQR' THEN 'CUENTA ABT QR DIGITAL'
        ELSE 'Otro medio'
    END AS DescripcionMedio,

    CASE
        WHEN UPPER(tipo_medio_limpio) IN ('BILQR', 'ABTQR') THEN 1
        ELSE 0
    END AS EsQr,

    CASE
        WHEN UPPER(tipo_medio_limpio) IN ('TJ_TR', 'TJ_CI') THEN 1
        ELSE 0
    END AS EsTarjeta,

    CASE
        WHEN UPPER(tipo_medio_limpio) IN ('CEDULA', 'CI', 'CED', 'CEDID') THEN 1
        ELSE 0
    END AS EsCedula,    

    MAX(fh) AS fh_maxima

FROM (_
    SELECT
        NULLIF(TRIM(tipo_medio), '') AS tipo_medio_limpio,
        fh
    FROM validacion
    
) v
GROUP BY tipo_medio_limpio;