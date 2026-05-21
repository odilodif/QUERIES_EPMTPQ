ALTER TABLE bodt_ingreso_egreso ADD COLUMN ip_remote VARCHAR(250); 
ALTER TABLE bodt_ingreso_egreso ADD COLUMN url_ing_egr VARCHAR(250); 
ALTER TABLE maint_work_order ADD COLUMN ip_remote VARCHAR(250); 
ALTER TABLE maint_work_order ADD COLUMN url_maked VARCHAR(250); 
ALTER TABLE solicitud_items ADD COLUMN ip_remote VARCHAR(250); 
ALTER TABLE solicitud_items ADD COLUMN url_maked VARCHAR(250);