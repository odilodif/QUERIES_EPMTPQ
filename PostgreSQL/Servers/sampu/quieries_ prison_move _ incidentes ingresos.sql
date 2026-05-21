--SELECT * from  prison_move  where ppl_id = 196549

SELECT * from  prison_move  where "name" = 'BETSY NADIA' 
SELECT * from  prison_move  where "name" = 'ANGEL VIRGILIO'
 

SELECT *from prison_move WHERE "number" = 'MJDHC-IN-00213604'
SELECT *from prison_move WHERE "number" = 'MJDHC-IN-00144465'


DELETE from prison_move where "number" = 'MJDHC-IN-00213604'
DELETE from prison_move where "number" = 'MJDHC-IN-00144465'

--SELECT * from  prison_location WHERE id=9546

select *from prison_diagnosis where move_id = 622519
DELETE  from prison_diagnosis where move_id = 622519

select *from prison_diagnosis where move_id = 430987
DELETE  from prison_diagnosis where move_id = 430987



SELECT * from prison_document WHERE diag_id=216326   
SELECT * from prison_document WHERE diag_id=146273


/*SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00149980' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00198639' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00141627' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00115853' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00110317' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00097224' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00089219' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00082254' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00078532' and "state" ='noprocess'
SELECT * from prison_detention WHERE "number" ='MJDHC-DET-00084431' and "state" ='noprocess'*/



SELECT * from prison_detention 
WHERE "number" 
in('MJDHC-DET-00149980','MJDHC-DET-00198639','MJDHC-DET-00141627','MJDHC-DET-00115853','MJDHC-DET-00110317','MJDHC-DET-00097224','MJDHC-DET-00089219','MJDHC-DET-00082254','MJDHC-DET-00078532','MJDHC-DET-00084431')
 and "state" = 'noprocess'

