use scada;

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
