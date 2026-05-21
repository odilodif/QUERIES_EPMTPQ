SELECT  * from prison_crime WHERE id in(1984,3775);
SELECT * from res_users WHERE id in(1660,1900);




select code, name from prison_judged ;

SELECT * from res_users limit 1;



SELECT par.name as nombres,u.login as usuario,u.login_date as ultima_fecha_sesión, rg.name as permisos, pl."name" from res_users  u
INNER JOIN res_groups_users_rel gu on  u."id" = gu.uid
INNER JOIN res_groups rg ON gu.gid= rg.id 
INNER JOIN res_partner par ON u.partner_id =par."id" 
INNER JOIN prison_location pl ON u.center_id = pl.id
WHERE  pl.id IN (4282) AND u.active='t' AND u.login_date >'2023-01-01'::date order by 3 DESC



SELECT par.name as nombres,u.login as usuario,u.login_date as ultima_fecha_sesión, rg.name as permisos, pl."name" from res_users  u
INNER JOIN res_groups_users_rel gu on  u."id" = gu.uid
INNER JOIN res_groups rg ON gu.gid= rg.id 
INNER JOIN res_partner par ON u.partner_id =par."id" 
INNER JOIN prison_location pl ON u.center_id = pl.id
WHERE pl.id IN (4282,10875) AND u.active='t';

