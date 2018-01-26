-----------------------------------------------------------
-- 1. CONSULTAS CON FUNCIONES DE AGREGACIÓN Y AGRUPAMIENTO
-----------------------------------------------------------

--a. Obtener el total de consumo registrado de cada variable.
SELECT id_variable, SUM(valor) as "consumo"
FROM medicion
GROUP BY id_variable;

--b. Obtener la cantidad de edificios en donde sus departamentos registrados sumen más de 80000 metros cuadrados.
SELECT COUNT(*) FROM (
	SELECT 1 FROM departamento
	GROUP BY id_edificio
	HAVING SUM(metros) > 80000
) edificios_filtrados;

--c. Obtener el promedio de cada variable y los máximos y mínimos registrados para cada una de ellas y ordenarla en orden decreciente según su consumo medio.
SELECT id_variable, AVG(valor) as "promedio", MIN(valor) as "mínimo", MAX(valor) as "máximo"
FROM medicion
GROUP BY id_variable;

------------------------------
-- 2. CONSULTAS CON DISTINCT
------------------------------

--a. Seleccionar todos los departamentos que registren mediciones en el año 2010 sin repeticiones.
SELECT DISTINCT id_departamento
FROM medicion 
WHERE EXTRACT(year FROM fecha) = 2010
ORDER BY id_departamento;

/*
"Sort  (cost=171068.57..171069.20 rows=252 width=4) (actual time=5304.352..5312.734 rows=50000 loops=1)"
"  Sort Key: id_departamento"
"  Sort Method: quicksort  Memory: 3710kB"
"  ->  HashAggregate  (cost=171056.00..171058.52 rows=252 width=4) (actual time=5262.965..5281.110 rows=50000 loops=1)"
"        Group Key: id_departamento"
"        ->  Seq Scan on medicion  (cost=0.00..170956.00 rows=40000 width=4) (actual time=142.303..5010.213 rows=584309 loops=1)"
"              Filter: (date_part('year'::text, fecha) = '2010'::double precision)"
"              Rows Removed by Filter: 7415691"
"Planning time: 0.186 ms"
"Execution time: 5315.709 ms"

*/


SELECT DISTINCT id_departamento
FROM medicion 
WHERE (fecha >= '2010-01-01'::date AND fecha < '2011-01-01'::date)
ORDER BY id_departamento;

/*
"  ->  HashAggregate  (cost=171056.49..171059.01 rows=252 width=4) (actual time=6591.657..6611.755 rows=50000 loops=1)"
"        Group Key: id_departamento"
"        ->  Seq Scan on medicion  (cost=0.00..170956.49 rows=40000 width=4) (actual time=178.322..6313.164 rows=584309 loops=1)"
"              Filter: (date_part('year'::text, fecha) = '2010'::double precision)"
"              Rows Removed by Filter: 7415691"
"Planning time: 105.379 ms"
"Execution time: 6649.192 ms"

*/

CREATE INDEX ix_fecha_medicion ON medicion(fecha);
/*
"Sort  (cost=74509.92..74519.38 rows=3783 width=4) (actual time=576.165..584.867 rows=50000 loops=1)"
"  Sort Key: id_departamento"
"  Sort Method: quicksort  Memory: 3710kB"
"  ->  HashAggregate  (cost=74247.28..74285.11 rows=3783 width=4) (actual time=533.957..552.842 rows=50000 loops=1)"
"        Group Key: id_departamento"
"        ->  Bitmap Heap Scan on medicion  (cost=12765.52..72743.60 rows=601472 width=4) (actual time=112.972..265.420 rows=584309 loops=1)"
"              Recheck Cond: ((fecha >= '2010-01-01'::date) AND (fecha < '2011-01-01'::date))"
"              Heap Blocks: exact=5104"
"              ->  Bitmap Index Scan on ix_fecha_medicion  (cost=0.00..12615.15 rows=601472 width=0) (actual time=111.511..111.511 rows=584309 loops=1)"
"                    Index Cond: ((fecha >= '2010-01-01'::date) AND (fecha < '2011-01-01'::date))"
"Planning time: 0.208 ms"
"Execution time: 587.990 ms"
*/

--b. Seleccionar sin repeticiones los años y meses en donde se registren mediciones.
SELECT DISTINCT EXTRACT(year FROM fecha), EXTRACT(month FROM fecha)
FROM medicion;

