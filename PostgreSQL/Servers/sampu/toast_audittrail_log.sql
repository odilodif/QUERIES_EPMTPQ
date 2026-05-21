select count(*) from audittrail_log_line;
select * from audittrail_log_line order by id limit 500000 offset 6500000;
select * from audittrail_log_line LIMIT 1;
DO $f$
DECLARE
    baddata TEXT;
    badid INT;
BEGIN
FOR badid IN SELECT id FROM prison_person LOOP
    BEGIN
        SELECT new_value_text
        INTO baddata
        FROM prison_person where id = badid;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Data for ID % is corrupt', badid;
            CONTINUE;
    END;
END LOOP;
END;
$f$

/* audittrail_log_line  */

DO $f$
DECLARE
    baddata TEXT;
    badid INT;
BEGIN
FOR badid IN SELECT id FROM prison_person LOOP
    BEGIN
        SELECT new_value_text
        INTO baddata
        FROM prison_person where id = badid;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Data for ID % is corrupt', badid;
            CONTINUE;
    END;
END LOOP;
END;
$f$
