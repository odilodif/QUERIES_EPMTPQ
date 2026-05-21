SELECT id,name,last_name,identificador,sex,prontuario,state FROM prison_person
WHERE ((name like '%JOS%' OR last_name like '' or prontuario like '' )  AND state <> 'free' ) ORDER BY id limit 4 OFFSET 0 ;

select * from prison_detention_judgment where id = 220827
select * from prison_detention WHERE person_id =(SELECT id from prison_person WHERE prontuario = 'MJDHC-A-00180211');select select * from prison_detention_resource WHERE recurso = 'reg_semi' limit 1