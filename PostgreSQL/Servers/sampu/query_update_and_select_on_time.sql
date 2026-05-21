
UPDATE bodt_inventario_resumen SET  pmp_existencia_inres =15181.05  WHERE ide_bocam= 9819;
UPDATE bodt_ingreso_egreso SET ide_geani = 9 WHERE ide_ingeg= 6788;
UPDATE bodt_bodega_inventario SET cantidad_saldo_boinv = 9, cantidad_ingreso_boinv=9  WHERE ide_bocam= 9819 and ide_geani = 9;
 


SELECT * FROM bodt_bodega_inventario WHERE ide_bocam= 9819 and ide_geani = 9;


/***************************************************************/
SELECT * FROM bodt_bodega_inventario WHERE ide_bocam= 9819 and ide_geani= 9;


select * from bodt_bodega_inventario 
where ide_bocam= (SELECT ide_bocam FROM   bodt_catalogo_material WHERE ide_parte = 'CAJ093R') --9819    CAJ093R  WYP002N 8808
and ide_boubi = 8



/*************************************************************************/

 
SELECT *  FROM bodt_inventario_resumen WHERE ide_bocam = 9819;
SELECT * FROM bodt_inventario_resumen WHERE ide_bocam = 8808;

cantidad_inicial saldos iniciales  52

/***************************/
select * from bodt_bodega_inventario cantidad_saldo_boinv es el stock 52
select * from bodt_ingreso_egreso_det a 
inner join bodt_ingreso_egreso b completas where ide_bocam caj and ideboubi bodega
ingreso_egreso bodt_inttr trae tipo_transaccion_inv 2 egreso 1 ingreso 3 tre 4 trai 6 egreso por baja



/*************************************************/

SELECT * FROM bodt_ingreso_egreso WHERE ide_ingeg= 6788;

UPDATE bodt_ingreso_egreso SET ide_geani = 9 WHERE ide_ingeg= 6788;






/**************************************************/
UPDATE bodt_ingreso_egreso
SET ide_geani = subquery.minicourse_id
FROM (
  SELECT topics.minicourse_id
  FROM topics
  WHERE topics.id = lessons.topic_id   -- this refers to the "lesson"
                                       -- of the main query
) AS subquery ;

/*******************************/

