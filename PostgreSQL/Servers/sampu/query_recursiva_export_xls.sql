/*********1.- PASO ***********************/
-- 1. Agregamos la columna a la tabla de estructura jerárquica
ALTER TABLE public.tree_funcion_programa 
ADD COLUMN IF NOT EXISTS codigo_pry_prd_prfup VARCHAR(100); 

-- 2. Agregamos la columna a la tabla de reporte final para que el dato fluya hasta el final
ALTER TABLE public.report_function_program 
ADD COLUMN IF NOT EXISTS codigo_pry_prd_prfup VARCHAR(100);

/***********2 PASO*******************/

CREATE OR REPLACE PROCEDURE "public"."p_report_function_program"()
 AS $BODY$
begin
    delete from tree_funcion_programa;
    delete from report_function_program;

    -- INSERT usando el CTE recursivo
INSERT INTO public.tree_funcion_programa (ide_prfup, tree_view, codigo, nivel, depth, path, codigo_pry_prd_prfup)
WITH RECURSIVE tree AS (
  -- raíces
  SELECT
    pfp.ide_prfup,
    pfp.detalle_prfup AS detalle,
    pfp.codigo_prfup AS codigo_prfup,
    pnfp.detalle_prnfp AS nivel,
    1 AS depth,
    pfp.ide_prfup::text AS path
		,pfp.codigo_pry_prd_prfup as _codigo_pry_prd_prfup
  FROM pre_funcion_programa pfp
  LEFT JOIN pre_nivel_funcion_programa pnfp ON pfp.ide_prnfp = pnfp.ide_prnfp
  WHERE pfp.pre_ide_prfup IS NULL OR pfp.pre_ide_prfup = 0

  UNION ALL

  SELECT
    c.ide_prfup,
    c.detalle_prfup,
    c.codigo_prfup,
    d.detalle_prnfp,
    p.depth + 1,
    p.path || '/' || c.ide_prfup::text
		,c.codigo_pry_prd_prfup
  FROM pre_funcion_programa c
  JOIN tree p ON c.pre_ide_prfup = p.ide_prfup
  LEFT JOIN pre_nivel_funcion_programa d ON c.ide_prnfp = d.ide_prnfp
  WHERE p.path NOT LIKE '%' || c.ide_prfup::text || '%'  -- evita ciclos
    AND p.depth < 100
)
SELECT
  ide_prfup,
  repeat('    ', depth - 1) || detalle AS tree_view,
  codigo_prfup AS codigo,
  nivel,
  depth,
  path,
	_codigo_pry_prd_prfup
FROM tree
ORDER BY path;

    insert into report_function_program(ide_covig, ide_geani, ide_prfup) 
		select ide_covig, ide_geani, ide_prfup from cont_vigente where ide_prfup is not null;

		
UPDATE report_function_program rep
SET tree_view = tree.tree_view,
    codigo= tree.codigo,
    nivel= tree.nivel,
    depth= tree.depth,
    path= tree.path,
		codigo_pry_prd_prfup = tree.codigo_pry_prd_prfup
FROM (
  SELECT ide_prfup, tree_view,codigo,nivel,depth,path,codigo_pry_prd_prfup
    FROM tree_funcion_programa
) tree
WHERE rep.ide_prfup = tree.ide_prfup;



UPDATE report_function_program t
SET anio=r.detalle_geani
FROM (
  SELECT ide_geani, detalle_geani
    FROM gen_anio
) r
WHERE t.ide_geani = r.ide_geani;


end;
$BODY$
  LANGUAGE plpgsql

/*************PASO 3**************************/
	CREATE INDEX idx_tree_fup_proyecto ON public.tree_funcion_programa(codigo_pry_prd_prfup);
/**************PASO 4**********************/
	
		call p_report_function_program();
		
		
		
		/***********************************/
		
SELECT *  FROM pre_funcion_programa WHERE codigo_pry_prd_prfup IS NOT NULL;
SELECT *  FROM report_function_program WHERE ide_prfup = 4;
SELECT *  FROM pre_funcion_programa ;



