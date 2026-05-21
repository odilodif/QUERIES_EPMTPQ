WITH fecha_resuelto AS (
    SELECT DISTINCT ON (th.ticket_id)
        th.ticket_id,
        th.create_time AS fecha_resuelto
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 2         
    ORDER BY th.ticket_id, th.create_time
),ultimo_cierre AS (
    SELECT DISTINCT ON (th.ticket_id)
        th.ticket_id,
        th.create_time AS fecha_cierre_final
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 10           
    ORDER BY th.ticket_id, th.create_time DESC
),nota_creacion AS (
    SELECT DISTINCT ON (a.ticket_id)
        a.ticket_id,
        a.id AS article_id
    FROM article a
    JOIN article_data_mime adm ON a.id = adm.article_id
    WHERE a.article_sender_type_id IN (1,3)
      AND adm.a_body IS NOT NULL
      AND trim(adm.a_body) <> ''
    ORDER BY a.ticket_id, a.create_time
),nota_cierre AS (
    SELECT DISTINCT ON (a.ticket_id)
        a.ticket_id,
        a.id AS article_id
    FROM article a
    JOIN article_data_mime adm ON a.id = adm.article_id
    JOIN ultimo_cierre uc ON a.ticket_id = uc.ticket_id
    WHERE a.article_sender_type_id IN (1,3)
      AND adm.a_body IS NOT NULL
      AND trim(adm.a_body) <> ''
      AND a.create_time <= uc.fecha_cierre_final
    ORDER BY a.ticket_id, a.create_time DESC
),fecha_primer_asignado_campo AS (
         SELECT
             th.ticket_id,
             MIN(th.create_time) AS fecha_primer_asignado_campo
         FROM ticket_history th
         WHERE th.history_type_id = 27
           AND th.state_id = 4
         GROUP BY th.ticket_id
     ),fecha_disponible_en_sitio AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_disponible_en_sitio
    FROM ticket_history th
    WHERE th.history_type_id = 27   
      AND th.state_id = 26         
    GROUP BY th.ticket_id
),fecha_pendiente AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_pendiente
    FROM ticket_history th
    WHERE th.history_type_id = 27   
      AND th.state_id = 8           
    GROUP BY th.ticket_id
),fecha_primer_progreso AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_progreso
    FROM ticket_history th
    WHERE th.history_type_id = 27   
      AND th.state_id = 6           
    GROUP BY th.ticket_id
),fecha_ultimo_progreso AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_progreso
    FROM ticket_history th
    WHERE th.history_type_id = 27   
      AND th.state_id = 6           
    GROUP BY th.ticket_id
),fecha_progreso_mtto_preventivo AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_progreso_mtto_preventivo
    FROM ticket_history th
    WHERE th.history_type_id = 27  
      AND th.state_id = 14           
    GROUP BY th.ticket_id
),fecha_primer_alistamiento AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_alistamiento
    FROM ticket_history th
    WHERE th.history_type_id = 27   
      AND th.state_id = 15           
    GROUP BY th.ticket_id
),
fecha_ultimo_alistamiento AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_alistamiento
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 15
    GROUP BY th.ticket_id
),
fecha_primer_entregado_transporte AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_entregado_transporte
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 16
    GROUP BY th.ticket_id
),fecha_ultimo_entregado_transporte AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_entregado_transporte
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 16
    GROUP BY th.ticket_id
),
fecha_primer_enviado_campo AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_enviado_campo
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 17
    GROUP BY th.ticket_id
),fecha_ultimo_enviado_campo AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_enviado_campo
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 17
    GROUP BY th.ticket_id
),
fecha_primer_entregado_campo AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_entregado_campo
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 18
    GROUP BY th.ticket_id
),fecha_ultimo_entregado_campo AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_entregado_campo
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 18
    GROUP BY th.ticket_id
),
fecha_primer_recibido_bodega AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_recibido_bodega
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 24
    GROUP BY th.ticket_id
),fecha_ultimo_recibido_bodega AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_recibido_bodega
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 24
    GROUP BY th.ticket_id
),
fecha_primer_recibido_transporte AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_recibido_transporte
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 20
    GROUP BY th.ticket_id
),fecha_ultimo_recibido_transporte AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_recibido_transporte
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 20
    GROUP BY th.ticket_id
),
fecha_primer_evaluacion AS (
    SELECT
        th.ticket_id,
        MIN(th.create_time) AS fecha_primer_evaluacion
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 11
    GROUP BY th.ticket_id
),fecha_ultimo_evaluacion AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_ultimo_evaluacion
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 11
    GROUP BY th.ticket_id
),fecha_validado_supervisor AS (
    SELECT
        th.ticket_id,
        MAX(th.create_time) AS fecha_validado_supervisor
    FROM ticket_history th
    WHERE th.history_type_id = 27
      AND th.state_id = 27
    GROUP BY th.ticket_id
)SELECT
    t.tn AS Ticket,
    tt.name AS Tipo,
    s.name AS Servicio,
    q.name AS Cola,
    (t.create_time + INTERVAL '5 hours') AS Fecha_Creacion,
    CASE EXTRACT(MONTH FROM t.create_time)
        WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
    END AS Mes_Creacion,
    (fr.fecha_resuelto + INTERVAL '5 hours') AS Fecha_Resuelto,
    dfv_3.value_text AS Requerimiento_Soporte,
    (uc.fecha_cierre_final +  INTERVAL '5 hours') AS Fecha_Cierre,
    adm_nc.a_body AS Nota_Creacion,
    adm_fc.a_body AS Nota_Cierre,
    ts.name AS Estado,
    concat(cu.first_name,' ',cu.last_name) as Cliente,
    dfv_8.value_text as Tipo_falla,
    t.title AS Asunto,
    dfv_160.value_text as Nombre,
    dfv_163.value_text as Tipo_infraestructura,
    dfv_164.value_text as CORREDORT,
    dfv_5.value_text as EQUIPO,
    dfv_154.value_text as IDEQUIPO,
    dfv_158.value_text as Ubicacion,
    dfv_159.value_text as CRITICIDADF,
    sl.name as SLA,
    dfv_6.value_text as COMPONENTE,
    dfv_4.value_text as CATEGORIATICKET,
    (fpac.fecha_primer_asignado_campo + INTERVAL '5 hours')AS Fecha_Primer_Asignado_Campo,
    (fds.fecha_disponible_en_sitio + INTERVAL '5 hours') AS "Fecha Disponible en Sitio",
    (fp.fecha_pendiente + INTERVAL '5 hours') AS "Fecha Pendiente",
    (fpp.fecha_primer_progreso + INTERVAL '5 hours') AS "Fecha de Primer Progreso",
    (fup.fecha_ultimo_progreso + INTERVAL '5 hours') as fecha_ultimo_progreso,
    (fpmp.fecha_progreso_mtto_preventivo+ INTERVAL '5 hours') AS "Fecha Progress Mtto Preventivo",
    (fpa.fecha_primer_alistamiento + INTERVAL '5 hours') AS "Fecha Primer Proceso de Alistamiento",
    (fua.fecha_ultimo_alistamiento + INTERVAL '5 hours') AS "Fecha Último Proceso de Alistamiento",
    (fpet.fecha_primer_entregado_transporte + INTERVAL '5 hours') as fecha_primer_entregado_transporte,
    (fuet.fecha_ultimo_entregado_transporte + INTERVAL '5 hours' ) as fecha_ultimo_entregado_transporte,
    (fpec.fecha_primer_enviado_campo + INTERVAL '5 hours')as fecha_primer_enviado_campo,
    (fuec.fecha_ultimo_enviado_campo + INTERVAL '5 hours') as fecha_ultimo_enviado_campo,
    (ffpec.fecha_primer_entregado_campo + INTERVAL '5 hours') as fecha_primer_entregado_campo,
    (ffuec.fecha_ultimo_entregado_campo + INTERVAL '5 hours') as fecha_ultimo_entregado_campo,
    (fprb.fecha_primer_recibido_bodega + INTERVAL '5 hours') as fecha_primer_recibido_bodega ,
    (furb.fecha_ultimo_recibido_bodega + INTERVAL '5 hours') as fecha_ultimo_recibido_bodega,
    (fprt.fecha_primer_recibido_transporte + INTERVAL '5 hours') as fecha_primer_recibido_transporte,
    (furt.fecha_ultimo_recibido_transporte + INTERVAL '5 hours') as fecha_ultimo_recibido_transporte,
    (fpe.fecha_primer_evaluacion + INTERVAL '5 hours') as fecha_primer_evaluacion,
    (fue.fecha_ultimo_evaluacion + INTERVAL '5 hours') as fecha_ultimo_evaluacion,
    dfv_198.value_text as Afectacion_Servicios,
    dfv_195.value_text as Nombre_Seguimiento,
    dfv_190.value_text as Quien_gestiona,
    dfv_197.value_text as Motivo_No_Intervesion,
    dfv_205.value_text as Tipo_Atencion,
    pc1.value_text AS repuesto_pieza_cambiada1,
  sr1.value_text AS serial_fisico_retirado1,
  si1.value_text AS serial_fisico_instalado1,
  pc2.value_text AS repuesto_pieza_cambiada2,
  sr2.value_text AS serial_fisico_retirado2,         
  si2.value_text AS serial_fisico_instalado2,
  pc3.value_text AS repuesto_pieza_cambiada3,
  sr3.value_text AS serial_fisico_retirado3,
  si3.value_text AS serial_fisico_instalado3,
  dfv_191.value_text as mala_manipulacion,
  dfv_192.value_text as CAMBIODEPARTE,
  fvs.fecha_validado_supervisor,
  esdb1.value_text as estado_parte1,
  esdb2.value_text as estado_parte2,
  esdb3.value_text as estado_parte3
