SELECT D.*
FROM departamento D
WHERE EXISTS (
	SELECT M.*
	FROM variable V 
	INNER JOIN medicion M ON (M.id_departamento = D.id_departamento AND V.id_variable = M.id_variable)
	WHERE (
		(M.fecha >= '2010-05-01'::date AND M.fecha < '2010-06-01'::date) AND
		(M.valor > 90) AND
		(V.nombre = 'datos')
	)
	LIMIT 1
);