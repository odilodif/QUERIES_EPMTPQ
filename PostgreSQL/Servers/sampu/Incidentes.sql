SELECT id from prison_person WHERE prontuario = 'MJDHC-A-00091403'
SELECT *from prison_person WHERE prontuario 	= 'MJDHC-A-00117095'
SELECT *from prison_person WHERE prontuario 	= 'MJDHC-A-00072247'

SELECT * FROM prison_detention WHERE person_id =(SELECT id from prison_person WHERE prontuario = 'MJDHC-A-00091403') AND state = 'noprocess'
SELECT * FROM prison_detention WHERE person_id =(SELECT id from prison_person WHERE prontuario = 'MJDHC-A-00113447') AND state = 'noprocess'
SELECT * FROM prison_detention WHERE person_id =(SELECT id from prison_person WHERE prontuario = 'MJDHC-A-00072247') AND state = 'noprocess'
/*************************************************************************************************************************/
/*************************************************************************************************************************/
/*************************************************************************************************************************/
/*************************************************************************************************************************/

SELECT * from prison_person WHERE prontuario = 'MJDHC-A-00129968'
SELECT * from prison_person WHERE prontuario = 'MJDHC-A-00051628'

SELECT l.id,p.location_id ,l.complete_name from prison_person p, prison_location l
where  p.prontuario = 'MJDHC-A-00129968';




SELECT p."name",p.last_name ,l.complete_name from prison_person p 
RIGHT JOIN  prison_location l on l.id= p.location_id
where  p.prontuario = 'MJDHC-A-00129968';


SELECT * from  prison_move  where "number" = 'MJDHC-SL-00425547' /*MJDHC-SL-00425547*/
--MJDHC-A-00117095

SELECT * FROM prison_detention 
WHERE person_id =(SELECT id from prison_person WHERE prontuario = 'MJDHC-A-00117095') AND state = 'noprocess'

