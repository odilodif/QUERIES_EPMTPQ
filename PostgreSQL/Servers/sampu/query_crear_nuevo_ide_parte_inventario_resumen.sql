
 /***************/
SELECT * FROM bodt_inventario_resumen WHERE ide_bocam = 10253;
/*****************/

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
    10253,
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


