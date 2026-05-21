SELECT * from prison_person WHERE prontuario ='MJDHC-A-00101168'; -- MJDHC-A-00048693
SELECT * from prison_person WHERE prontuario ='MJDHC-A-00048693'; 
SELECT *from prison_location WHERE id=4254

select * from prison_location where name like '%CRS GUAYAQUIL VARONES 1%'

UPDATE prison_person SET center_id=null, state = 'free', ult_centro= 3092 WHERE prontuario ='MJDHC-A-00101168'; --debe coincidir con los traslados