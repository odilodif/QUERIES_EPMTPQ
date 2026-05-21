select	p.id,
		p.nombre,
		sum(r.puntos) as total
	from pilotos p inner 
	join resultados r on
	p.id = r.piloto_id
	group by p.id, p.nombre
	order by total desc;

select	p.id,
		p.nombre,
		sum(r.puntos) over () as total
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;

select	p.id,
		p.nombre,
		sum(r.puntos) over (partition by p.id) as total
	from pilotos p inner join resultados r on
			p.id = r.piloto_id
	order by total desc;

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total
	from pilotos p inner join resultados r on
			p.id = r.piloto_id
	order by total desc, r.puntos desc;

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total,
		row_number() over (order by p.id) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total,
		row_number() over (order by r.puntos desc) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id
	order by total desc;

select	p.id,
		p.nombre,
		r.puntos,
		sum(r.puntos) over (partition by p.id) as total,
		row_number() over (partition by p.id order by r.puntos desc) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;
		
select	p.id,
		p.nombre,
		r.puntos,
		row_number() over (partition by p.id order by r.puntos desc) as ranking
	from pilotos p inner join resultados r on
			p.id = r.piloto_id;
		
select 	id,
		nombre,
		sum(puntos) as total
	from	(
	select	p.id,
			p.nombre,
			r.puntos,
			row_number() over (partition by p.id order by r.puntos desc) as ranking
		from pilotos p inner join resultados r on
				p.id = r.piloto_id
			) as subconsulta
	where ranking <= 4
	group by id, nombre
	order by total desc;