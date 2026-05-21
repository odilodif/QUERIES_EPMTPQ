select pp.id,pl.name as centro, pp.name as nombres, pp.last_name as apellidos, pp.prontuario as prontuario ,upper(pp.tipo_identificador) as tipoDocumento, pp.identificador as identificador,
        upper(pp.sex) as sexo, re.name as etnia, upper(rc.name) as pais, pp."Nacionalidad" as nacionalidad, pp.birth_date as f_nacimiento, rec.name as e_civil,
        rel.name as instruccion,upper(pp.state) as situacionActual
        from prison_person pp
        left join prison_location pl on pl.id = pp.center_id
        left join res_etnia re on re.id = pp.etnia_id
        left join res_country rc on rc.id = pp.country_id
        left join res_civil_status rec on rec.id = pp.civil_state
        left join res_education_level rel on rel.id = pp.level_of_education
        where pp.state <> 'free' and pp.center_id=4281