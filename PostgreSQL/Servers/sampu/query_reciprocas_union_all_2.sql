select periodo,rucEntidad,cta_mayor_pagar_cobrar,sum(flujo_deudor) as flujo_deudor, sum(flujo_acreedor) as flujo_acreedor,ruc,nombre_tepro,codigo_clasificador_prcla,cta_mayor_gasto_i, sum(flujo_deudor2) as flujo_deudor2,  sum(flujo_acreedor2) as flujo_acreedor2, max(nro_transaccion) as nro_transaccion, max(nro_referenci) as nro_referenci,fecha_apro,fecha_venc  from (  

select extract(month from mov.mov_fecha_comov) as periodo, (select identificacion_empr from sis_empresa) as rucEntidad, coalesce((select split_part(dmovi.cue_codigo_cocac,'.',1)||'.'||split_part(dmovi.cue_codigo_cocac ,'.',2)||'.00'),'213.53.00') as cta_mayor_pagar_cobrar, dmovi.haber_codem as flujo_deudor, dmovi.debe_codem as flujo_acreedor,  coalesce((case when cp.ide_geedp is null then prov.ruc_tepro else emp.ruc_emp end),'9999999999999') as ruc,  coalesce((case when cp.ide_geedp is null then prov.nombre_tepro else emp.NOMBRES end),'VARIOS CLIENTES') as nombre_tepro ,dmovii.codigo_clasificador_prcla ,coalesce(dmovi1.cue_codigo_cocac,coalesce(dmovii.cue_codigo_cocac,'111.06.00')) as cta_mayor_gasto_i ,coalesce(dmovii.devengado_prmen,0) as flujo_deudor2 ,coalesce(dmovi.haber_codem,0) as flujo_acreedor2 ,coalesce(cast(comprobante_egreso_tecpo as bigint),mov.ide_comov) as nro_transaccion,coalesce(cast(comprobante_egreso_tecpo as bigint),mov.ide_comov) as nro_referenci ,cast('2025-01-01' as character(25)) as fecha_apro, cast('2025-01-31' as character(25)) as fecha_venc  
from cont_movimiento mov 
left join tes_comprobante_pago cp on cp.ide_tecpo=mov.ide_tecpo 
left join (

select b.ide_tepro, coalesce(ruc_representante_tepro,ruc_tepro) as ruc_tepro,substring(nombre_tepro from 1 for 30) as nombre_tepro from tes_proveedor b 

) prov on prov.ide_tepro=cp.ide_tepro  
left join (

select par.ide_geedp,substring (APELLIDO_PATERNO_GTEMP || ' ' || (case when APELLIDO_MATERNO_GTEMP is null then '' else APELLIDO_MATERNO_GTEMP end) || ' ' || PRIMER_NOMBRE_GTEMP || ' '  	|| (case when SEGUNDO_NOMBRE_GTEMP is null then '' else SEGUNDO_NOMBRE_GTEMP  end)  from 1 for 30) AS NOMBRES,DOCUMENTO_IDENTIDAD_GTEMP as ruc_emp 	
from GEN_EMPLEADOS_DEPARTAMENTO_PAR par  	
left join GTH_EMPLEADO emp on par.ide_gtemp=emp.ide_gtemp

 ) emp on emp.ide_geedp=cp.ide_geedp   
join (

select dmov.ide_comov,ide_gelua, cue_codigo_cocac, dmov.debe_codem, dmov.haber_codem 	from cont_detalle_movimiento dmov  	join cont_catalogo_cuenta cat on cat.ide_cocac=dmov.ide_cocac and (cue_codigo_cocac like '213.53%') 	where sigef_cocac=true and nivel_cocac>4 

	) dmovi on dmovi.ide_comov=mov.ide_comov  
	
left join (

select dmov.ide_comov,ide_gelua, (case when length(cue_codigo_cocac)>10 then substring(cue_codigo_cocac from 0 for 10) else cue_codigo_cocac end) as cue_codigo_cocac,           dmov.debe_codem, dmov.haber_codem, codigo_clasificador_prcla, coalesce(devengado_prmen,0) as devengado_prmen 	from cont_detalle_movimiento dmov  	join cont_catalogo_cuenta cat on cat.ide_cocac=dmov.ide_cocac and (cue_codigo_cocac like '131%' or cue_codigo_cocac like '134%' or cue_codigo_cocac like '141%' or cue_codigo_cocac like '142%'                                                                     or cue_codigo_cocac like '152%' or cue_codigo_cocac like '223%' or cue_codigo_cocac like '634%' or cue_codigo_cocac like '635%' or cue_codigo_cocac like '636%') 	left join ( select ide_codem, codigo_clasificador_prcla,sum(devengado_prmen) as devengado_prmen from pre_mensual pmes 		    left join pre_anual panio on panio.ide_pranu=pmes.ide_pranu 		    left join pre_poa poa on poa.ide_prpoa=panio.ide_prpoa 		    left join pre_clasificador pcl on pcl.ide_prcla=poa.ide_prcla  		    where coalesce(ide_codem,0)>0 		    group by ide_codem, codigo_clasificador_prcla 		    ) pmesi on pmesi.ide_codem=dmov.ide_codem  	where codigo_clasificador_prcla is not null  	

) dmovii on dmovii.ide_comov=mov.ide_comov and dmovii.ide_gelua=dmovi.ide_gelua and dmovii.debe_codem=dmovi.debe_codem  
left join (

select distinct dmov.ide_comov,ide_gelua, cast('111.06.00' as character(25)) as cue_codigo_cocac 	
from cont_detalle_movimiento dmov  	
join cont_catalogo_cuenta cat on cat.ide_cocac=dmov.ide_cocac and (cue_codigo_cocac like '111.06%') 	
where coalesce(haber_codem,0)>0  	

) dmovi1 on dmovi1.ide_comov=mov.ide_comov and dmovi1.ide_gelua=dmovi.ide_gelua  where mov.mov_fecha_comov between '2025-01-01' and  '2025-01-31'

 ) a  group by periodo,rucEntidad,cta_mayor_pagar_cobrar,ruc,nombre_tepro,codigo_clasificador_prcla,cta_mayor_gasto_i,fecha_apro,fecha_venc 