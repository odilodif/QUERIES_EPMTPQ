-- 1. Corregir motorizado a Integer
ALTER TABLE estaciones_config 
ALTER COLUMN eliminada  TYPE INTEGER 
USING (eliminada ::integer);