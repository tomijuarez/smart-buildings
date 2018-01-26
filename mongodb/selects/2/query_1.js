use scada; 

db.medicion.distinct(
    "id_departamento", 
    {"fecha": 
        {
            $gte: ISODate("2010-01-01T03:00:00.0Z"), 
            $lt: ISODate("2011-01-01T03:00:00.0Z")
        }
    }
).sort();