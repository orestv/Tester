/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dbutils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author seth
 */
public class DBUtils {
    private static String user = "orestv";
    private static String password = "fresh590441";
    private static String url = "jdbc:mysql://localhost/tests?useUnicode=yes&characterEncoding=UTF-8";
    private static DateFormat dateFormat;
    
    public static Connection conn() throws SQLException {
        Connection cn;
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {}
        cn = DriverManager.getConnection(url, user, password);
        return cn;
    }
    public static String format(Date date) {
	if (dateFormat == null)
	    dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm");
	return dateFormat.format(date);
    }
}
