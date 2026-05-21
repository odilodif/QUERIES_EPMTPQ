SELECT u.id, u.login,par."name",l.name from res_users  u
INNER JOIN prison_location l  on u.center_id=l."id"
INNER JOIN res_partner par on   u.partner_id =par."id"
 WHERE l.id=4239 AND u.active= 't' ORDER BY 1 DESC;

--SELECT * from prison_location LIMIT 1