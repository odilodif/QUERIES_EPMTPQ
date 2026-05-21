
SELECT  DISTINCT bodt_catalogo_material.ide_bocam,  bodt_catalogo_material.ide_parte ,cat_codigo_bocam, descripcion_bocam, costo_medio_unidad_inres 
FROM bodt_catalogo_material
LEFT JOIN bodt_inventario_resumen ON bodt_catalogo_material.ide_bocam = bodt_inventario_resumen.ide_bocam
WHERE bodt_catalogo_material.ide_bocam = 9819;

SELECT *  FROM bodt_inventario_resumen WHERE ide_bocam = 9819 and ide_geani = 1;

UPDATE bodt_inventario_resumen SET ide_bocam = null  WHERE ide_bocam = 9819 and ide_geani = 1;

SELECT *  FROM bodt_catalogo_material WHERE ide_parte = 'ARB008R';
SELECT *  FROM bodt_catalogo_material WHERE ide_bocam = 8928;


SELECT *  FROM bodt_catalogo_material WHERE ide_parte = 'ARB008R';
SELECT *  FROM bodt_catalogo_material WHERE ide_parte = 'BOL024N';
SELECT ide_bocam  FROM bodt_catalogo_material WHERE ide_parte = 'CAJ093R';


/***************************************************/

SELECT * FROM bodt_inventario_resumen WHERE ide_bocam = 10227;

/*****************************************/
INSERT INTO bodt_inventario_resumen (
    ide_inres,
    ide_bocam,
    ide_geani,
    costo_medio_unidad_inres,
    costo_medio_unidad_inc_iva_inres,
    pmp_existencia_inres,
    usuario_ingre,
    fecha_ingre,
    hora_ingre,
    usuario_actua,
    fecha_actua,
    hora_actua
)
VALUES (
    (SELECT COALESCE(MAX(ide_inres), 0) + 1 FROM bodt_inventario_resumen),
    10227,
    9,
    0,
    0,
    0,
    'devuser',
    CURRENT_DATE,
    NOW()::time,
    'devuser',
    CURRENT_DATE,
    NOW()::time
);


/*****************************************/
SELECT * FROM bodt_inventario_resumen WHERE ide_bocam = 9637;
/*************************************************/
INSERT INTO bodt_inventario_resumen (
    ide_inres,
    ide_bocam,
    ide_geani,
    costo_medio_unidad_inres,
    costo_medio_unidad_inc_iva_inres,
    pmp_existencia_inres,
    usuario_ingre,
    fecha_ingre,
    hora_ingre,
    usuario_actua,
    fecha_actua,
    hora_actua
)
VALUES (
    (SELECT COALESCE(MAX(ide_inres), 0) + 1 FROM bodt_inventario_resumen),
    9637,
    9,
    0,
    0,
    0,
    'devuser',
    CURRENT_DATE,
    NOW()::time,
    'devuser',
    CURRENT_DATE,
    NOW()::time
);

