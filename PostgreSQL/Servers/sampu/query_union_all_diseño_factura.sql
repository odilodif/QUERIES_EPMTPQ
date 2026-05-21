SELECT ide_ingeg, usuario_ingre, total_ingeg::DECIMAL
FROM bodt_ingreso_egreso 
WHERE fecha_ingre BETWEEN '2025-04-01' AND '2025-04-30' 
  AND ide_inttr = 1  
  AND ide_adfac IS NULL
UNION ALL
SELECT NULL::integer AS ide_ingeg,'TOTAL'::TEXT, SUM(total_ingeg)::DECIMAL
FROM bodt_ingreso_egreso 
WHERE fecha_ingre BETWEEN '2025-04-01' AND '2025-04-30' 
  AND ide_inttr = 1  
  AND ide_adfac IS NULL;
