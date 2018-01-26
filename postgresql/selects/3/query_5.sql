SELECT M.id_departamento, SUM(M.valor - V.valmax)
FROM variable V
INNER JOIN medicion M ON (M.id_variable = V.id_variable)
WHERE (
	(M.valor > V.valmax) AND
	(M.fecha >= '2014-01-01'::date AND M.fecha < '2017-01-01'::date) AND
	(V.nombre = 'gas')
)
GROUP BY M.id_departamento;