SELECT cat.ide_parte,cat.cat_codigo_bocam,cat.descripcion_bocam, inv.IDE_BOINV ,cat.ide_bocam,* FROM bodt_bodega_inventario inv
INNER JOIN bodt_catalogo_material cat ON inv.ide_bocam = cat.ide_bocam
WHERE cat.ide_parte IN ('PEG011N'
,'PLA127N'
,'SAC003N'
,'POL013N'
)
AND  ide_geani=9 AND ide_boubi=6    
ORDER BY 2 ASC;
/*********************/
SELECT cat.ide_parte,cat.cat_codigo_bocam,cat.descripcion_bocam, cat.ide_bocam,* 
FROM bodt_bodega_inventario inv
INNER JOIN bodt_catalogo_material cat ON inv.ide_bocam = cat.ide_bocam
WHERE inv.IDE_BOINV IN (6351
)
ORDER BY 2 ASC;
SELECT * from bodt_bodega_inventario WHERE IDE_BOINV IN (6351
)
select ide_bocam, * from bodt_bodega_inventario where IDE_BOINV=6351
select * from bodt_catalogo_material where ide_bocam=9586
select * from gen_anio