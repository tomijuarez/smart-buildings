use scada;

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