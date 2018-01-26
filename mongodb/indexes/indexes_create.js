use scada;

db.medicion.createIndex({id_variable:1, id_departamento:1, fecha:1},{unique:true, name:"ix_pk_medicion"});
db.medicion.createIndex({fecha:1},{name:"ix_fecha_medicion"});
db.medicion.createIndex({valor:1},{name:"ix_valor_medicion"});