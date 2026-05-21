SELECT cat.ide_parte,cat.cat_codigo_bocam,cat.descripcion_bocam, inv.IDE_BOINV ,cat.ide_bocam,* FROM bodt_bodega_inventario inv
INNER JOIN bodt_catalogo_material cat ON inv.ide_bocam = cat.ide_bocam
WHERE cat.ide_parte IN ('PEG011N'
,'PLA127N'
,'SAC003N'
,'POL013N'
)
AND  ide_geani=9 AND ide_boubi=6    
ORDER BY 2 ASC;
/***********************************************************/
SELECT cat.ide_parte,cat.cat_codigo_bocam,cat.descripcion_bocam, cat.ide_bocam,* FROM bodt_bodega_inventario inv
INNER JOIN bodt_catalogo_material cat ON inv.ide_bocam = cat.ide_bocam
WHERE inv.IDE_BOINV IN (5558
,5849
,5880
,5929
)
ORDER BY 2 ASC;