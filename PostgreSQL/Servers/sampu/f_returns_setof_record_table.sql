CREATE TABLE emp (
    name        text,
    salary      numeric,
    age         integer,
    cubicle     point
);

INSERT INTO emp VALUES ('Bill', 4200, 45, '(2,1)');


CREATE FUNCTION new_emp() RETURNS emp AS $$
    SELECT text 'None' AS name,
        1000.0 AS salary,
        25 AS age,
        point '(2,2)' AS cubicle;
$$ LANGUAGE SQL;


SELECT new_emp();

/*******************************************************************************************/

CREATE TABLE tab (y int, z int);
INSERT INTO tab VALUES (1, 2), (3, 4), (5, 6), (7, 8);

CREATE FUNCTION sum_n_product_with_tab (x int, OUT sumas int, OUT multiplicacion int)
RETURNS SETOF record
AS $$
    SELECT $1 + tab.y, $1 * tab.y FROM tab;
$$ LANGUAGE SQL;

SELECT * FROM sum_n_product_with_tab(10);





--DROP FUNCTION sum_n_product_with_tab(INT);
CREATE FUNCTION sum_n_product_with_tab ( x int, OUT porcent_cumplido FLOAT,	OUT dias_a_la_fecha INT, OUT total_dias_judiciales_impuestos INT,	OUT prontuario VARCHAR,	OUT name_ppl VARCHAR,	OUT last_name_ppl VARCHAR, OUT 	numero_detencion VARCHAR, OUT	nombre_crs VARCHAR,	OUT fecha_in DATE)
RETURNS SETOF record
AS $$
		
    SELECT  *	FROM porcentaje_cumplido;
		
		
$$ LANGUAGE SQL;


SELECT  * FROM sum_n_product_with_tab(10);

