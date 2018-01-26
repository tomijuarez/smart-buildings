#!/bin/bash

mongoexport --db "scada" --collection "constructora" --out constructora.json
mongoexport --db "scada" --collection "edificio" --out edificio.json
mongoexport --db "scada" --collection "departamento" --out departamento.json
mongoexport --db "scada" --collection "variable" --out variable.json
mongoexport --db "scada" --collection "medicion_departamento" --out medicion_departamento.json
mongoexport --db "scada" --collection "medicion" --out medicion.json