DO $f$
DECLARE
    baddata TEXT;
    badid INT;
BEGIN
FOR badid IN SELECT id FROM prison_person LOOP
    BEGIN
        SELECT image_small
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

--id 237393


UPDATE prison_person SET 
image_medium =NULL, 
image2=NULL,
image1=NULL,
image0=NULL,
image_small=null
 WHERE id=237431;
 
 

