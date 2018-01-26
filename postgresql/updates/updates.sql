--El equipo de inspección verificó las instalaciones en los edificios logrando identificar errores en los sensores de electricidad, los cuales medían 10W más del escenario real. Se desea modificar todos los registros de medición de electricidad restando 10W en cada caso.

UPDATE medicion
SET valor = valor - 10
WHERE id_variable = (
	SELECT V.id_variable
	FROM variable V
	WHERE V.nombre = 'electricidad'
	LIMIT 1
);

--Se realizó un cambio de equipos de sensores de humo, humedad e iluminación, los cuales registraban valores erróneos en el departamento con identificador 26. La compañía decidió que estos valores no son útiles para el análisis de información, con lo cual decidió anularlos.
UPDATE medicion
SET valor = 0
WHERE (
	(id_departamento = 26) AND
	(id_variable IN 
		(SELECT V.id_variable
		FROM variable V
		WHERE V.nombre IN ('humo', 'humedad', 'iluminacion')
		)
	)
);