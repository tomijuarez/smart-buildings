import com.mongodb.Mongo;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Created by tomi on 05/07/17.
 */
public class Main {
    public static void main(String[] args) {
        PostgreSQLManager db = PostgreSQLManager.connect();

        Scanner scanner = new Scanner(System.in);

        System.out.println("Ingrese la dirección ip de PostgreSQL y MongoDB (mismo ip para ambos)");
        String host = scanner.nextLine();
        System.out.println("Ingrese puerto de PostgreSQL");
        String port1 = scanner.nextLine();
        System.out.println("Ingrese usuario de PostgreSQL");
        String user1 = scanner.nextLine();
        System.out.println("Ingrese contraseña de PostgreSQL");
        String pass1 = scanner.nextLine();

        if(db.init("scada", host, port1, user1, pass1)) {

            System.out.println("Ingrese puerto de MongoDB");
            int port2 = scanner.nextInt();

            MongoDBManager mongo = MongoDBManager.connect();

            mongo.init(host, port2, "scada");


            System.out.println("Insertando datos en colección 'constructora'...");


            ResultSet constructoras = db.select(
                    "SELECT * FROM constructora"
            );
            try {
                while(constructoras.next())
                    mongo.simpleInsert(constructoras, "constructora");
            } catch (SQLException e) {
                e.printStackTrace();
            }

            constructoras = null;

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'edificio'...");

            ResultSet edificios = db.select(
                    "SELECT * FROM edificio"
            );

            try {
                while(edificios.next())
                    mongo.insertEdificios(edificios, "edificio");
            } catch (SQLException e) {
                e.printStackTrace();
            }


            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'departamento'...");


            edificios = null;

            ResultSet departamentos = db.select(
                    "SELECT * FROM departamento"
            );

            try {
                while(departamentos.next())
                    mongo.insertDepartamentos(departamentos, "departamento");
            } catch (SQLException e) {
                e.printStackTrace();
            }

            departamentos = null;


            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'variable'...");

            ResultSet variables = db.select(
                    "SELECT * FROM variable"
            );

            try {
                while(variables.next())
                    mongo.insertVariables(variables, "variable");
            } catch (SQLException e) {
                e.printStackTrace();
            }

            variables = null;

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion_departamento'...");

            ResultSet variablesMed = db.select(
                    "SELECT * FROM medicion_departamento"
            );

            try {
                while(variablesMed.next())
                    mongo.insertVariablesMedicion(variablesMed, "medicion_departamento");
            } catch (SQLException e) {
                e.printStackTrace();
            }

            variablesMed = null;

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 1/8'...");

            ResultSet medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 1"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }


            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 2/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 2"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 3/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 3"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 4/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 4"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 5/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 5"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 6/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 6"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 7/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 7"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            System.out.println("OK.");
            System.out.println("Insertando datos en colección 'medicion 8/8'...");

            medicion = db.select(
                    "SELECT * FROM medicion WHERE id_variable = 8"
            );

            try {
                while(medicion.next()) {
                    mongo.insertMedicion(medicion, "medicion");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            medicion = null;

            System.out.println("OK.");
            System.out.println("Todos los datos han sido insertados correctamente.");

        }
        else
            System.out.println("Error en la conexión a la base de datos.");
    }
}
