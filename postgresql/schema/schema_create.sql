-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-06-28 22:42:35.627

-- tables
-- Table: constructora
CREATE TABLE constructora (
    id_constructora serial  NOT NULL,
    nombre_responsable varchar(60)  NOT NULL,
    telefono_responsable varchar(60)  NOT NULL,
    mail_responsable varchar(80)  NOT NULL,
    CONSTRAINT constructora_pk PRIMARY KEY (id_constructora)
);

-- Table: departamento
CREATE TABLE departamento (
    id_departamento serial  NOT NULL,
    nombre_depto char(1)  NOT NULL,
    nro_planta int  NOT NULL,
    id_edificio serial  NOT NULL,
    metros real  NOT NULL,
    CONSTRAINT departamento_ak_1 UNIQUE (nombre_depto, nro_planta, id_departamento) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT departamento_pk PRIMARY KEY (id_departamento)
);

-- Table: edificio
CREATE TABLE edificio (
    id_edificio serial  NOT NULL,
    pais varchar(40)  NOT NULL,
    provincia varchar(40)  NOT NULL,
    ciudad varchar(40)  NOT NULL,
    direccion varchar(60)  NOT NULL,
    id_constructora serial  NOT NULL,
    CONSTRAINT edificio_pk PRIMARY KEY (id_edificio)
);

-- Table: medicion
CREATE TABLE medicion (
    id_variable int  NOT NULL,
    id_departamento int  NOT NULL,
    fecha timestamp  NOT NULL,
    valor decimal(18,3)  NOT NULL,
    CONSTRAINT medicion_pk PRIMARY KEY (id_variable,id_departamento,fecha)
);

-- Table: medicion_departamento
CREATE TABLE medicion_departamento (
    id_variable int  NOT NULL,
    id_departamento serial  NOT NULL,
    intervalo_medicion int  NOT NULL,
    inicio timestamp  NOT NULL,
    fin timestamp  NULL,
    CONSTRAINT medicion_departamento_pk PRIMARY KEY (id_variable,id_departamento)
);

-- Table: variable
CREATE TABLE variable (
    id_variable int  NOT NULL,
    nombre varchar(200)  NOT NULL,
    activa boolean  NOT NULL,
    valmin decimal(18,3)  NOT NULL,
    valmax decimal(18,3)  NOT NULL,
    CONSTRAINT variable_pk PRIMARY KEY (id_variable)
);

-- foreign keys
-- Reference: departamento_edificio (table: departamento)
ALTER TABLE departamento ADD CONSTRAINT departamento_edificio
    FOREIGN KEY (id_edificio)
    REFERENCES edificio (id_edificio)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: edificio_Constructora (table: edificio)
ALTER TABLE edificio ADD CONSTRAINT edificio_Constructora
    FOREIGN KEY (id_constructora)
    REFERENCES constructora (id_constructora)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: medicion_departamento_departamento (table: medicion_departamento)
ALTER TABLE medicion_departamento ADD CONSTRAINT medicion_departamento_departamento
    FOREIGN KEY (id_departamento)
    REFERENCES departamento (id_departamento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: medicion_departamento_variable (table: medicion_departamento)
ALTER TABLE medicion_departamento ADD CONSTRAINT medicion_departamento_variable
    FOREIGN KEY (id_variable)
    REFERENCES variable (id_variable)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: medicion_medicion_departamento (table: medicion)
ALTER TABLE medicion ADD CONSTRAINT medicion_medicion_departamento
    FOREIGN KEY (id_variable, id_departamento)
    REFERENCES medicion_departamento (id_variable, id_departamento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

