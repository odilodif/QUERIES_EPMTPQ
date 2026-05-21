WITH pruebaingresosegresos 
AS(

 SELECT (ingd.costo_unitario_inegd * 2) as calculado   FROM bodt_ingreso_egreso ing
 INNER JOIN bodt_ingreso_egreso_det ingd  ON ing.ide_ingeg = ingd.ide_ingeg

) SELECT * FROM pruebaingresosegresos;