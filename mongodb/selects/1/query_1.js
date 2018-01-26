use scada;

db.medicion.aggregate([
    {$group:
        { 
            _id: "$id_variable",
            consumo: { $sum : "$valor" }
        }
    }
]);