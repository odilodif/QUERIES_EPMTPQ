SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND column_name ILIKE '%denominacion_prpac%';
