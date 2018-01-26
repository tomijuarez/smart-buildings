#!/bin/bash

export PGPASSWORD="CAMBIAR ACÁ LA CONTRASEÑA"
echo "Creando esquema: "
psql -U "postgres" -h "localhost" -d "scada" -f "schema/schema_create.sql"
echo "Ceando índices: "
psql -U "postgres" -h "localhost" -d "scada" -f "indexes/indexes_create.sql"
