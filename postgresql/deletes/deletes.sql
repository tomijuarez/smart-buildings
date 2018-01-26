--El sistema se encuentra en etapa de migración pero los los desarrolladores decidieron copiar la información de las mediciones desde 2010 en adelante y conservar la información previa a ese año. Como los datos posteriores al 2010 ya se salvaron en otra base de datos, es necesario eliminarlos.
DELETE FROM medicion
WHERE (fecha >= '2010-01-01'::date);

--Se desea eliminar toda la información de las mediciones efectivas relativas a los departamentos en el rango 5.000 a 16.000.
DELETE FROM medicion
WHERE id_departamento BETWEEN 5000 AND 16000;