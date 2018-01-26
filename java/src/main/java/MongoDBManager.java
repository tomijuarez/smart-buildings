import com.mongodb.*;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by tomi on 05/07/17.
 */

public class MongoDBManager {

    private static MongoDBManager instance = null;

    MongoClient mongoClient = null;
    MongoDatabase db = null;

    public static MongoDBManager connect() {
        if(MongoDBManager.instance == null)
            MongoDBManager.instance = new MongoDBManager();
        return MongoDBManager.instance;
    }

    public boolean init(String host, int port, String database) {
        this.mongoClient = new MongoClient(host, port);
        this.db = mongoClient.getDatabase(database);
        this.cc = this.db.getCollection("medicion");
        return true;
    }

    private MongoDBManager() {
    }

    public void simpleInsert(ResultSet first, String col) {
        MongoCollection collection = this.db.getCollection(col);
        Document ins = new Document();
        try {
            ins.put("_id", first.getInt("id_constructora"));
            ins.put("nombre_responsable", first.getString("nombre_responsable"));
            ins.put("telefono_responsable", first.getString("telefono_responsable"));
            ins.put("mail_responsable", first.getString("mail_responsable"));


        } catch (SQLException e) {
            e.printStackTrace();
        }
        collection.insertOne(ins);
    }

    public void insertEdificios(ResultSet first, String col) {
        MongoCollection collection = this.db.getCollection(col);
        Document ins = new Document();
        try {
            ins.put("_id", first.getInt("id_edificio"));
            ins.put("pais", first.getString("pais"));
            ins.put("provincia", first.getString("provincia"));
            ins.put("ciudad", first.getString("ciudad"));
            ins.put("direccion", first.getString("direccion"));
            ins.put("id_constructora", first.getInt("id_constructora"));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        collection.insertOne(ins);
        /*
        MongoCollection collection = this.db.getCollection(parentCol);
        BasicDBObject whereQuery = new BasicDBObject();
        Document push = new Document();

        try {
            whereQuery.put("_id", first.getInt("id_constructora"));

            push.put("$push",
                    new Document("edificio",
                            new Document("_id", first.getInt("id_edificio")).
                                    append("pais", first.getString("pais")).
                                    append("provincia", first.getString("provincia")).
                                    append("ciudad", first.getString("ciudad")).
                                    append("direccion", first.getString("direccion")).
                                    append("departamento", new ArrayList<Document>())
                    )
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }

        collection.updateOne(whereQuery, push);
        */
    }

    public void insertDepartamentos(ResultSet first, String col) {
        MongoCollection collection = this.db.getCollection(col);
        Document ins = new Document();
        try {
            ins.put("_id", first.getInt("id_departamento"));
            ins.put("nombre_depto", first.getString("nombre_depto").charAt(0));
            ins.put("nro_planta", first.getInt("nro_planta"));
            ins.put("metros", first.getDouble("metros"));
            ins.put("id_edificio", first.getInt("id_edificio"));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        collection.insertOne(ins);

        /*
        MongoCollection collection = this.db.getCollection(parentCol);
        BasicDBObject whereQuery = new BasicDBObject();
        Document push = new Document();

        try {
            whereQuery.append("edificio._id", first.getLong("id_edificio"));

            push.put("$push",
                    new Document("edificio.$.departamento",
                            new Document("_id", first.getLong("id_departamento")).
                                    append("nombre_depto", first.getString("nombre_depto").charAt(0)).
                                    append("nro_planta", first.getInt("nro_planta")).
                                    append("metros", first.getDouble("metros"))
                    )
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }

        collection.updateOne(whereQuery, push);
        */
    }

    //No se puede. El operador posicional $ no puede recorrer más de un array en profundidad :(
    /*public void insertVariablesMedicion(ResultSet first, String parentCol) {
        MongoCollection collection = this.db.getCollection(parentCol);
        BasicDBObject whereQuery = new BasicDBObject();
        Document push = new Document();

        try {
            whereQuery.append("edificio.departamento._id", first.getLong("id_departamento"));

            push.put("$push",
                    new Document("edificio.departamento.$.medicion_departamento",
                            new Document("_id", first.getInt("id_variable")).
                                    append("intervalo_medicion", first.getInt("intervalo_medicion")).
                                    append("inicio", first.getTimestamp("inicio")).
                                    append("fin", first.getTimestamp("fin"))
                    )
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }

        collection.updateMany(whereQuery, push);
    }*/

    public void insertVariables(ResultSet first, String col) {
        MongoCollection collection = this.db.getCollection(col);
        Document ins = new Document();
        try {
            ins.put("_id", first.getInt("id_variable"));
            ins.put("nombre", first.getString("nombre"));
            ins.put("activa", first.getBoolean("activa"));
            ins.put("valmin", first.getFloat("valmin"));
            ins.put("valmax", first.getFloat("valmax"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        collection.insertOne(ins);
    }

    public void insertVariablesMedicion(ResultSet first, String col) {
        MongoCollection collection = this.db.getCollection(col);
        Document ins = new Document();
        try {
            ins.put("id_variable", first.getInt("id_variable"));
            ins.put("id_departamento", first.getLong("id_departamento"));
            ins.put("intervalo_medicion", first.getInt("intervalo_medicion"));
            ins.put("inicio", first.getDate("inicio"));
            ins.put("fin", null);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        collection.insertOne(ins);


        /*
        MongoCollection collection = this.db.getCollection(parentCol);
        BasicDBObject whereQuery = new BasicDBObject();
        Document push = new Document();

        collection.withWriteConcern(WriteConcern.UNACKNOWLEDGED);

        try {
            whereQuery.append("_id", first.getLong("id_variable"));

            push.put("$push",
                    new Document("medicion_departamento",
                            new Document("id_departamento", first.getLong("id_departamento")).
                                    append("intervalo_medicion", first.getInt("intervalo_medicion")).
                                    append("inicio", first.getDate("inicio")).
                                    append("fin", null)
                    )
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }

        collection.updateOne(whereQuery, push);*/
    }

    private MongoCollection cc;

    public void insertMedicion(ResultSet first, String col) {
        Document ins = new Document();
        try {
            ins.put("id_variable", first.getInt("id_variable"));
            ins.put("id_departamento", first.getLong("id_departamento"));
            ins.put("fecha", first.getTimestamp("fecha"));
            ins.put("valor", first.getDouble("valor"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        this.cc.insertOne(ins);
    }
}