FROM ticket t
LEFT JOIN ticket_type tt ON t.type_id = tt.id
LEFT JOIN service s ON t.service_id = s.id
LEFT JOIN queue q ON t.queue_id = q.id
LEFT JOIN ticket_state ts ON t.ticket_state_id = ts.id
left join sla sl on t.sla_id = sl.id
LEFT JOIN fecha_resuelto fr ON t.id = fr.ticket_id
LEFT JOIN ultimo_cierre uc ON t.id = uc.ticket_id
LEFT JOIN nota_creacion nc ON t.id = nc.ticket_id
LEFT JOIN article_data_mime adm_nc ON nc.article_id = adm_nc.article_id
LEFT JOIN nota_cierre nci ON t.id = nci.ticket_id
LEFT JOIN article_data_mime adm_fc ON nci.article_id = adm_fc.article_id
left join customer_user cu on t.customer_user_id = cu.login
LEFT JOIN fecha_primer_asignado_campo fpac ON t.id = fpac.ticket_id
LEFT JOIN fecha_disponible_en_sitio fds ON t.id = fds.ticket_id
LEFT JOIN fecha_pendiente fp ON t.id = fp.ticket_id
LEFT JOIN fecha_primer_progreso fpp ON t.id = fpp.ticket_id
LEFT JOIN fecha_ultimo_progreso fup ON t.id = fup.ticket_id 
LEFT JOIN fecha_progreso_mtto_preventivo fpmp ON t.id = fpmp.ticket_id
LEFT JOIN fecha_primer_alistamiento fpa ON t.id = fpa.ticket_id
LEFT JOIN fecha_ultimo_alistamiento fua ON t.id = fua.ticket_id
left join fecha_primer_entregado_transporte fpet on t.id = fpet.ticket_id
left join fecha_ultimo_entregado_transporte fuet on t.id = fuet.ticket_id
left join fecha_primer_enviado_campo fpec on t.id = fpec.ticket_id
left join fecha_ultimo_enviado_campo fuec on t.id = fuec.ticket_id
left join fecha_primer_entregado_campo ffpec on t.id = ffpec.ticket_id
left join fecha_ultimo_entregado_campo ffuec on t.id = ffuec.ticket_id
left join fecha_primer_recibido_bodega fprb on t.id = fprb.ticket_id
left join fecha_ultimo_recibido_bodega furb on t.id = furb.ticket_id
left join fecha_primer_recibido_transporte fprt on t.id = fprt.ticket_id
left join fecha_ultimo_recibido_transporte furt on t.id = furt.ticket_id
left join fecha_primer_evaluacion fpe on t.id = fpe.ticket_id
left join fecha_ultimo_evaluacion fue on t.id = fue.ticket_id
left join fecha_validado_supervisor fvs on t.id = fvs.ticket_id
LEFT JOIN dynamic_field_value dfv_3   ON t.id = dfv_3.object_id   AND dfv_3.field_id = 3
LEFT JOIN dynamic_field_value dfv_8   ON t.id = dfv_8.object_id   AND dfv_8.field_id = 8
LEFT JOIN dynamic_field_value dfv_160 ON t.id = dfv_160.object_id AND dfv_160.field_id = 160
LEFT JOIN dynamic_field_value dfv_163 ON t.id = dfv_163.object_id AND dfv_163.field_id = 163
LEFT JOIN dynamic_field_value dfv_164 ON t.id = dfv_164.object_id AND dfv_164.field_id = 164
LEFT JOIN dynamic_field_value dfv_5   ON t.id = dfv_5.object_id   AND dfv_5.field_id = 5
LEFT JOIN dynamic_field_value dfv_154 ON t.id = dfv_154.object_id AND dfv_154.field_id = 154
LEFT JOIN dynamic_field_value dfv_158 ON t.id = dfv_158.object_id AND dfv_158.field_id = 158
LEFT JOIN dynamic_field_value dfv_159 ON t.id = dfv_159.object_id AND dfv_159.field_id = 159
LEFT JOIN dynamic_field_value dfv_6   ON t.id = dfv_6.object_id   AND dfv_6.field_id = 6
LEFT JOIN dynamic_field_value dfv_4   ON t.id = dfv_4.object_id   AND dfv_4.field_id = 4
LEFT JOIN dynamic_field_value dfv_198 ON t.id = dfv_198.object_id AND dfv_198.field_id = 198
LEFT JOIN dynamic_field_value dfv_195 ON t.id = dfv_195.object_id AND dfv_195.field_id = 195
LEFT JOIN dynamic_field_value dfv_190 ON t.id = dfv_190.object_id AND dfv_190.field_id = 190
LEFT JOIN dynamic_field_value dfv_191 ON t.id = dfv_191.object_id AND dfv_191.field_id = 191
LEFT JOIN dynamic_field_value dfv_192 ON t.id = dfv_192.object_id AND dfv_192.field_id = 192
LEFT JOIN dynamic_field_value dfv_197 ON t.id = dfv_197.object_id AND dfv_197.field_id = 197
LEFT JOIN dynamic_field_value dfv_205 ON t.id = dfv_205.object_id AND dfv_205.field_id = 205
LEFT JOIN dynamic_field_value pc1     ON t.id = pc1.object_id     AND pc1.field_id = 171 AND pc1.index_set = 0 
LEFT JOIN dynamic_field_value sr1     ON t.id = sr1.object_id     AND sr1.field_id = 172 AND sr1.index_set = 0 
LEFT JOIN dynamic_field_value si1     ON t.id = si1.object_id     AND si1.field_id = 201 AND si1.index_set = 0 
LEFT JOIN dynamic_field_value pc2     ON t.id = pc2.object_id     AND pc2.field_id = 171 AND pc2.index_set = 1 
LEFT JOIN dynamic_field_value sr2     ON t.id = sr2.object_id     AND sr2.field_id = 172 AND sr2.index_set = 1 
LEFT JOIN dynamic_field_value si2     ON t.id = si2.object_id     AND si2.field_id = 201 AND si2.index_set = 1 
LEFT JOIN dynamic_field_value pc3     ON t.id = pc3.object_id     AND pc3.field_id = 171 AND pc3.index_set = 2 
LEFT JOIN dynamic_field_value sr3     ON t.id = sr3.object_id     AND sr3.field_id = 172 AND sr3.index_set = 2 
LEFT JOIN dynamic_field_value si3     ON t.id = si3.object_id     AND si3.field_id = 201 AND si3.index_set = 2 
LEFT JOIN dynamic_field_value esdb1   ON t.id = esdb1.object_id   AND esdb1.field_id = 208 AND esdb1.index_set = 0 
LEFT JOIN dynamic_field_value esdb2   ON t.id = esdb2.object_id   AND esdb2.field_id = 208 AND esdb2.index_set = 1 
LEFT JOIN dynamic_field_value esdb3   ON t.id = esdb3.object_id   AND esdb3.field_id = 208 AND esdb3.index_set = 2 
WHERE 1=1

