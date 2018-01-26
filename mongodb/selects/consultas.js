/**********************************************************
 * 1. CONSULTAS CON FUNCIONES DE AGREGACIÓN Y AGRUPAMIENTO
 **********************************************************/

//a. Obtener el total de consumo registrado de cada variable.
db.medicion.aggregate([
    {$group:
        { 
            _id: "$id_variable",
            consumo: { $sum : "$valor" }
        }
    }
]);

//b. Obtener la cantidad de edificios en donde sus departamentos registrados sumen más de 80000 metros cuadrados.
db.departamento.aggregate([
    {$group: 
        {
            _id: "$id_edificio",
            suma: { $sum : "$metros" }
        }
    },
    {$match: { "suma": { $gt : 80000 } } },
    {$count: "cantidad"}
]);

//c. Obtener el promedio de cada variable y los máximos y mínimos registrados para cada una de ellas.
db.medicion.aggregate([
    {$group:
        {
            _id: "$id_variable",
            minimo: { $min: "$valor" },
            maximo: { $max: "$valor" },
            promedio: { $avg: "$valor" }
        }
    }
]);

/****************************
 * 2. CONSULTAS CON DISTINCT
 ****************************/

//a. Seleccionar todos los departamentos que registren mediciones en el año 2010 sin repeticiones.
//Opción 1
db.medicion.distinct(
    "id_departamento", 
    {"fecha": 
        {
            $gte: ISODate("2010-01-01T03:00:00.0Z"), 
            $lt: ISODate("2011-01-01T03:00:00.0Z")
        }
    }
).sort();

//Opción 2
db.medicion.aggregate([    
    {$match:
        {"fecha": 
            {
                $gte: ISODate("2010-01-01T03:00:00.0Z"), 
                $lt: ISODate("2011-01-01T03:00:00.0Z")
            }
        }
    },
    {$group:{_id:"$id_departamento"}},
    {$sort:{"_id":1}}
]);

//b. Seleccionar sin repeticiones los años y meses en donde se registren mediciones.

//180*60*1000 +3
db.medicion.aggregate([    
    {$group:
        {_id: 
            {
                "año":{
                    $year:[{$subtract:["$fecha",10800000]}]
                },
                "mes":{
                    $month:[{$subtract:["$fecha",10800000]}]
                }
            }
        }
    }
]);

/************************************
 * 3. CONSULTAS EN MÁS DE UNA TABLA
 ***********************************/

//a. Seleccionar los departamentos que registren al menos una medición de datos superiores a 90GB en el mes de mayo de 2010.
//Opción 1

var variable = db.variable.findOne({"nombre":"datos"});
var id_var = variable["_id"];

db.medicion.aggregate([
    {$match:
        {
            "id_variable": id_var,
            "fecha": {$gte: ISODate("2010-05-01T03:00:00.0Z"), $lt: ISODate("2010-06-01T03:00:00.0Z")},
            "valor" : {$gt:90}
        }
     },
     {$lookup:
        {
            from: "departamento",
            localField: "id_departamento",
            foreignField: "_id",
            as: "departamento"
        }
     },
     {$unwind: "$departamento"},
     {$lookup:
        {
            from: "edificio",
            localField: "departamento.id_edificio",
            foreignField: "_id",
            as: "edificio"
        }
     },
     {$unwind:"$edificio"},
     {$project:
         {
            "pais": "$edificio.pais",
            "provincia": "$edificio.provincia",
            "ciudad": "$edificio.ciudad",
            "direccion": "$edificio.direccion",
            "nombre_depto": "$departamento.nombre_depto"
         }
     }
]);

//Opción 2
var variable = db.variable.findOne({"nombre":"datos"});
var id_var = variable["_id"];

db.medicion.aggregate([
    {$match:
        {
            "id_variable": id_var,
            "fecha": {$gte: ISODate("2010-05-01T03:00:00.0Z"), $lt: ISODate("2010-06-01T03:00:00.0Z")}
        }
     },
     {$project:
         {
            "id_departamento": "$id_departamento",
            "valor": "$valor"
         }
     },
     {$group:
        {
            _id: "$id_departamento",
            valor: {$max:"$valor"}
        }
     },
     {$match:
        {
            "valor" : {$gt:90}
        }
     },
     {$lookup:
        {
            from: "departamento",
            localField: "_id",
            foreignField: "_id",
            as: "departamento"
        }
     },
     {$unwind: "$departamento"},
     {$lookup:
        {
            from: "edificio",
            localField: "departamento.id_edificio",
            foreignField: "_id",
            as: "edificio"
        }
     },
     {$unwind:"$edificio"},
     {$project:
         {
            "pais": "$edificio.pais",
            "provincia": "$edificio.provincia",
            "ciudad": "$edificio.ciudad",
            "direccion": "$edificio.direccion",
            "nombre_depto": "$departamento.nombre_depto"
         }
     }
]);

//b. Obtener el consumo total eléctrico de todos los edificios registrados en estados unidos.
var variable = db.variable.findOne({"nombre":"electricidad"});
var id_var = variable["_id"];
db.medicion.aggregate([
    {$match:
        {
            "id_variable": id_var
        }
     },
     {$group:
        {
            _id: "$id_departamento",
            valor: {$sum:"$valor"}
        }
     },
     {$lookup:
        {
            from: "departamento",
            localField: "_id",
            foreignField: "_id",
            as: "departamento"
        }
     },
     {$unwind: "$departamento"},
     {$lookup:
        {
            from: "edificio",
            localField: "departamento.id_edificio",
            foreignField: "_id",
            as: "edificio"
        }
     },
     {$unwind:"$edificio"},
     {$match:
         {
            "edificio.pais":"United States"
         }
     },
     {$group:
         {
            _id:null,
            "consumoTotal": {$sum:"$valor"}
         }
     }
]);

//c. Obtener la sumatoria de los excedentes de gas en los registros de mediciones de cada departamento desde el año 2014 al 2016 inclusive.
var variable = db.variable.findOne({nombre:"gas"});
var valmax = variable["valmax"];
var id_variable = variable["_id"];
    
db.medicion.aggregate([
    {$match:
        {
            "fecha": {$gte: ISODate("2014-01-01T03:00:00.0Z"), $lt: ISODate("2017-01-01T03:00:00.0Z")},
            "id_variable": id_variable,
            "valor": {$gt: valmax}
        }
     },
     {$project:
         {
            "id_departamento": "$id_departamento",
            resta: {$subtract: ["$valor", valmax]}
         }
     },
     {$group:
         {
            _id: {"id_departamento":"$id_departamento"},
            excedente: {$sum: "$resta"}
         }
     }
]);