SELECT * FROM solicitud_detalle_item;


SELECT sol.ide_solicitud,	sol.estado_solicitud,	sol.fecha_solicitud,	COUNT(sol.ide_solicitud)
FROM solicitud_items sol
INNER JOIN solicitud_detalle_item soldet ON sol.ide_solicitud = soldet.ide_solicitud
GROUP BY 1,2,3
HAVING COUNT(sol.ide_solicitud) > 1

/*-*****/

SELECT sol.ide_solicitud,	sol.estado_solicitud,	sol.fecha_solicitud
FROM solicitud_items sol 



/*******************************************************/

SELECT sol.ide_solicitud,	sol.estado_solicitud,	sol.fecha_solicitud,	sol.ide_solicitud
FROM solicitud_items sol
INNER JOIN solicitud_detalle_item soldet ON sol.ide_solicitud = soldet.ide_solicitud
WHERE  soldet.ide_solicitud = 82;

UPDATE solicitud_detalle_item SET cantidad_disponible_real = cantidad_disponible_real + 1 WHERE ide_bocam = 7

/********************/
SELECT *
FROM solicitud_items sol WHERE sol.ide_solicitud = 98;

SELECT *
FROM solicitud_items WHERE ide_solicitud IN (98,100,101,100,101,102,99,99,102,104,103,104,106,105,106) 

/************************************/


UPDATE 
solicitud_items 
SET estado_solicitud = 'RECHAZADA'
WHERE ide_solicitud = 98


RETURNING sol.ide_solicitud, sol.estado_solicitud, sol.fecha_aprobacion;


UPDATE solicitud_items sol SET estado_solicitud = 'RECHAZADA', fecha_aprobacion = NOW() WHERE sol.ide_solicitud = 98  RETURNING sol.ide_solicitud, sol.estado_solicitud, sol.fecha_aprobacion

SELECT ide_solicitud, fecha_ingre FROM solicitud_detalle_item


UPDATE solicitud_items SET estado_solicitud = 'RECHAZADA', fecha_aprobacion = NOW() WHERE ide_solicitud IN (98,100,101,100,101,102,99,99,102,104,103,104,106,105,106) 
