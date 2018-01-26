SELECT id_variable, AVG(valor) as "promedio", MIN(valor) as "mínimo", MAX(valor) as "máximo"
FROM medicion
GROUP BY id_variable;