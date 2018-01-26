use scada;

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