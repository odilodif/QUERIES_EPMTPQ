SELECT   cm.ide_bocam,  cm.ide_parte ,cat_codigo_bocam, descripcion_bocam, costo_medio_unidad_inres 
FROM bodt_catalogo_material cm 
LEFT JOIN (
	SELECT
	*
	FROM (
	SELECT 
	ir.ide_inres as ide_inres1,
	ir.ide_bocam AS ide_bocam1,
	row_number() over (partition by ir.ide_bocam order by ir.ide_bocam) as ordenado,
	ide_geani,	
	costo_medio_unidad_inres,	
	usuario_ingre,	
	fecha_ingre,	
	hora_ingre,	
	usuario_actua,	
	fecha_actua,	
	hora_actua,	
	costo_medio_unidad_inc_iva_inres,	
	pmp_existencia_inres
	FROM bodt_inventario_resumen ir
	) 	WHERE ordenado = 1 ORDER BY 1 
	
	
) invr  ON cm.ide_bocam = invr.ide_bocam1

--WHERE ide_parte = 'CAJ093R'

/*******************************************************************/
SELECT
*
FROM (
SELECT 
ir.ide_inres as ide_inres1,
ir.ide_bocam AS ide_bocam1,
row_number() over (partition by ir.ide_bocam order by ir.ide_bocam) as ordenado,
ide_geani,	
costo_medio_unidad_inres,	
usuario_ingre,	
fecha_ingre,	
hora_ingre,	
usuario_actua,	
fecha_actua,	
hora_actua,	
costo_medio_unidad_inc_iva_inres,	
pmp_existencia_inres
FROM bodt_inventario_resumen ir
)
WHERE ordenado = 1 ORDER BY 1 
/***************************************************************/




/*******************************/

SELECT  ide_inres , ide_bocam  FROM  bodt_inventario_resumen  ORDER BY 1 DESC; -- 6544,6546 | 9819 

SELECT ide_bocam,   COUNT(ide_bocam) FROM  bodt_inventario_resumen
GROUP BY   ide_bocam  
HAVING COUNT(ide_bocam) > 1 ;

/***************************************/


