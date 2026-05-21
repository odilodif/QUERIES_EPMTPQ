SELECT min(id) as id, state, count(sex) AS count, sex, center_id 
        FROM prison_person 
				WHERE center_id = 	4281	
        GROUP BY sex, center_id, state 
        ORDER BY count
        
				
				
