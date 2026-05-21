Select ( SELECT bodu1.detalle_boubi FROM bodt_bodega_ubicacion bodu1 WHERE bodu1.ide_boubi = a.ide_boubi) as "DESCRIPCIÓN BODEGA" , ' ' AS "No TARJETA", b.ide_parte AS "ID PARTE", b.descripcion_bocam AS "DESCRIPCION", ' ' AS "BODEGA",  c.detalle_bounm AS "UNID. MEDIDA", a.cantidad_saldo_boinv AS		"STOCK"
from bodt_bodega_inventario a 
inner join  bodt_catalogo_material b  ON a.ide_bocam = b.ide_bocam
INNER JOIN  bodt_unidad_medida c  ON b.ide_bounm = c.ide_bounm




