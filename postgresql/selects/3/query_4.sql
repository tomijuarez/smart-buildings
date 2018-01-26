SELECT SUM(M.valor) 
FROM departamento D
INNER JOIN variable V ON (V.nombre = 'electricidad')
INNER JOIN medicion_departamento X ON (X.id_variable = V.id_variable AND X.id_departamento = D.id_departamento)
INNER JOIN edificio E ON (E.id_edificio = D.id_edificio)
INNER JOIN medicion M ON (M.id_variable = V.id_variable AND M.id_departamento = X.id_departamento)
WHERE (E.pais = 'United States');