#!/bin/bash

export PGPASSWORD="CAMBIAR ACÁ LA CONTRASEÑA"

START=$(date +%s.%N)

psql -U "postgres" -h localhost -d "scada" -f "constructora.sql"
psql -U "postgres" -h localhost -d "scada" -f "edificio.sql"
psql -U "postgres" -h localhost -d "scada" -f "departamento.sql"
psql -U "postgres" -h localhost -d "scada" -f "variable.sql"

COUNTERVAR=1
while [ $COUNTERVAR -lt 9 ]; do
	psql -U "postgres" -h localhost -d "scada" -f "medicion_departamento/medicion_departamento_v$COUNTERVAR.sql";

    let COUNTERVAR=COUNTERVAR+1 
done

COUNTERVAR=1
while [ $COUNTERVAR -lt 9 ]; do
	NUMBER=1
	while [ $NUMBER -lt 21 ]; do
		psql -U "postgres" -h localhost -d "scada" -f "medicion/variable$COUNTERVAR/"$NUMBER"_medicion_v$COUNTERVAR.sql";

		let NUMBER=NUMBER+1
	done
    let COUNTERVAR=COUNTERVAR+1 
done

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF >> "time.txt"
