SELECT * FROM qr 
WHERE fh >= '2026-04-01 00:00:00'
ORDER BY 4 ; 

/**********************************/

SELECT * FROM validacion 
WHERE fh >= '2026-04-01 00:00:00'
AND perfil = 'QR' 
ORDER BY 4 ; 