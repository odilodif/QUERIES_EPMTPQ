SELECT ingcab.ide_boubi as ingcab_ubi, ingdet.ide_ingeg as ingdet, COUNT(ingdet.ide_ingeg) FROM bodt_ingreso_egreso ingcab
INNER JOIN bodt_ingreso_egreso_det ingdet ON ingcab.ide_ingeg = ingdet.ide_ingeg
WHERE ingdet.ide_inttr ISNULL AND ingcab.ide_inttr =1  GROUP BY 1,2;
/***********************************************/
SELECT * FROM bodt_ingreso_egreso_det WHERE ide_ingeg IN (
255
,260
,171
,241
,498
,245
,401
,559
,640
,642
,334
,393
,416
,615
,775) ORDER BY 14 ASC;
/**********************************************/
UPDATE bodt_ingreso_egreso_det
SET  ide_inttr=1
WHERE ide_ingeg IN (
255
,260
,171
,241
,498
,245
,401
,559
,640
,642
,334
,393
,416
,615
,775)


