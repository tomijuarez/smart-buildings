SELECT id_variable, SUM(valor) as "consumo"
FROM medicion
GROUP BY id_variable;
