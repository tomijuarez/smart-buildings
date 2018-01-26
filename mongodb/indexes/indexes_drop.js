db.medicion.dropIndex({id_variable:1, id_departamento:1, fecha:1});
db.medicion.dropIndex("fecha");
db.medicion.dropIndex("valor");