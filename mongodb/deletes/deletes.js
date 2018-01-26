//El sistema se encuentra en etapa de migración pero los los desarrolladores decidieron copiar la información de las mediciones desde 2010 en adelante y conservar la información previa a ese año. Como los datos posteriores al 2010 ya se salvaron en otra base de datos, es necesario eliminarlos.
db.medicion.remove({"fecha": {$gte: ISODate("2010-01-01T03:00:00.0Z")}});

//Segunda opción.
db.medicion.find({"fecha": {$lt: ISODate("2010-01-01T03:00:00.0Z")}}).forEach(function(doc){
    db.medicionAux.insert(doc);
});
 
db.medicion.getIndexes().forEach(function(ix){
    db.medicionAux.ensureIndex(ix.key);
});
 
db.medicionAux.renameCollection(db.medicion.getName(), {dropTarget: true});
//20,5 minutos

//Se desea eliminar toda la información de las mediciones efectivas relativas a los departamentos en el rango 5.000 a 16.000.
db.medicion.remove({id_departamento:{$gte:5000, $lte:16000}});