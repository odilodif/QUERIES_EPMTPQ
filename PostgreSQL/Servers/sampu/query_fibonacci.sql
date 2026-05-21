WITH fibonacci_cte (number, val, previousnumber)
AS
(
SELECT 1 AS number, 0 as val, 1 as previousnumber

UNION ALL

-- N, V, P
-- 1, 0, 1
-- 2, 1, 1
-- 3, 1, 2
-- 4, 2, 3
-- 5, 3, 5
SELECT (number + 1) as number, previousnumber as val, (val + previousnumber) as previousnumber FROM fibonacci_cte WHERE number < 10
)
SELECT number, val, previousnumber FROM fibonacci_cte; 