SELECT * FROM profile;
SELECT * from rol;


CREATE TABLE profile_rol_user(
usr_id_sgp INT NOT NULL,
prfle_id INT NOT NULL,
rol_id INT  NOT NULL
);

ALTER TABLE profile_rol_user
DROP CONSTRAINT  profile_usr_id_sgp_fk;


ALTER TABLE profile_rol_user 
ADD CONSTRAINT profile_usr_id_sgp_fk 
FOREIGN KEY (usr_id_sgp)
REFERENCES user_login (usr_id_sgp) ON DELETE CASCADE;



ALTER TABLE profile_rol_user
ADD CONSTRAINT profile_prfle_id_fk
FOREIGN KEY (prfle_id) 
REFERENCES profile(prfle_id) ON DELETE CASCADE;


ALTER TABLE profile_rol_user
ADD CONSTRAINT profile_rol_fk
FOREIGN KEY (rol_id)
REFERENCES rol(rol_id) ON DELETE CASCADE ;












