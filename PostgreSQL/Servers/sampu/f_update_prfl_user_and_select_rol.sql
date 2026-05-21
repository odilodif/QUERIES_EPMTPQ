/*************************************OBTENER EL ROL CON EL idSGP *************************************/
SELECT rol_id,rol_description FROM rol WHERE rol_id=(SELECT rl.rol_id FROM user_login usr 
INNER JOIN profile prfl ON usr.prfle_id=prfl.prfle_id
INNER JOIN rol rl ON prfl.rol_id= rl.rol_id
WHERE usr.usr_id_sgp=2066)

/*****************OBTENER TODOS LOS ROLES AUNQUE NO TENGA PERFILES ***************************/
SELECT prfl.rol_id,rl.rol_description,rl.rol_state,rl.create, rl.read,rl.update, rl.delete FROM (SELECT rol1.rol_id, rol1.rol_description FROM rol rol1 WHERE rol1.rol_id=(SELECT rl.rol_id FROM user_login usr 
	INNER JOIN profile prfl ON usr.prfle_id=prfl.prfle_id
	INNER JOIN rol rl ON prfl.rol_id= rl.rol_id
	WHERE usr.usr_id_sgp=2066)) AS  prfl
	RIGHT JOIN rol rl on prfl.rol_id=rl.rol_id ORDER BY rl.rol_id ASC;  
	


/*********************************DELETE FUNCTION****************************************************/
DROP FUNCTION f_update_prfl_user_and_select_rol(int,int);
/**************************************************************************************/


/**************************************FUNCTION****************************************************/
CREATE OR REPLACE FUNCTION f_update_prfl_user_and_select_rol(_usr_id_sgp INT, _profile_id INT, OUT rol_id INT,	OUT rol_description VARCHAR(100) )
RETURNS SETOF record
AS $$	
	UPDATE user_login  SET prfle_id= $2 WHERE usr_id_sgp= $1;
 SELECT prfl.rol_id,rl.rol_description FROM (SELECT rol1.rol_id, rol1.rol_description FROM rol rol1 WHERE rol1.rol_id=(SELECT rl.rol_id FROM user_login usr 
	INNER JOIN profile prfl ON usr.prfle_id=prfl.prfle_id
	INNER JOIN rol rl ON prfl.rol_id= rl.rol_id
	WHERE usr.usr_id_sgp=$1)) AS  prfl
	RIGHT JOIN rol rl on prfl.rol_id=rl.rol_id ORDER BY rl.rol_id ASC;             
$$ LANGUAGE SQL;

SELECT * from f_update_prfl_user_and_select_rol(2066, 3);

SELECT * from f_calcule_porcentage_and_get_table_elapsed_percentage60(2505);







