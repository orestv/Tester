/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author seth
 */
public class TestResult {
    public static int getScore(int attemptId) throws SQLException {
	Connection cn = dbutils.DBUtils.conn();
	
	
	cn.close();
	return 0;
    }
    
}
