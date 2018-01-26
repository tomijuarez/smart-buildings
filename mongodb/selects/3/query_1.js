use scada;

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