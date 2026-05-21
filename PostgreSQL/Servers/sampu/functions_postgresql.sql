
CREATE OR REPLACE FUNCTION totalRecords ()
RETURNS integer AS $total$
declare
	total integer;
BEGIN
   SELECT count(*) into total FROM prison_person;
   RETURN total;
END;
$total$ LANGUAGE plpgsql;
	
SELECT totalRecords();

/*************************************************************************************************/

CREATE FUNCTION inc(val integer) RETURNS integer AS $$
BEGIN
RETURN val + 1;
END; $$
LANGUAGE PLPGSQL;

SELECT inc(2);

/****************************************************************************************************/



CREATE OR REPLACE FUNCTION for_loop_through_query(
   n INTEGER DEFAULT 10
) 
RETURNS VOID AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT id FROM prison_person ORDER BY id LIMIT n  LOOP 
					
     RAISE NOTICE 'Counter: %', ;
		 
    END LOOP;
END;
$$ LANGUAGE plpgsql;

select for_loop_through_query(10)


1
2
3
4
5
6
DO $$
BEGIN
   FOR counter IN 1..5 LOOP
   RAISE NOTICE 'Counter: %', counter;
   END LOOP;
END; $$


/******************************************************************/









2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
CREATE OR REPLACE FUNCTION fibonacci (n INTEGER) 
   RETURNS INTEGER AS $$ 
DECLARE
   counter INTEGER := 0 ; 
   i INTEGER := 0 ; 
   j INTEGER := 1 ;
BEGIN
 
   IF (n < 1) THEN
      RETURN 0 ;
   END IF; 
   
   WHILE counter <= n LOOP
      counter := counter + 1 ; 
      SELECT j, i + j INTO i,   j ;
   END LOOP ; 
   
   RETURN i ;
END ;
$$ LANGUAGE plpgsql;

SELECT fibonacci(10);




CREATE OR REPLACE FUNCTION fibonacci (n INTEGER) 
   RETURNS INTEGER AS $$ 
DECLARE
   counter INTEGER := 0 ; 
   i INTEGER := 0 ; 
   j INTEGER := 1 ;
BEGIN
 
   IF (n < 1) THEN
      RETURN 0 ;
   END IF; 
   
   WHILE counter <= (SELECT count(*) from prison_person LIMIT 1) LOOP
      counter := counter + 1 ; 
     
   END LOOP ; 
   
   RETURN 1 ;
END ;
$$ LANGUAGE plpgsql;

select fibonacci(1)

SELECT * FROM prison_person LIMIT 1
SELECT count(*) from prison_person 
--WHERE prontuario = 'MJDHC-A-00191806' 

--217457


