SELECT * from prison_person WHERE prontuario='MJDHC-A-00011276';
SELECT * from prison_person WHERE state='free' ORDER BY "id" DESC limit 1;

UPDATE prison_person SET center_id=NULL ,ult_centro=(SELECT CASE  
WHEN center_id IS NULL  THEN center_to_id
ELSE center_id END 
FROM prison_move WHERE ppl_id= 
(SELECT id FROM prison_person WHERE prontuario='MJDHC-A-00011276') 
AND id =(SELECT max(id) from prison_move WHERE ppl_id=(SELECT id FROM prison_person WHERE prontuario='MJDHC-A-00011276'))), state='free',location_id=NULL,pabellon_id=NULL,piso_id=NULL, ala_id=NULL WHERE id=(SELECT id FROM prison_person WHERE prontuario='MJDHC-A-00011276') ;








SELECT CASE  
WHEN center_id IS NULL  THEN center_to_id
ELSE center_id END 
FROM prison_move WHERE ppl_id= (SELECT id FROM prison_person WHERE prontuario='MJDHC-A-00011276') AND id =(SELECT max(id) from prison_move WHERE ppl_id=(SELECT id FROM prison_person WHERE prontuario='MJDHC-A-00011276'));

