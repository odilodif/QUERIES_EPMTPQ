DO $f$
DECLARE
    baddata TEXT;
    badid INT;
BEGIN
			FOR badid IN SELECT id FROM prison_person LOOP
					BEGIN
							SELECT image0
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