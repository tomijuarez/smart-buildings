SELECT D.*
FROM departamento D
INNER JOIN variable V ON(v.nombre = 'datos')
INNER JOIN medicion_departamento M ON (D.id_departamento = M.id_departamento AND V.id_variable = M.id_variable)
INNER JOIN medicion X ON (X.id_departamento = M.id_departamento AND X.id_variable = M.id_variable)
WHERE (
	(X.valor > 90) AND
	(X.fecha >= '2010-05-01'::date AND X.fecha < '2010-06-01'::date)
);