SELECT u.login,par."name"  FROM res_users u
INNER JOIN res_partner par on   u.partner_id =par."id"
where u.active = 't' AND u."id"=1458;

SELECT par."name"  FROM res_users u INNER JOIN res_partner par on  u.partner_id =par."id" where  u."id"=335;