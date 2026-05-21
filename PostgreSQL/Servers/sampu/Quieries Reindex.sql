SELECT *FROM information_schema.tables where table_catalog='sgp' and table_schema='public' and table_type='BASE TABLE';


/*SELECT *FROM pg_indexes where schemaname not like 'pg_%' and schemaname='public' and indexname like 'mail_message_model_index';  */
SELECT *FROM pg_indexes where schemaname not like 'pg_%' and schemaname='public' and indexname like 'mail_message_author_id_index';  

REINDEX INDEX mail_message_author_id_index;
COMMIT;
///////////////////////////////////////////////////////////
SELECT *FROM prison_person    where  identificador ='1727550228' --LIMIT 1
--select *from  pg_toast.pg_toast_16444;
select *from  pg_toast.pg_toast_885039 limit 100;
REINDEX table pg_toast.pg_toast_885039;

REINDEX table prison_person;





REINDEX table pg_toast.pg_toast_885039;
VACUUM full  pg_toast.pg_toast_885039;

select pg_toast_885039::regclass;

--No le reconoce como tabla. COn este select le estuy preguntando el tipo de objeto de base que es.
--y talvez le podemos buscar que es??  --- porque esto me bota ya en el sistema
InternalError: missing chunk number 0 for toast value 2157768 in pg_toast_885039

--Las tablas pg_toast son la sidentificaciones internas de la base de datos
--Con el select que estoy poniendo  le estoy preguntando qué tabla es el código de toast que me está indicando.ALTER--Pero no le reconoce. 
--¿Estamos seguros que es la misma base? ¿Podemos acceder por comandos? ¿con qué esquema está la base?
--en realidad nose pero la vez anterior usted hizo una consulta para ver el esquema ??? no se si esa fue la pregunta?
--¿No ejecuta ninguna consulta desde aquí?
--Puede ser rl tipo de usuario.
--Las tablas toast la spuede ver el db0 de la BDD. Por lo que con ese perfil deben correrle el select que le puse abajo


select pg_toast.pg_toast_885039::regclass;

--Esto debe producir algo como:

--regclass
  --------
--Pais

--Con el nombre de la tabla se puede correr el REINDEX a la tabla que presenta fallas.
--Al tener error en pg_toast es una corrupción de datos a nivel de relacion
--https://wiki.postgresql.org/wiki/Corruption

/*


REINDEX table pg_toast.pg_toast_885039;
REINDEX table prison_person;
*/

select reltoastrelid::regclass from pg_class where relname = 'prison_person';
SELECT oid FROM pg_class WHERE relname = 'prison_person'


select reltablespace, relkind, relname,
          pg_relation_size(oid), reltoastrelid::regclass::text
   from pg_class  where relname = 'pg_toast_885039'

SELECT schema_name,
       pg_size_pretty( SUM(table_size) ::BIGINT), (SUM(table_size) / pg_database_size(current_database())) * 100
  FROM ( SELECT   pg_catalog.pg_namespace.nspname AS schema_name,
                  pg_relation_size(pg_catalog.pg_class.oid) AS table_size
           FROM   pg_catalog.pg_class
           JOIN   pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
) t
 
GROUP BY schema_name
ORDER BY schema_name;


SELECT pg_catalog.pg_relation_filenode(c.oid) as "Object ID", relname as "Object Name",
case WHEN relkind='r' THEN 'Table'
     when relkind='m' THEN 'Materialized View'
     when relkind='i' THEN 'Index'
     when relkind='S' THEN 'Sequence'
     when relkind='t' THEN 'Toast'
     when relkind='v' THEN 'View'
     when relkind='c' THEN 'Composite'
     when relkind='f' THEN 'Foreign_Table'
     ELSE 'other'
    end
     as "Object Type", o.rolname as "Owner"
FROM pg_catalog.pg_class c
        LEFT JOIN pg_catalog.pg_authid o ON o.oid=c.relowner
        LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
        LEFT JOIN pg_catalog.pg_database d ON d.datname = pg_catalog.current_database(),
        pg_catalog.pg_tablespace t
WHERE
   relname like '%toast%' and o.rolname = 'sgp' and
  t.oid = CASE
          WHEN reltablespace <;> 0 THEN reltablespace
          ELSE dattablespace
          END;

SELECT pgn.nspname, relname, pg_size_pretty(relpages::bigint * 8 * 1024) AS size, 
     CASE WHEN relkind = 't' 
     THEN (SELECT pgd.relname FROM pg_class pgd WHERE pgd.reltoastrelid = pg.oid) 
     WHEN nspname = 'pg_toast' AND relkind = 'i' 
     THEN (SELECT pgt.relname FROM pg_class pgt WHERE SUBSTRING(pgt.relname FROM 10) = REPLACE(SUBSTRING(pg.relname FROM 10), '_index', '')) 
     ELSE (SELECT pgc.relname FROM pg_class pgc WHERE pg.reltoastrelid = pgc.oid) END::varchar AS refrelname, relpages FROM pg_class pg, pg_namespace pgn WHERE pg.relnamespace = pgn.oid AND pgn.nspname NOT IN ('information_schema', 'pg_catalog') and pgn.nspname = 'sgp' ORDER BY relpages DESC;


---------------------------------------------------------------------

SELECT * from prison_person LIMIT 1 
------------------------------------------------------------


select t1.oid, t1.relname, t1.relkind, t2.relkind, t2.relpages, t2.reltuples
from pg_class t1
inner join pg_class t2
on t1.reltoastrelid = t2.oid
where t1.relkind = 'r'
  and t2.relkind = 't';


select table_catalog, table_schema, table_name, 
       pg_total_relation_size(table_catalog || '.' || table_schema|| '.' || table_name) as pg_total_relation_size,
       pg_relation_size(table_catalog || '.' || table_schema|| '.' || table_name) as pg_relation_size,
       pg_table_size(table_catalog || '.' || table_schema|| '.' || table_name) as pg_table_size
from information_schema.tables



select *from information_schema.tables where TABLE_NAME='prison_person'
 
-----------------------------------------------------------------------


select reltoastrelid::regclass from pg_class where relname ='prison_person'


