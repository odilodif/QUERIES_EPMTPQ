create table bodt_tra_inv
(
    id_tra_inv serial not null
        constraint pk_bodt_trans_inv
            primary key,
    ide_inegd integer null
        constraint fk_bodt_trans_inv_bodt_ingreso_egreso_det_2
            references bodt_ingreso_egreso_det
            on update restrict on delete restrict,
    ide_bocam integer  null
        constraint fk_bodt_trans_inv_bodt_catalogo_material
            references bodt_catalogo_material
            on update restrict on delete restrict,
    ide_ingeg integer null
        constraint fk_bodt_trans_inv_bodt_ingreso_egreso
            references bodt_ingreso_egreso
            on update restrict on delete restrict,
    ide_inttr integer not null
        constraint fk_bodt_trans_inv_bodt_ingreso_egreso_det
            references bodt_ingreso_egreso_det
            on update restrict on delete restrict,
    ide_boubi integer not null
        constraint fk_bodt_trans_inv_bodt_bodega_ubicacion
            references bodt_bodega_ubicacion
            on update restrict on delete restrict,
    fecha_transaccion date not null default CURRENT_DATE,
    hora_transaccion time not null default CURRENT_TIME,
    costo_unitario_inged numeric(16,2) not null,
    subtotal_inegd numeric(16,2) not null,
    total_inegd numeric(16,2) not null,
    cantidad_inegd numeric(16,2) not null
);



/***********************/

--TODO: AGREGACIÓN TIPO DE TRANSACCIÓN SALDOS INICIALES
insert into bodt_inventario_tipo_transaccion ( ide_inttr, detalle_inttr, activo_inttr, usuario_ingre, fecha_ingre, hora_ingre, usuario_actua, fecha_actua, hora_actua) values (
7,
'SALDOS INICIALES',
true,
'Administrador',
CURRENT_DATE,
CURRENT_TIME,
'Administrador',
CURRENT_DATE,
CURRENT_TIME);     



/***********************************/


insert into bodt_tra_inv(
                         ide_bocam,
                        ide_inttr,
                         ide_boubi,
                        costo_unitario_inged,
                         subtotal_inegd,
                            total_inegd,
                            cantidad_inegd,
                         fecha_transaccion)
select b.ide_bocam,7,b.ide_boubi,b.costo_inicial_boinv,
       (b.cantidad_inicial_boinv*b.costo_inicial_boinv),
       (b.cantidad_inicial_boinv*b.costo_inicial_boinv),
       b.cantidad_inicial_boinv, fecha_ingre  from bodt_bodega_inventario b;
			 
			 
			 
/*************************************/

insert into bodt_tra_inv(
                         ide_bocam,
                         ide_ingeg,
                         ide_inegd,
                        ide_inttr,
                         ide_boubi,
                         fecha_transaccion,
                        costo_unitario_inged,
                         subtotal_inegd,
                            total_inegd,
                            cantidad_inegd)
select  b.ide_bocam,
        a.ide_ingeg,
        b.ide_inegd,
        a.ide_inttr,
        a.ide_boubi,
b.fecha_ingre,
b.costo_unitario_inegd,
        b.subtotal_inegd,
        b.total_inegd,
        b.cantidad_inegd
        from bodt_ingreso_egreso_det b left join bodt_ingreso_egreso a on b.ide_ingeg=a.ide_ingeg where a.activo_ingeg=true;

    
 
 