drop VIEW v_transpose_bodegas

CREATE VIEW v_transpose_bodegas
AS 

 SELECT 
  MAX(columna_2) AS bodega_2,
    MAX(columna_3) AS bodega_3 ,
    MAX(columna_4) AS bodega_4,
    MAX(columna_5) AS bodega_5 ,
    MAX(columna_6) AS bodega_6,
    MAX(columna_7) AS bodega_7,
    MAX(columna_8)AS bodega_8 ,
    MAX(columna_9) AS bodega_9,
    MAX(columna_10) AS bodega_10,
    MAX(columna_11) AS bodega_11,   
    MAX(columna_13) AS bodega_13 

	FROM (
    SELECT
       -- (CASE WHEN ide_boubi = 1 THEN ide_boubi ELSE NULL END) AS columna_1,
        (CASE WHEN ide_boubi = 2 THEN ide_boubi ELSE NULL END) AS columna_2,
        (CASE WHEN ide_boubi = 3 THEN ide_boubi ELSE NULL END) AS columna_3,
        (CASE WHEN ide_boubi = 4 THEN ide_boubi ELSE NULL END) AS columna_4,
        (CASE WHEN ide_boubi = 5 THEN ide_boubi ELSE NULL END) AS columna_5,
        (CASE WHEN ide_boubi = 6 THEN ide_boubi ELSE NULL END) AS columna_6,
        (CASE WHEN ide_boubi = 7 THEN ide_boubi ELSE NULL END) AS columna_7,
        (CASE WHEN ide_boubi = 8 THEN ide_boubi ELSE NULL END) AS columna_8,
        (CASE WHEN ide_boubi = 9 THEN ide_boubi ELSE NULL END) AS columna_9,
        (CASE WHEN ide_boubi = 10 THEN ide_boubi ELSE NULL END) AS columna_10,
        (CASE WHEN ide_boubi = 11 THEN ide_boubi ELSE NULL END) AS columna_11,
       -- (CASE WHEN ide_boubi = 12 THEN ide_boubi ELSE NULL END) AS columna_12,
        (CASE WHEN ide_boubi = 13 THEN ide_boubi ELSE NULL END) AS columna_13
     --   (CASE WHEN ide_boubi = 14 THEN ide_boubi ELSE NULL END) AS columna_14
    FROM bodt_bodega_inventario
)

SELECT bodega_2 FROM v_transpose_bodegas WHERE bodega_2 = 2


SELECT ( SELECT ide_bocam, cantidad_saldo_boinv FROM bodt_bodega_inventario inv WHERE ide_boubi = 2 AND ide_bocam =  3361   )  FROM v_transpose_bodegas bodgs 

/******************************************/

SELECT  MAX(columna_2) AS bodega_2,
    MAX(columna_3) AS bodega_3 ,
    MAX(columna_4) AS bodega_4,
    MAX(columna_5) AS bodega_5 ,
    MAX(columna_6) AS bodega_6,
    MAX(columna_7) AS bodega_7,
    MAX(columna_8)AS bodega_8 ,
    MAX(columna_9) AS bodega_9,
    MAX(columna_10) AS bodega_10,
    MAX(columna_11) AS bodega_11,   
    MAX(columna_13) AS bodega_13 
		FROM v_transpose_bodegas;

/*********************/


SELECT
--MAX(columna_1),
    MAX(columna_2),
    MAX(columna_3),
    MAX(columna_4),
    MAX(columna_5),
    MAX(columna_6),
    MAX(columna_7),
    MAX(columna_8),
    MAX(columna_9),
    MAX(columna_10),
    MAX(columna_11),
   -- MAX(columna_12),
    MAX(columna_13)
   -- MAX(columna_14)
	
FROM bodegas_h





SELECT (SELECT descripcion_bocam FROM bodt_catalogo_material cat1 WHERE cat1.ide_bocam = inv.ide_bocam ) as descripcion_bocam, inv.cantidad_saldo_boinv as bodega_1
FROM bodt_bodega_inventario inv WHERE inv.ide_boubi = 2;


SELECT ide_bocam FROM bodt_bodega_inventario WHERE ide_boubi = 2,


/*************************************/



CREATE TABLE mytable (
Id INT,
Name VARCHAR,
Age INT
)

INSERT INTO mytable(Id, Name, Age) VALUES (1,'odilo', 23)
SELECT * FROM   mytable; 



/********************************/


Id Name Age
1  abc  3
Required Result:

Id 1
Name abc
Age 3

select x.*
from mytable t
cross join lateral ( values
    ( 'Id',   id::text ),
    ( 'Name', name     ),
    ( 'Age',  age::text)
) x(colum, valor)
/**********************************************/

 
SELECT ide_boubi,	detalle_boubi FROM bodt_bodega_ubicacion 






