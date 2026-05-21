SELECT 
 (SELECT  cat.ide_parte FROM bodt_catalogo_material cat WHERE cat.ide_bocam = inv.ide_bocam ) codigo,
 (SELECT  cat.descripcion_bocam FROM bodt_catalogo_material cat WHERE cat.ide_bocam = inv.ide_bocam ) descripcion,
	inv.cantidad_inicial_boinv,	
	inv.cantidad_ingreso_boinv,
	inv.cantidad_ingreso_t_boinv,
	inv.cantidad_egreso_boinv,		
	inv.cantidad_egreso_t_boinv,		
	inv.cantidad_egreso_baja_boinv,	
 inv.cantidad_saldo_boinv 
FROM bodt_bodega_inventario inv WHERE inv.ide_bocam IN  (
3728
,3729
,3810
,3811
,3816
,3824
,8019
,9771

) AND ide_boubi = 4


