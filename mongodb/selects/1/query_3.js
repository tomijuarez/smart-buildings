use scada;

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