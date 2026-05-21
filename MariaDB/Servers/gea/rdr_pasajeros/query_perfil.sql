SELECT DISTINCT
    LTRIM(RTRIM(v.perfil)) AS CodigoPerfilFuente,
    CASE
        WHEN v.perfil IS NULL OR LTRIM(RTRIM(v.perfil)) = '' THEN 'NO IDENTIFICADO'
        ELSE UPPER(LTRIM(RTRIM(v.perfil)))
    END AS  NombrePerfil,
    CASE
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) = 'ADN' THEN 'REGULAR'
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) = 'DES' THEN 'DESCUENTO'
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) = 'QR' THEN 'QR'
        WHEN v.perfil IS NULL OR LTRIM(RTRIM(v.perfil)) = '' THEN 'NO IDENTIFICADO'
        ELSE 'OTRO'
    END AS CategoriaPerfil,
    CASE
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) = 'ADN' THEN 'Perfil ADN'
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) = 'DES' THEN 'Perfil con descuento'
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) = 'QR' THEN 'Perfil asociado a código QR'
        WHEN v.perfil IS NULL OR LTRIM(RTRIM(v.perfil)) = '' THEN 'Perfil no identificado'
        ELSE CONCAT('Perfil fuente: ', UPPER(LTRIM(RTRIM(v.perfil))))
    END AS DescripcionPerfil,
    CASE
        WHEN UPPER(LTRIM(RTRIM(v.perfil))) IN ('ADN', 'DES', 'QR') THEN 0
        ELSE 1
    END AS RequiereRevision,
    1 AS Activo
FROM validacion v;