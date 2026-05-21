SELECT 
    infc.orden::integer,
    infc.matriz::text,
    infc.pregunta::text,
    infc.respuesta::text,
    infc.periodo::text,
    infc.nota::numeric
FROM esq_retroalimentacion.tbl_informe_calificado infc 
WHERE infc.inf_cod = 14586 
ORDER BY 1 ASC

UNION ALL 

SELECT
    NULL::integer AS orden, 
    NULL::text AS matriz,  
    NULL::text AS pregunta, 
    NULL::text AS respuesta,
    'TOTALES'::text AS periodo, 
    SUM(CASE WHEN infc.nota IS NULL THEN 0 ELSE infc.nota END)::numeric AS nota
FROM esq_retroalimentacion.tbl_informe_calificado infc  
WHERE infc.inf_cod = 14586
GROUP BY 1;
