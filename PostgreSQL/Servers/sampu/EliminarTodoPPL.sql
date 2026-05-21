select * from  prison_person where prontuario ='MJDHC-A-00219273';

select *  from prison_detention where  person_id=(SELECT id from prison_person where prontuario='MJDHC-A-00219273' );
select *  from prison_diagnosis where  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00219273' );
select *  from prison_document WHERE diag_id =260762
select *  from prison_education WHERE  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00219273' );
select *  from prison_laboral WHERE  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00219273' );
select *  from prison_medical WHERE ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00219273' );


SELECT * from prison_move where  ppl_id=(SELECT id from prison_person where prontuario='MJDHC-A-00023938' );