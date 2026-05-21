


UPDATE  solicitud_items SET id_maint_work_order = 1103   WHERE ide_solicitud= 1731 ;

UPDATE bodt_ingreso_egreso SET id_maint_work_order= 1103 WHERE numero_documento_ingeg = 264714;



ALTER TABLE solicitud_items
ADD CONSTRAINT unique_id_maint_work_order UNIQUE (id_maint_work_order);



alter table  bodt_ingreso_egreso
add  constraint unique_egress_id_maint_work_order
unique  (id_maint_work_order);
