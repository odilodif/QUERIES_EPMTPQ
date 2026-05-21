DROP FUNCTION  update_crs_id_user_login();
CREATE OR REPLACE FUNCTION update_crs_id_user_login()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.center_id <> OLD.center_id THEN
		 UPDATE user_login SET crs_id=NEW.center_id WHERE usr_nick=OLD."login";
	   /*INSERT INTO user_login (usr_id_sgp)	VALUES(NEW.center_id); */
	END IF;

	RETURN NEW;
END;
$$

DROP TRIGGER tggr_changes_crs_id_user_login ON res_users;
CREATE TRIGGER tggr_changes_crs_id_user_login
  AFTER UPDATE
  ON res_users
  FOR EACH ROW
  EXECUTE PROCEDURE update_crs_id_user_login();




