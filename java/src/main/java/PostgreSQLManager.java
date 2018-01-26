import java.sql.*;
import java.util.Map;

/**
 * Created by tomi on 05/07/17.
 */
public class PostgreSQLManager {

    private static PostgreSQLManager instance = null;
    private Connection connection = null;

    private PostgreSQLManager() {
        //Intencionalmente en blanco para materializar el patrón singleton.
    }

    public static PostgreSQLManager connect() {
        if(PostgreSQLManager.instance == null)
            PostgreSQLManager.instance = new PostgreSQLManager();
        return PostgreSQLManager.instance;
    }

    public boolean init(String database, String host, String port, String user, String password) {
        try {
            Class.forName("org.postgresql.Driver");
            this.connection = DriverManager.getConnection(
                    "jdbc:postgresql://"+host+":"+port+"/"+database,
                    user,
                    password
            );
        }
        catch (Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName()+": "+e.getMessage());
            System.exit(0);
            return false;
        }

        return true;
    }

    public ResultSet select(String select) {
        ResultSet rows = null;
        try {
            Statement query = this.connection.createStatement();
            rows = query.executeQuery(select);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }

    public void close() {
        try {
            this.connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
