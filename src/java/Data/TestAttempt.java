/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author seth
 */
public class TestAttempt {
    private int id;

    public int getId() {
	return id;
    }

    public void setId(int id) {
	this.id = id;
    }
    
    public void finish(Connection cn) throws SQLException {
	PreparedStatement st = cn.prepareStatement("UPDATE test_attempt ta "
		+ "LEFT JOIN viewTestAttemptResult tar ON ta.id = tar.testAttemptID "
		+ "SET end = CURRENT_TIMESTAMP(), result = tar.points WHERE ta.id = ?;");
	st.setInt(1, getId());
	st.executeUpdate();
	st.close();
    }
    
}
