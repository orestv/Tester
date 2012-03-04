/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dbutils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 *
 * @author seth
 */
public class DBUtils {
    private static String user = "application";
    private static String password = "medicine";
    private static String url = "jdbc:mysql://localhost/tests?useUnicode=yes&characterEncoding=UTF-8";
    
    public static Connection conn() throws SQLException {
        Connection cn;
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {}
        cn = DriverManager.getConnection(url, user, password);
        return cn;
    }
}
