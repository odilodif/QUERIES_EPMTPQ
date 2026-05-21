SELECT 
  a.ide_comov,
  COUNT(*) AS repeticiones
FROM view_subconsult_tbl_a a
LEFT JOIN view_subconsulta_tbl_b b ON a.ide_comov = b.ide_comov
WHERE
  a.mov_fecha_comov BETWEEN '2025-01-01' AND '2025-06-29'
  AND b.ide_cocac IN (4663, 5249)
  AND b.ruc IN ('1719384081')
	
GROUP BY a.ide_comov
HAVING COUNT(*) > 1
ORDER BY repeticiones DESC;
