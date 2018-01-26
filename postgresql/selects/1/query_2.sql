SELECT COUNT(*) FROM (
	SELECT 1 FROM departamento
	GROUP BY id_edificio
	HAVING SUM(metros) > 80000
) edificios_filtrados;