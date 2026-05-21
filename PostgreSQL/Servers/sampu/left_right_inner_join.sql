
/***********************Extraer todos perfiles aunque no tengan rol prioridad la tabla izquierda en este caso profile**************************************/
SELECT prfl.prfle_description, rl.rol_description FROM profile prfl
LEFT JOIN rol rl ON prfl.rol_id=rl.rol_id

/***********************Extraer todos roles aunque no tengan perfil prioridad la tabla derecha en este caso rol**************************************/
SELECT prfl.prfle_description, rl.rol_description FROM profile prfl
RIGHT JOIN rol rl ON prfl.rol_id=rl.rol_id