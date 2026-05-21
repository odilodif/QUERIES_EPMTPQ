WITH RECURSIVE catalogo AS (
    SELECT 
        b.ide_bocam, 
        b.con_ide_bocam, 
        b.cat_codigo_bocam, 
        b.descripcion_bocam, 
        b.activo_bocam 
    FROM public.bodt_catalogo_material b  
    WHERE b.ide_bocam = 2  

    UNION ALL  

    SELECT 
        e.ide_bocam, 
        e.con_ide_bocam, 
        e.cat_codigo_bocam, 
        e.descripcion_bocam, 
        e.activo_bocam 
    FROM public.bodt_catalogo_material e  
    JOIN catalogo c ON e.con_ide_bocam = c.ide_bocam  
),  
conteo_hijos AS (  
    SELECT 
        c.con_ide_bocam, 
        COUNT(*) AS cantidad_hijos  
    FROM catalogo c  
    GROUP BY c.con_ide_bocam  
)  

SELECT 
    c.ide_bocam, 
    c.cat_codigo_bocam || ' ' || c.descripcion_bocam AS descripcion,  
    ch.cantidad_hijos  
FROM catalogo c  
LEFT JOIN conteo_hijos ch ON c.ide_bocam = ch.con_ide_bocam  
WHERE c.activo_bocam = TRUE  
AND ch.cantidad_hijos IS NULL;
