SELECT * FROM bodt_catalogo_material WHERE descripcion_bocam ILIKE  '%CHA001N-CHALECO REFLECTIVO PARA PERSONAL%';

SELECT  ingdet.ide_bocam,ingdet.ide_inegd,* FROM bodt_ingreso_egreso ingcab 
INNER JOIN bodt_ingreso_egreso_det ingdet ON ingcab.ide_ingeg=ingdet.ide_ingeg
WHERE ingcab.ide_ingeg= 440

WHERE ingcab.fecha_ingre='2025-04-10'
and ingdet.ide_bocam=2082