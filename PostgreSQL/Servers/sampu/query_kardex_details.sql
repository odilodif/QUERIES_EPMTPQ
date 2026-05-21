---drop view view_kardex_details;

/*CREATE VIEW view_kardex_details
AS
SELECT inv.ide_boinv::TEXT as cod_ini_ing_egre ,	inv.fecha_ingre::TEXT, (SELECT cat1.descripcion_bocam FROM bodt_catalogo_material cat1 WHERE cat1.ide_bocam = inv.ide_bocam ) as	descripcion_bocam, (SELECT bubi1.detalle_boubi bubi1  FROM bodt_bodega_ubicacion bubi1 WHERE bubi1.ide_boubi =  inv.ide_boubi) as	bodega, 'INICIAL'	as tipo, inv.cantidad_inicial_boinv as	ing_cantidad, 0 AS	egr_cantidad,	ide_bocam,	ide_geani,	ide_boubi  FROM bodt_bodega_inventario inv 
UNION ALL
SELECT cabing.ide_ingeg::TEXT as cod_ini_ing_egre, 
cabing.fecha_ingeg::TEXT,
(SELECT cat1.descripcion_bocam FROM bodt_catalogo_material cat1 WHERE cat1.ide_bocam = deting.ide_bocam ),
(SELECT bubi1.detalle_boubi bubi1  FROM bodt_bodega_ubicacion bubi1 WHERE bubi1.ide_boubi =  cabing.ide_boubi) as bodega,
(SELECT typ1.detalle_inttr FROM bodt_inventario_tipo_transaccion typ1 WHERE typ1.ide_inttr =  deting.ide_inttr) as tipo,
CASE WHEN deting.ide_inttr IN (1,3) THEN  deting.cantidad_inegd   ELSE  0   END as ing_cantidad ,
CASE WHEN deting.ide_inttr IN (2,4) THEN deting.cantidad_inegd             ELSE 0  END as egr_cantidad,
deting.ide_bocam, 
cabing.ide_geani,
cabing.ide_boubi 
FROM bodt_ingreso_egreso cabing
RIGHT JOIN bodt_ingreso_egreso_det deting  ON cabing.ide_ingeg = deting.ide_ingeg  */  

CREATE VIEW view_kardex_details
AS
SELECT inv.ide_boinv::TEXT as cod_ini_ing_egre ,	inv.fecha_ingre::TEXT, (SELECT cat1.descripcion_bocam FROM bodt_catalogo_material cat1 WHERE cat1.ide_bocam = inv.ide_bocam ) as	descripcion_bocam, (SELECT bubi1.detalle_boubi bubi1  FROM bodt_bodega_ubicacion bubi1 WHERE bubi1.ide_boubi =  inv.ide_boubi) as	bodega, 'INICIAL'	as tipo, inv.cantidad_inicial_boinv as	ing_cantidad, 0 AS	egr_cantidad,	ide_bocam,	ide_geani,	ide_boubi  FROM bodt_bodega_inventario inv 
UNION ALL
SELECT * FROM (SELECT cabing.ide_ingeg::TEXT as cod_ini_ing_egre, 
cabing.fecha_ingeg::TEXT,
(SELECT cat1.descripcion_bocam FROM bodt_catalogo_material cat1 WHERE cat1.ide_bocam = deting.ide_bocam ),
(SELECT bubi1.detalle_boubi bubi1  FROM bodt_bodega_ubicacion bubi1 WHERE bubi1.ide_boubi =  cabing.ide_boubi) as bodega,
(SELECT typ1.detalle_inttr FROM bodt_inventario_tipo_transaccion typ1 WHERE typ1.ide_inttr =  deting.ide_inttr) as tipo,
CASE WHEN deting.ide_inttr IN (1,3) THEN  deting.cantidad_inegd   ELSE  0   END as ing_cantidad ,
CASE WHEN deting.ide_inttr IN (2,4) THEN deting.cantidad_inegd             ELSE 0  END as egr_cantidad,
deting.ide_bocam, 
cabing.ide_geani,
cabing.ide_boubi 
FROM bodt_ingreso_egreso cabing
RIGHT JOIN bodt_ingreso_egreso_det deting  ON cabing.ide_ingeg = deting.ide_ingeg  
ORDER BY cabing.fecha_ingeg ASC

)


/*************************************************************/
SELECT cod_ini_ing_egre, fecha_ingre	,fecha_ingre, tipo	,descripcion_bocam ,	bodega ,	ing_cantidad::TEXT ,	egr_cantidad 
FROM view_kardex_details
WHERE ide_bocam=3810 AND ide_geani=9 AND ide_boubi =  7
UNION ALL
SELECT '',	'','', ' '	,'', 	''	,		'TOTAL',sum(ing_cantidad) - sum(egr_cantidad )
FROM view_kardex_details WHERE ide_bocam=3810    AND ide_geani=9  AND ide_boubi = 7


 /**********************************************************/
 
 SELECT cod_ini_ing_egre, fecha_ingre	,fecha_ingre, tipo	,descripcion_bocam ,	bodega ,	ing_cantidad ,	egr_cantidad   FROM view_kardex_details  WHERE ide_bocam=9771 AND ide_geani= 9 AND ide_boubi =  4
 
  SELECT '',	'','', ' '	,'', 			' ',sum(ing_cantidad) - sum(egr_cantidad ) as "TOTALES" FROM view_kardex_details WHERE ide_bocam=8808    AND ide_geani=9  AND ide_boubi=4



SELECT
 ide_geani, 
 ide_bocam,
ide_boubi,	
 SUM(cantidad_inicial_boinv) AS cantidad 
FROM bodt_bodega_inventario
WHERE
    ide_geani = 9
    AND ide_bocam = 8808 AND ide_boubi = 6
GROUP BY 1, 2,3


/*************************/
/*

SELECT *
FROM (
    SELECT cod_ini_ing_egre,
           fecha_ingre,
           tipo,
           descripcion_bocam,
           bodega,
           ing_cantidad,
           egr_cantidad
    FROM view_kardex_details
    WHERE ide_bocam = 3810
      AND ide_geani = 9
      AND ide_boubi = 7  

    UNION ALL

    SELECT ''::TEXT,
           ''::TEXT,
           ' '::TEXT,
           ''::TEXT,
           'subtotales'::TEXT,
           SUM(ing_cantidad),
           SUM(egr_cantidad)
    FROM view_kardex_details
    WHERE ide_bocam = 3810
      AND ide_geani = 9
      AND ide_boubi = 7
) AS t
ORDER BY 
   CASE WHEN cod_ini_ing_egre ~ '^[0-9]+$' THEN cod_ini_ing_egre::INT ELSE NULL END ASC,
   CASE WHEN cod_ini_ing_egre = '' THEN 1 ELSE 0 END;*/












SELECT cod_ini_ing_egre, fecha_ingre	,fecha_ingre, tipo	,descripcion_bocam ,	bodega ,	ing_cantidad ,	egr_cantidad   FROM view_kardex_details  WHERE ide_bocam=9771 AND ide_geani= 9 AND ide_boubi =  8