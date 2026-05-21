SELECT *  FROM solicitud_items WHERE ide_solicitud   =  12674;
UPDATE solicitud_items SET id_maint_cost_center = 326  WHERE ide_solicitud   =  12674;

SELECT * FROM bodt_ingreso_egreso WHERE ide_ingeg = 12688;
UPDATE bodt_ingreso_egreso SET id_maint_cost_center = 326  WHERE ide_ingeg = 12688;
