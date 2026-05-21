
/*CREATE SEQUENCE "public"."trasl_type_user_login_trasl_type_user_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 2147483647
 START 1
 CACHE 1;
 
 SELECT setval('"public"."trasl_type_user_login_trasl_type_user_id_seq"', 1, true);
 
 nextval('trasl_type_user_login_trasl_type_user_id_seq'::regclass)*/
 
 
 /*SELECT * FROM trasl_type_user_login typu
 INNER JOIN user_login usr on typu.usr_id=usr.usr_id
 INNER JOIN traslation_type ttyp on  ttyp.trasl_type_id=typu.trasl_type_id*/
 
 
 SELECT usr.name_complete,ttyp.trasl_type_descripcion,prf.prfle_description 
 FROM   user_login usr
 INNER JOIN trasl_type_user_login_saved typu  on usr.usr_id = typu.usr_id
 INNER JOIN traslation_type ttyp on  typu.trasl_type_id = ttyp.trasl_type_id 
 INNER JOIN profile prf ON usr.prfle_id=prf.prfle_id
 WHERE usr.usr_id=(SELECT usr_id FROM user_login WHERE usr_id_sgp=2057 );
 
 
 
 
 SELECT * FROM traslation_head WHERE trasl_type_id in (SELECT ttyp.trasl_type_id FROM  user_login usr
 INNER JOIN trasl_type_user_login_saved typu  on usr.usr_id = typu.usr_id
 INNER JOIN traslation_type ttyp on  typu.trasl_type_id = ttyp.trasl_type_id 
 INNER JOIN profile prf ON usr.prfle_id=prf.prfle_id
 WHERE usr.usr_id=52)
  

 
 