------------------------------------
-- 3. CONSULTAS EN MÁS DE UNA TABLA
------------------------------------

--a. Seleccionar los departamentos que registren al menos una medición de datos superiores a 90GB en el mes de mayo de 2010.
--Opción 1
SELECT D.*
FROM departamento D
INNER JOIN variable V ON(v.nombre = 'datos')
INNER JOIN medicion_departamento M ON (D.id_departamento = M.id_departamento AND V.id_variable = M.id_variable)
INNER JOIN medicion X ON (X.id_departamento = M.id_departamento AND X.id_variable = M.id_variable)
WHERE (
	(X.valor > 90) AND
	(EXTRACT(year FROM fecha) = 2010) AND
	(EXTRACT(month FROM fecha) = 5)
);

/*
"Nested Loop  (cost=1.15..47498.72 rows=17 width=18) (actual time=472.245..596.296 rows=440 loops=1)"
"  ->  Nested Loop  (cost=0.85..47493.25 rows=17 width=8) (actual time=472.233..594.171 rows=440 loops=1)"
"        Join Filter: (v.id_variable = m.id_variable)"
"        ->  Nested Loop  (cost=0.43..47346.71 rows=18 width=12) (actual time=472.177..591.172 rows=440 loops=1)"
"              ->  Seq Scan on variable v  (cost=0.00..1.10 rows=1 width=4) (actual time=0.012..0.014 rows=1 loops=1)"
"                    Filter: ((nombre)::text = 'datos'::text)"
"                    Rows Removed by Filter: 7"
"              ->  Index Scan using maiame on medicion x  (cost=0.43..47345.43 rows=18 width=8) (actual time=472.159..591.025 rows=440 loops=1)"
"                    Index Cond: (id_variable = v.id_variable)"
"                    Filter: ((valor > '90'::numeric) AND (date_part('year'::text, fecha) = '2010'::double precision) AND (date_part('month'::text, fecha) = '5'::double precision))"
"                    Rows Removed by Filter: 999560"
"        ->  Index Only Scan using medicion_departamento_pk on medicion_departamento m  (cost=0.42..8.13 rows=1 width=8) (actual time=0.005..0.006 rows=1 loops=440)"
"              Index Cond: ((id_variable = x.id_variable) AND (id_departamento = x.id_departamento))"
"              Heap Fetches: 440"
"  ->  Index Scan using departamento_pk on departamento d  (cost=0.29..0.31 rows=1 width=18) (actual time=0.004..0.004 rows=1 loops=440)"
"        Index Cond: (id_departamento = m.id_departamento)"
"Planning time: 2.295 ms"
"Execution time: 596.435 ms"
*/

CREATE INDEX ix_valor_medicion ON medicion(valor);

--Opción 2
SELECT D.*
FROM departamento D
INNER JOIN variable V ON(v.nombre = 'datos')
INNER JOIN medicion_departamento M ON (D.id_departamento = M.id_departamento AND V.id_variable = M.id_variable)
INNER JOIN medicion X ON (X.id_departamento = M.id_departamento AND X.id_variable = M.id_variable)
WHERE (
	(X.valor > 90) AND
	(X.fecha >= '2010-05-01'::date AND X.fecha < '2010-06-01'::date)
);


--Opción 3
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

--b. Obtener el consumo total de datos de internet de todos los edificios registrados en estados unidos.
SELECT SUM(M.valor) 
FROM departamento D
INNER JOIN variable V ON (V.nombre = 'electricidad')
INNER JOIN medicion_departamento X ON (X.id_variable = V.id_variable AND X.id_departamento = D.id_departamento)
INNER JOIN edificio E ON (E.id_edificio = D.id_edificio)
INNER JOIN medicion M ON (M.id_variable = V.id_variable AND M.id_departamento = X.id_departamento)
WHERE (E.pais = 'United States');

--c. Obtener la sumatoria de los excedentes de gas en los registros de mediciones de cada departamento desde el año 2014 al 2016 inclusive.
SELECT M.id_departamento, SUM(M.valor - V.valmax)
FROM variable V
INNER JOIN medicion M ON (M.id_variable = V.id_variable)
WHERE (
	(M.valor > V.valmax) AND
	(M.fecha >= '2014-01-01'::date AND M.fecha < '2017-01-01'::date) AND
	(V.nombre = 'gas')
)
GROUP BY M.id_departamento;