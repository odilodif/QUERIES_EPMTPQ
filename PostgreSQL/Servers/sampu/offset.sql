SELECT * FROM   prison_person ORDER BY id asc LIMIT 2;
select * from prison_person order by  id limit 1 offset 	1;

1
SELECT   * FROM     prison_person ORDER BY    id  OFFSET 1 ROWS  FETCH NEXT 10 ROWS ONLY;



select * 	from prison_person order by id limit 1 offset 7604;
select id from prison_person order by id limit 1 offset 7605;


select id from prison_person where id = 64961


--select * from prison_detention  WHERE person_id = 64961;
select * from prison_detention  WHERE person_id = 237401;

select identificador from prison_person  WHERE id = 64961;

select id from prison_person  WHERE identificador='1727550228'

UPDATE prison_person set
 image_medium=null,
image_small=NULL,
image0=null,
image1=NULL,
image2=NULL
WHERE id=237401




select id from prison_person  WHERE identificador='1727550228'
select * from prison_person  WHERE identificador='1727550228';


--delete from prison_person where id = 64961;


SELECT
 COLUMN_NAME
FROM
 information_schema.COLUMNS
WHERE
 TABLE_NAME = 'prison_person';
