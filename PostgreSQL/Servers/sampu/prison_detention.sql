select * from prison_person where  prontuario='MJDHC-A-00024881';

select *  from prison_detention where  person_id=(select id from prison_person where  prontuario='MJDHC-A-00024881');

--number ='MJDHC-DET-00027862'