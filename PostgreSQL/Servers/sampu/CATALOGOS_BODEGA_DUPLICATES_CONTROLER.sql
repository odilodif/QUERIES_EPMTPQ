/************************ CATALOGOS_BODEGA_DUPLICATES_CONTROLER ********************/

SELECT catalogo.ide_bocam,   
catalogo.descripcion_bocam 
FROM bodt_catalogo_material as catalogo 
WHERE  ide_prcla = 1130 AND catalogo.ide_parte =  
 (SELECT ide_parte FROM bodt_catalogo_material cat1 WHERE cat1.ide_parte = 'ABR071N' LIMIT 1 )
 
 /*********************************************************/
 
SELECT catalogo.ide_bocam, ( SELECT clas1.codigo_clasificador_prcla FROM pre_clasificador clas1 WHERE clas1.ide_prcla = catalogo.ide_prcla ),
catalogo.ide_parte,
catalogo.ide_bocam,
catalogo.descripcion_bocam 
FROM bodt_catalogo_material as catalogo 
WHERE /* ide_prcla = 1130 AND */ catalogo.ide_parte =  
 (
SELECT ide_parte FROM bodt_catalogo_material cat1 WHERE cat1.ide_parte = 'ABR071N' LIMIT 1
 )
 
 

/*******************************/
SELECT 
ide_prcla,codigo_clasificador_prcla, 
descripcion_clasificador_prcla 
FROM pre_clasificador 
WHERE ide_prcla = 1130;

/*************************************/


 SELECT catalogo.ide_bocam,  ( SELECT clas1.codigo_clasificador_prcla FROM pre_clasificador clas1 WHERE clas1.ide_prcla = catalogo.ide_prcla ),  catalogo.ide_parte,   catalogo.descripcion_bocam  FROM bodt_catalogo_material as catalogo  WHERE  ide_prcla = 1130 AND catalogo.ide_parte  =   (  SELECT ide_parte FROM bodt_catalogo_material cat1 WHERE cat1.ide_parte = 'ABR071N' LIMIT 1    ) 



/***********************/

 SELECT catalogo.ide_bocam,  ( SELECT clas1.codigo_clasificador_prcla FROM pre_clasificador clas1 WHERE clas1.ide_prcla = catalogo.ide_prcla ),  catalogo.ide_parte,  catalogo.descripcion_bocam  FROM bodt_catalogo_material as catalogo  WHERE   catalogo.ide_parte  =   (  SELECT ide_parte FROM bodt_catalogo_material cat1 WHERE cat1.ide_parte = 'ABR071N' LIMIT 1    ) 
 
 
 SELECT catalogo.ide_bocam,   catalogo.descripcion_bocam FROM bodt_catalogo_material as catalogo WHERE ide_prcla =   1011 AND catalogo.ide_parte =    (SELECT ide_parte FROM bodt_catalogo_material cat1 WHERE cat1.ide_parte = 'ABR071N' LIMIT 1 ) 



SELECT catalogo.ide_bocam,  ( SELECT clas1.codigo_clasificador_prcla FROM pre_clasificador clas1 WHERE clas1.ide_prcla = catalogo.ide_prcla ),  catalogo.ide_parte,  catalogo.descripcion_bocam  FROM bodt_catalogo_material as catalogo  WHERE  ide_prcla = 1011 AND catalogo.ide_parte  =   (  SELECT ide_parte FROM bodt_catalogo_material cat1 WHERE cat1.ide_parte = 'ABR071N' LIMIT 1    ) 




