
/****************************************************************************************************************/

delete  from prison_medical WHERE ppl_id=(SELECT id from prison_person where prontuario = 'MJDHC-A-00259025');
delete  from prison_laboral WHERE  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025' );
--delete  from prison_laboral_activity;
delete  from prison_education WHERE  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025');
DELETE from prison_document  WHERE diag_id IN(select id  from prison_diagnosis where  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025' ));
delete  from prison_diagnosis where  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025' );
DELETE  from prison_detention where  person_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025' );
delete from prison_education_week_line WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' );
DELETE  from prison_education_sheet_line WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' ) ;
SELECT * FROM prison_education WHERE boleta_id= (SELECT id FROM prison_move WHERE ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025'))
delete  from prison_education_formal_sheet_line WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' );
delete  from prison_laboral_sheet_line WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' ) ;
select * from prison_laboral WHERE boleta_id= (SELECT id FROM prison_move WHERE ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025'))
select * from prison_medical WHERE boleta_id= (SELECT id FROM prison_move WHERE ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025'))

delete  from prison_freedom WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' ) ;
delete from prison_benefit_request WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' ) ;
delete from prison_sanctions WHERE ppl_id = (SELECT id from prison_person where prontuario='MJDHC-A-00259025' ) ;

select * from prison_move WHERE ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00259025');

select * from prison_person where prontuario='MJDHC-A-00259691' ;


DELETE FROM prison_move
WHERE id IN (
    SELECT id
    FROM prison_move
    ORDER BY id asc
    LIMIT 10000
);



SELECT  * from prison_person WHERE identificador ='0605536432';

SELECT * from prison_location where complete_name like '%CC TULCAN%'
SELECT * from prison_location where id=4248;





DELETE FROM prison_person
WHERE id IN (
    SELECT id
    FROM prison_person
    ORDER BY id asc
    LIMIT 8000
);




select * from prison_freedom  limit 1;

SELECT *  FROM prison_move where ppl_id =(SELECT id from prison_person where prontuario='MJDHC-A-00026494')
/*****************************************************************************************************/
select  prison_education_formal_sheet_line where ppl_id=84292
SELECT * from prison_move where  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00051163');


SELECT * from prison_move where verified_last_name like '%PUNGUIL PAUCAR%'
 

select * from  prison_laboral limit 1
select * from  res_partner limit 10;






