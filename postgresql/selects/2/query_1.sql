SELECT DISTINCT id_departamento
FROM medicion 
WHERE EXTRACT(year FROM fecha) = 2010
ORDER BY id_departamento;