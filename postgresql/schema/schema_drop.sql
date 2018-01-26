-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-06-28 22:42:35.627

-- foreign keys
ALTER TABLE departamento
    DROP CONSTRAINT departamento_edificio;

ALTER TABLE edificio
    DROP CONSTRAINT edificio_Constructora;

ALTER TABLE medicion_departamento
    DROP CONSTRAINT medicion_departamento_departamento;

ALTER TABLE medicion_departamento
    DROP CONSTRAINT medicion_departamento_variable;

ALTER TABLE medicion
    DROP CONSTRAINT medicion_medicion_departamento;

-- tables
DROP TABLE constructora;

DROP TABLE departamento;

DROP TABLE edificio;

DROP TABLE medicion;

DROP TABLE medicion_departamento;

DROP TABLE variable;

-- End of file.

