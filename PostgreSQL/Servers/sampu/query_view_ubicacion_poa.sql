CREATE VIEW view_ubicacion_poa
AS
select a.ide_prfup,codigo_subactividad,detalle_subactividad,subactividad,codigo_actividad,detalle_actividad,actividad,codigo_producto,cod_prod,detalle_producto,producto,    
				  codigo_actividad_mc,cod_act,detalle_actividad_mc,actividad_mc,codigo_producto_mc,cod_prod_mc,detalle_producto_mc,producto_mc,codigo_obra, detalle_obra_prfup as obra,    
				  coalesce(pry1.codigo_proyecto,pry2.codigo_proyecto) as codigo_proyecto,    
				  coalesce(pry1.cod_pry,pry2.cod_pry) as cod_pry,     
				  coalesce(pry1.detalle_proyecto,pry2.detalle_proyecto) as detalle_proyecto,     
				  coalesce(pry1.proyecto,pry2.proyecto) as proyecto,    
				  coalesce(pry1.codigo_programa,pry2.codigo_programa) as codigo_programa,    
				  coalesce(pry1.detalle_programa,pry2.detalle_programa) as detalle_programa,    
				  coalesce(pry1.programa,pry2.programa) as programa,  
				  coalesce(pry1.cod_prog,pry2.cod_prog) as cod_prog from     
				
				  (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_subactividad,    
				  detalle_prfup as detalle_subactividad, detalle_prnfp as subactividad from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =7) a     
				
				  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_actividad,    
				  detalle_prfup as detalle_actividad, detalle_prnfp as actividad from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =6) b on a.pre_ide_prfup = b.ide_prfup    
				
				  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_producto,    
				  detalle_prfup as detalle_producto, detalle_prnfp as producto, codigo_pry_prd_prfup as cod_prod from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =5) c on b.pre_ide_prfup = c.ide_prfup    
				
				  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_actividad_mc,codigo_pry_prd_prfup as cod_act,    
				  detalle_prfup as detalle_actividad_mc,detalle_prnfp as actividad_mc,detalle_obra_prfup 				 
				   ,case when length(codigo_obra_prfup) > 0 then codigo_obra_prfup else '' end as codigo_obra  
				    from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =4) d on c.pre_ide_prfup = d.ide_prfup     
				
				  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_producto_mc,codigo_pry_prd_prfup as cod_prod_mc,    
				  detalle_prfup as detalle_producto_mc,detalle_prnfp as producto_mc from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =3 ) e on d.pre_ide_prfup = e.ide_prfup     
				
				  left join (select pr.ide_prfup, pr.pre_ide_prfup, codigo_proyecto,    
				     detalle_proyecto,proyecto, cod_pry,cod_prog,codigo_programa, detalle_programa,programa    
				  	  from (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_proyecto,    
				  	    detalle_prfup as detalle_proyecto,detalle_prnfp as proyecto, codigo_pry_prd_prfup as cod_pry     
				  	    from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =2) pr    
				  	  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_programa, codigo_pry_prd_prfup as cod_prog,    
				  	    detalle_prfup as detalle_programa,detalle_prnfp as programa from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =1) g on pr.pre_ide_prfup = g.ide_prfup) pry1 on c.pre_ide_prfup = pry1.ide_prfup     
				
				  left join (select pr.ide_prfup, pr.pre_ide_prfup, codigo_proyecto,    
				     detalle_proyecto,proyecto, cod_pry,cod_prog,codigo_programa, detalle_programa,programa    
				  	  from (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_proyecto,    
				  	    detalle_prfup as detalle_proyecto,detalle_prnfp as proyecto, codigo_pry_prd_prfup as cod_pry     
				  	    from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =2) pr    
				  	  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_programa, codigo_pry_prd_prfup as cod_prog,    
				  	    detalle_prfup as detalle_programa,detalle_prnfp as programa from pre_funcion_programa a, pre_nivel_funcion_programa b     
				  	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =1) g on pr.pre_ide_prfup = g.ide_prfup) pry2 on e.pre_ide_prfup = pry2.ide_prfup 
								
			SELECT * FROM view_ubicacion_poa