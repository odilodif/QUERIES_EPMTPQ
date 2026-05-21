/********************add column ide_tepro and FOREIGN KEY ************************/
ALTER TABLE bodt_ingreso_egreso  
ADD ide_tepro bigint null,
ADD CONSTRAINT fk_tes_proveedor_bodt_ingreso_egreso 
FOREIGN KEY (ide_tepro) 
REFERENCES tes_proveedor (ide_tepro) 
ON DELETE NO ACTION  
ON UPDATE NO ACTION

/********************add column ide_gtemp adn FOREIGN KEY ************************/

ALTER TABLE bodt_ingreso_egreso  
ADD COLUMN ide_gtemp_adminc bigint null,
ADD CONSTRAINT fk_gth_empleado_admin_contract_bodt_ingreso_egreso 
FOREIGN KEY (ide_gtemp_adminc) 
REFERENCES gth_empleado (ide_gtemp) 
ON DELETE NO ACTION  
ON UPDATE NO ACTION

/*******************************************************/

ALTER TABLE bodt_ingreso_egreso 
ADD COLUMN ide_gtemp_suppliedby BIGINT NULL,
ADD CONSTRAINT fk_gth_empleado_suppliedby_delegated_bodt_ingreso_egreso
FOREIGN KEY (ide_gtemp_suppliedby)
REFERENCES gth_empleado (ide_gtemp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
/*******************************************************/

ALTER TABLE bodt_catalogo_material 
ADD COLUMN id_bodt_type_material  BIGINT NULL,
ADD CONSTRAINT fk_bodt_catalogo_material_bodt_type_material
FOREIGN KEY (id_bodt_type_material)
REFERENCES bodt_type_material (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION

/*******************************************************/

ALTER TABLE solicitud_items
ADD COLUMN id_gtemp_persona_retira  BIGINT NULL,
ADD CONSTRAINT fk_solicitud_items_gth_empleado
FOREIGN KEY (id_gtemp_persona_retira)
REFERENCES gth_empleado (ide_gtemp)
ON DELETE NO ACTION
ON UPDATE NO ACTION

/************************************************/
ALTER TABLE bodt_ingreso_egreso
ADD COLUMN ip_remote  VARCHAR(250);

ALTER TABLE bodt_ingreso_egreso
ADD COLUMN url_ing_egr  VARCHAR(250);



ALTER TABLE maint_work_order
ADD COLUMN ip_remote  VARCHAR(250);

ALTER TABLE maint_work_order
ADD COLUMN url_maked VARCHAR(250);

ALTER TABLE solicitud_items
ADD COLUMN ip_remote  VARCHAR(250);

ALTER TABLE solicitud_items
ADD COLUMN url_maked VARCHAR(250);





