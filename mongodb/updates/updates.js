//El equipo de inspección verificó las instalaciones en los edificios logrando identificar errores en los sensores de electricidad, los cuales medían 10W más del escenario real. Se desea modificar todos los registros de medición de electricidad restando 10W en cada caso.
var variable = db.variable2.findOne({nombre:"electricidad"});
var id_variable = variable["_id"];

db.medicion.update(
	{"id_variable": id_variable},
	{$inc:{"valor":-10}},
	{multi:true}
);

//Updated 1000000 existing record(s) in 150279ms

//Se realizó un cambio de equipos de sensores de humo, humedad e iluminación, los cuales registraban valores erróneos en el departamento con identificador 26. La compañía decidió que estos valores no son útiles para el análisis de información, con lo cual decidió anularlos.
var docs = db.variable2.find({$or:[{nombre:"humo"}, {nombre:"humedad"}, {nombre:"iluminacion"}]});
var ids = [];

docs.forEach(function(doc){
	ids.push(doc["_id"]);
});

db.medicion.update(
	{$and:[{"id_departamento":26},{"id_variable": {$in:ids}}]},
	{$set:{"valor":0}},
	{multi:true}
);

//Updated 60 existing record(s) in 951ms