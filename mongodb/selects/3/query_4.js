use scada;

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