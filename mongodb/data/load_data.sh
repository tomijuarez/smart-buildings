#!/bin/bash

START=$(date +%s.%N)

mongoimport --db "scada" --collection "constructora" --file "constructora.json"
mongoimport --db "scada" --collection "edificio" --file "edificio.json"
mongoimport --db "scada" --collection "departamento" --file "departamento.json"
mongoimport --db "scada" --collection "variable" --file "variable.json"
mongoimport --db "scada" --collection "medicion_departamento" --file "medicion_departamento.json"
mongoimport --db "scada" --collection "medicion" --file "medicion.json"

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF >> "time.txt"