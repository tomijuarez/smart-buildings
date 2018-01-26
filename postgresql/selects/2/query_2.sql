SELECT DISTINCT id_departamento
FROM medicion 
WHERE (fecha >= '2010-01-01'::date AND fecha < '2011-01-01'::date)
ORDER BY id_departamento;