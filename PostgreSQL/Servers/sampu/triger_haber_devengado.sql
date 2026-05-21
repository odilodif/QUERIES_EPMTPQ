insert into pre_mensual (ide_prmen,ide_pranu,ide_comov,ide_codem,fecha_ejecucion_prmen,comprobante_prmen,devengado_prmen,cobrado_prmen,cobradoc_prmen,pagado_prmen,comprometido_prmen,
valor_anticipo_prmen,activo_prmen,ide_prfuf)
select row_number() over (order by c.ide_cocac) + (select max(ide_prmen) as codigo from pre_mensual) as codigo,
f.ide_pranu,
a.ide_comov,
c.ide_codem,
mov_fecha_comov,
nro_comprobante_comov,
/*c.debe_codem,*/
haber_codem,
0,
0,
0,
0,
0,
true,
b.ide_prfuf
from cont_movimiento a
left join (
select a.ide_conac,a.ide_coest,b.ide_prfuf
from cont_nombre_asiento_contable a, bodt_grupo_material b
where a.ide_bogrm = b.ide_bogrm
and a.ide_coest in (2,30,16) -- =2
) b on a.ide_conac = b.ide_conac
left join cont_detalle_movimiento c on a.ide_comov = c.ide_comov
left join pre_asociacion_presupuestaria d on c.ide_cocac = d.ide_cocac
left join cont_catalogo_cuenta e on c.ide_cocac = e.ide_cocac
left join pre_anual f on d.devengado = f.ide_prcla and b.ide_prfuf = f.ide_prfuf and f.ide_geani=a.ide_geani
where not a.ide_conac is null
and d.ide_prmop = 5
and not f.ide_pranu is  null
and c.ide_codem = 95777


SELECT * FROM cont_detalle_movimiento  WHERE ide_codem = 95777;