AND (
  NULLIF('', '') IS NULL
  OR t.create_time >= NULLIF('', '')::timestamptz
)
AND (
  NULLIF('', '') IS NULL
  OR t.create_time <= NULLIF('', '')::timestamptz
)

AND (
  NULLIF('', '') IS NULL
  OR fr.fecha_resuelto >= NULLIF('', '')::timestamptz
)
AND (
  NULLIF('', '') IS NULL
  OR fr.fecha_resuelto <= NULLIF('', '')::timestamptz
)
AND (
  NULLIF('', '') IS NULL
  OR uc.fecha_cierre_final >= NULLIF('', '')::timestamptz
)
AND (
  NULLIF('', '') IS NULL
  OR uc.fecha_cierre_final <= NULLIF('', '')::timestamptz
)

-- Filtros adicionales omitidos por brevedad pero mantenidos en el query original
AND ts.name ~ '^((ANULADO POR DUPLICIDAD|ASIGNADO A CAMPO|CERRADO|CERRADO POR INFORMACIÓN|CONFIRMADO EN SITIO|DISPONIBLE EN SITIO|EN PROCESO DE ALISTAMIENTO|EN PROGRESO|ENTREGADO A TRANSPORTE|ENTREGADO EN CAMPO|ENVIADO A CAMPO|merged|NUEVO|NUEVO BODEGA|PARA EVALUACION|PENDIENTE|PENDIENTE BODEGA|PENDIENTE DE INFORMACION|PROGRESO MTTO PREVENTIVO|RECIBIDO EN BODEGA|RECIBIDO EN CES|RECIBIDO POR TRANSPORTE|RESUELTO|SOLICITUD DE RECOLECCION|SOLUCION TEMPORAL|VALIDADO POR SUPERVISOR))$'
AND COALESCE(s.name,'SIN_SERVICIO') IN ('BODEGA','BODEGA::SOLICITUD DE ABASTECIMIENTO','BODEGA::SOLICITUD DE PARTE DIRECTA','BODEGA::SOLICITUD DE PARTE DIRECTA::ABASTECIMIENTO','EQUIPOS CENTRALES::OTOBO','PARADA - ESTACION - TERMINAL','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::AWS','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::AWS::SERVIDOR AWS','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::GEA','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::GEA::SERVIDOR GEA','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::OTOBO','PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::OTOBO::SERVIDOR OTOBO','PARADA - ESTACION - TERMINAL::MANTENIMIENTO PREVENTIVO','PARADA - ESTACION - TERMINAL::PERIFERICO','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::CAJA DE SEGURIDAD','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::IMPRESORA DE JUSTIFICANTES Y BILLETES','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::INTERCOMUNICADOR','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::MONITOR PC','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::PC ESCRITORIO','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE VENTA','PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE VENTA::INTERCOMUNICADOR','PARADA - ESTACION - TERMINAL::PERIFERICO::RECAUDO','PARADA - ESTACION - TERMINAL::PERIFERICO::RECAUDO::PUNTO DE ATENCION','PARADA - ESTACION - TERMINAL::PERIFERICO::RECAUDO::PUNTO DE ATENCION::MONITOR PC','PARADA - ESTACION - TERMINAL::RECAUDO','PARADA - ESTACION - TERMINAL::RECAUDO::ALARMA MONITOREO GEA','PARADA - ESTACION - TERMINAL::RECAUDO::CONECTIVIDAD','PARADA - ESTACION - TERMINAL::RECAUDO::CONECTIVIDAD::COMUNICACION DE DATOS','PARADA - ESTACION - TERMINAL::RECAUDO::CONECTIVIDAD::COMUNICACION DE DATOS::DISPOSITIVOS ACTIVOS DE RED','PARADA - ESTACION - TERMINAL::RECAUDO::CONSULTA DE SALDO','PARADA - ESTACION - TERMINAL::RECAUDO::CONSULTA DE SALDO::TERMINAL DE CONSULTA','PARADA - ESTACION - TERMINAL::RECAUDO::CONSULTA DE SALDO::TERMINAL DE INSPECCION','PARADA - ESTACION - TERMINAL::RECAUDO::INFRAESTRUCTURA SIR','PARADA - ESTACION - TERMINAL::RECAUDO::INFRAESTRUCTURA SIR::GABINETE SIR','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::ATM TVM','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::CONCENTRADOR','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::LECTOR QR-PAU','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::MONEDERO','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::PROBADOR DE BILLETES','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::PUNTO DE CARGA Y VALIDACION MOVIL','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA::LECTOR QR-POS','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA::MONEDERO','PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA::PROBADOR DE BILLETES','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::LECTOR QR-PAU','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::LECTOR QR-POS','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::MODULO DE PAGO TORNO BAJO','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::UNIDAD POS','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA::LECTOR QR-POS','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA::MODULO DE PAGO TORNO BAJO','PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA::UNIDAD POS','PARADA - ESTACION - TERMINAL::RECAUDO::RESPALDO ELECTRICO','PARADA - ESTACION - TERMINAL::RECAUDO::RESPALDO ELECTRICO::SISTEMA DE RESPALDO ELECTRICO','PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION','PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA PMR','PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA TORNO ALTO SALIDA','PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA TORNO BAJO BIDIRECCIONAL','PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA TORNO BAJO ENTRADA','SIN_SERVICIO')
--AND s.name ~ '^((BODEGA|BODEGA::SOLICITUD DE ABASTECIMIENTO|BODEGA::SOLICITUD DE PARTE DIRECTA|BODEGA::SOLICITUD DE PARTE DIRECTA::ABASTECIMIENTO|EQUIPOS CENTRALES::OTOBO|PARADA - ESTACION - TERMINAL|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::AWS|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::AWS::SERVIDOR AWS|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::GEA|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::GEA::SERVIDOR GEA|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::OTOBO|PARADA - ESTACION - TERMINAL::EQUIPOS CENTRALES::NUBE PRIVADA::OTOBO::SERVIDOR OTOBO|PARADA - ESTACION - TERMINAL::MANTENIMIENTO PREVENTIVO|PARADA - ESTACION - TERMINAL::PERIFERICO|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::CAJA DE SEGURIDAD|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::IMPRESORA DE JUSTIFICANTES Y BILLETES|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::INTERCOMUNICADOR|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::MONITOR PC|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE ATENCION::PC ESCRITORIO|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE VENTA|PARADA - ESTACION - TERMINAL::PERIFERICO::PUNTO DE VENTA::INTERCOMUNICADOR|PARADA - ESTACION - TERMINAL::PERIFERICO::RECAUDO|PARADA - ESTACION - TERMINAL::PERIFERICO::RECAUDO::PUNTO DE ATENCION|PARADA - ESTACION - TERMINAL::PERIFERICO::RECAUDO::PUNTO DE ATENCION::MONITOR PC|PARADA - ESTACION - TERMINAL::RECAUDO|PARADA - ESTACION - TERMINAL::RECAUDO::ALARMA MONITOREO GEA|PARADA - ESTACION - TERMINAL::RECAUDO::CONECTIVIDAD|PARADA - ESTACION - TERMINAL::RECAUDO::CONECTIVIDAD::COMUNICACION DE DATOS|PARADA - ESTACION - TERMINAL::RECAUDO::CONECTIVIDAD::COMUNICACION DE DATOS::DISPOSITIVOS ACTIVOS DE RED|PARADA - ESTACION - TERMINAL::RECAUDO::CONSULTA DE SALDO|PARADA - ESTACION - TERMINAL::RECAUDO::CONSULTA DE SALDO::TERMINAL DE CONSULTA|PARADA - ESTACION - TERMINAL::RECAUDO::CONSULTA DE SALDO::TERMINAL DE INSPECCION|PARADA - ESTACION - TERMINAL::RECAUDO::INFRAESTRUCTURA SIR|PARADA - ESTACION - TERMINAL::RECAUDO::INFRAESTRUCTURA SIR::GABINETE SIR|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::ATM TVM|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::CONCENTRADOR|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::LECTOR QR-PAU|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::MONEDERO|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::PROBADOR DE BILLETES|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE ATENCION::PUNTO DE CARGA Y VALIDACION MOVIL|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA::LECTOR QR-POS|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA::MONEDERO|PARADA - ESTACION - TERMINAL::RECAUDO::PUNTO DE VENTA::PROBADOR DE BILLETES|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::LECTOR QR-PAU|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::LECTOR QR-POS|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::MODULO DE PAGO TORNO BAJO|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE ATENCION::UNIDAD POS|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA::LECTOR QR-POS|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA::MODULO DE PAGO TORNO BAJO|PARADA - ESTACION - TERMINAL::RECAUDO::RECARGA::PUNTO DE VENTA::UNIDAD POS|PARADA - ESTACION - TERMINAL::RECAUDO::RESPALDO ELECTRICO|PARADA - ESTACION - TERMINAL::RECAUDO::RESPALDO ELECTRICO::SISTEMA DE RESPALDO ELECTRICO|PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION|PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA PMR|PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA TORNO ALTO SALIDA|PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA TORNO BAJO BIDIRECCIONAL|PARADA - ESTACION - TERMINAL::RECAUDO::VALIDACION::BCA TORNO BAJO ENTRADA|SIN_SERVICIO))$'
--AND dfv_4.value_text ~ '^((PARADA - ESTACION - TERMINAL|SIN_CATEGORIA))$'
AND COALESCE(NULLIF(dfv_4.value_text,''),'SIN_CATEGORIA') IN ('PARADA - ESTACION - TERMINAL','SIN_CATEGORIA')
AND COALESCE(tt.name,'SIN_TIPO') IN ('EVENTO','INCIDENTE','SIN_TIPO','SOLICITUD')
AND q.name ~ '^((BODEGA|CONECTIVIDAD|DESARROLLO|INFRAESTRUCTURA TECNOLOGICA|INSTALACION - DESINSTALACION|LOCACIONES|MANTENIMIENTO PARADA - ESTACION - TERMINAL|MANTENIMIENTO PREVENTIVO|MESA DE AYUDA|SEGURIDAD INFORMATICA|SOPORTE ESPECIALIZADO|SUBSISTEMA RECAUDO_GEA|TRANSPORTE))$'
AND COALESCE(NULLIF(dfv_160.value_text,''),'SIN_ESTACION') IN ('ESTACION EL RECREO','ESTACION GUAMANI','ESTACION MARIN CENTRAL','ESTACION MORAN VALVERDE','ESTACION RIO COCA','PAU ESTACION EL RECREO','PAU ESTACION MARIN CENTRAL','PAU ESTACION MORAN VALVERDE','PAU ESTACION RIO COCA','POS ESTACION EL RECREO','POS ESTACION MORAN VALVERDE','POS ESTACION RIO COCA','POS TERMINAL CARCELEN','SIN_ESTACION','TERMINAL CARCELEN')
AND COALESCE(NULLIF(dfv_163.value_text,''),'SIN_TIPO_INFRAESTRUCTURA') IN ('ESTACION','SIN_TIPO_INFRAESTRUCTURA','TERMINAL')
--AND dfv_163.value_text ~ '^((ESTACION|SIN_TIPO_INFRAESTRUCTURA|TERMINAL))$'
--AND dfv_164.value_text ~ '^((ECOVIA|INTEGRACION \(TROLEBUS\/ECOVIA\)|SIN_CORREDOR|TROLEBUS))$'
AND COALESCE(NULLIF(dfv_164.value_text,''),'SIN_CORREDOR') IN ('ECOVIA','INTEGRACION (TROLEBUS/ECOVIA)','SIN_CORREDOR','TROLEBUS')
--AND dfv_5.value_text ~ '^((ATM TVM|BCA PMR|BCA TORNO BAJO BIDIRECCIONAL|CONCENTRADOR|IMPRESORA JUSTIFICANTES Y BILLETES|LECTOR QR-POS|SIN_EQUIPO|TERMINAL DE CONSULTA|UNIDAD POS))$'
AND COALESCE(NULLIF(dfv_5.value_text,''),'SIN_EQUIPO') IN ('ATM TVM','BCA PMR','BCA TORNO BAJO BIDIRECCIONAL','CONCENTRADOR','IMPRESORA JUSTIFICANTES Y BILLETES','LECTOR QR-POS','SIN_EQUIPO','TERMINAL DE CONSULTA','UNIDAD POS')
--AND dfv_6.value_text ~ '^((HW|SIN_COMPONENTE|SW))$'
AND COALESCE(NULLIF(dfv_6.value_text,''),'SIN_COMPONENTE') IN ('HW','SIN_COMPONENTE','SW')
ORDER BY t.create_time desc