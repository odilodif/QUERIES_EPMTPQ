/*DROP VIEW query_report_adrian
CREATE VIEW query_report_adrian AS*/
select prontuario ,pl.id as idx /*,centro_sgp_pv,centro_std_new,centro_std_tot,centro_sgp_nb,centro_std_grp*/
  from prison_person pp
  LEFT join prison_location pl on pl.id = pp.center_id
  LEFT JOIN prison_detention pd on pd.person_id=pp.id
  LEFT JOIN repo_centro r on centro_sgp_id=pl.id
  where pp.state <> 'free'  and pd.state <> 'free'  and pl.id=4248 ORDER BY prontuario; -- and tipo=1
  /*group by pl.id, centro_sgp_pv,centro_std_new,centro_std_tot,centro_sgp_nb,centro_std_grp
   order by centro_std_grp*/
	 
	 
	 
	 SELECT count(centro_sgp_id) as cntr, centro_sgp_nb FROM repo_centro GROUP BY centro_sgp_nb, centro_sgp_nb HAVING count(centro_sgp_id) > 1
	 
	 
	 SELECT  * from prison_location where id=55960
	 
	 SELECT min(id) as idpp, count(state) as count,state, center_id
        FROM prison_person WHERE center_id= 4248
        GROUP BY  state,center_id
        ORDER BY count
				
	
        SELECT min(id) as id, state, count(sex) AS count, sex, center_id 
        FROM prison_person 
        GROUP BY sex, center_id, state 
        ORDER BY count			
				
	 
	 
	 select count(prontuario) , prontuario 
  from prison_person pp
  LEFT join prison_location pl on pl.id = pp.center_id
  LEFT JOIN prison_detention pd on pd.person_id=pp.id
  LEFT JOIN repo_centro r on centro_sgp_id=pl.id
  where pp.state <> 'free'  and pd.state <> 'free'  and pl.id=4248 
	GROUP BY prontuario HAVING  count(prontuario) >1
	
	 