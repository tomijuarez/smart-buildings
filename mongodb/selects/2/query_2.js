use scada;

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