/***************************/


/************************************/
select  anio,tree_view as funcion_programa,codigo as codigo_funcion_programa,nivel as tipo,depth as nivel,path,codigo_pry_prd_prfup 
from report_function_program where ide_geani in(10) order by ide_geani, path;



/*****************************************************/
/*****************************************************************************/
/*********************************************************************************/
/*********************************************************************************/


-- DROP PROCEDURE "public"."p_report_function_program"() 
CREATE OR REPLACE PROCEDURE "public"."p_report_function_program"()
language plpgsql
as
$$
begin
    delete from tree_funcion_programa;
    delete from report_function_program;

    -- INSERT usando el CTE recursivo
INSERT INTO public.tree_funcion_programa (ide_prfup, tree_view, codigo, nivel, depth, path)
WITH RECURSIVE tree AS (
  -- raíces
  SELECT
    pfp.ide_prfup,
    pfp.detalle_prfup AS detalle,
    pfp.codigo_prfup AS codigo_prfup,
    pnfp.detalle_prnfp AS nivel,
    1 AS depth,
    pfp.ide_prfup::text AS path
  FROM pre_funcion_programa pfp
  LEFT JOIN pre_nivel_funcion_programa pnfp ON pfp.ide_prnfp = pnfp.ide_prnfp
  WHERE pfp.pre_ide_prfup IS NULL OR pfp.pre_ide_prfup = 0

  UNION ALL

  SELECT
    c.ide_prfup,
    c.detalle_prfup,
    c.codigo_prfup,
    d.detalle_prnfp,
    p.depth + 1,
    p.path || '/' || c.ide_prfup::text
  FROM pre_funcion_programa c
  JOIN tree p ON c.pre_ide_prfup = p.ide_prfup
  LEFT JOIN pre_nivel_funcion_programa d ON c.ide_prnfp = d.ide_prnfp
  WHERE p.path NOT LIKE '%' || c.ide_prfup::text || '%'  -- evita ciclos
    AND p.depth < 100
)
SELECT
  ide_prfup,
  repeat('    ', depth - 1) || detalle AS tree_view,
  codigo_prfup AS codigo,
  nivel,
  depth,
  path
FROM tree
ORDER BY path;

    insert into report_function_program(ide_covig, ide_geani, ide_prfup) select ide_covig, ide_geani, ide_prfup from cont_vigente where ide_prfup is not null;


UPDATE report_function_program t
SET tree_view = r.tree_view,
    codigo= r.codigo,
    nivel= r.nivel,
    depth= r.depth,
    path= r.path
FROM (
  SELECT ide_prfup, tree_view,codigo,nivel,depth,path
    FROM tree_funcion_programa
) r
WHERE t.ide_prfup = r.ide_prfup;

    UPDATE report_function_program t
SET codigo_pry_prd_prfup = r.codigo_pry_prd_prfup
FROM (
  SELECT ide_prfup, codigo_pry_prd_prfup
    FROM pre_funcion_programa
) r
WHERE t.ide_prfup = r.ide_prfup;
UPDATE report_function_program t
SET anio=r.detalle_geani

FROM (
  SELECT ide_geani, detalle_geani
    FROM gen_anio
) r
WHERE t.ide_geani = r.ide_geani;

end;
$$;


/******************************************/
SELECT count(ide_prfup), ide_prfup FROM tree_funcion_programa GROUP BY  ide_prfup  HAVING count(ide_prfup) > 1;

SELECT * FROM report_function_program WHERE codigo = '02' and ide_geani = 10 and ide_prfup = 3 and   ide_covig = 15566;   --15566   				----2026

SELECT *  FROM  report_function_program  WHERE  ide_covig = 15566;


SELECT *  FROM tree_funcion_programa WHERE ide_prfup = 3;

SELECT * FROM pre_funcion_programa WHERE ide_prfup = 3;

SELECT * FROM cont_vigente WHERE ide_prfup = 3;


