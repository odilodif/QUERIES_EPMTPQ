///////////////////////   dos delitos y desaparece //////////  
 
SELECT * from prison_person WHERE prontuario = 'MJDHC-A-00028604'
SELECT * from prison_move WHERE ppl_id= 85955

///////////////////////// En libertad /////////////////////

SELECT * from prison_person WHERE prontuario = 'MJDHC-A-00028036'
SELECT * from prison_move WHERE ppl_id= 85380

///////////////////////// presente  /////////////////////

SELECT * from prison_person WHERE prontuario = 'MJDHC-A-00028606'
SELECT * from prison_move WHERE ppl_id= 85957