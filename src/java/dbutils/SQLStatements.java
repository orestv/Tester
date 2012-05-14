/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dbutils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


/**
 *
 * @author seth
 */
public class SQLStatements {

    public static PreparedStatement getStudentTestAttempts(Connection cn, int studentId) throws SQLException {
	PreparedStatement stFinished = cn.prepareStatement("SELECT ta.id AS attempt_id, t.id AS test_id, "
		+ "t.name AS test_name, ta.start AS start, ta.end AS end, t.final AS final, "
		+ "COUNT(question_id) AS max, SUM(points) AS taken "
		+ "FROM (SELECT ta.id AS test_attempt_id, q.id AS question_id,      "
		+ "CASE WHEN q.multiselect         "
		+ "THEN SUM( CASE WHEN (a.correct = 1 AND sa.id IS NOT NULL)                          "
		+ "OR (a.correct = 0 AND sa.id IS NULL)                         "
		+ "THEN 1 ELSE 0 END) / COUNT(a.id)     "
		+ "ELSE SUM(CASE WHEN a.correct = 1 AND sa.id IS NOT NULL THEN 1 ELSE 0 END)     "
		+ "END AS points     "
		+ "FROM test_attempt ta     "
		+ "INNER JOIN test t ON ta.test_id = t.id     "
		+ "INNER JOIN question_sequence qs  ON qs.test_id = t.id AND (qs.student_id IS NULL OR qs.student_id = ta.student_id)     "
		+ "INNER JOIN question_sequence_questions qsq ON qsq.sequence_id = qs.id     "
		+ "INNER JOIN question q ON qsq.question_id = q.id     "
		+ "INNER JOIN answer a ON a.question_id = q.id     "
		+ "LEFT OUTER JOIN student_answer sa ON sa.test_attempt_id = ta.id AND sa.answer_id = a.id     "
		+ "GROUP BY ta.id, q.id     ORDER BY q.id ) pts "
		+ "INNER JOIN test_attempt ta     ON pts.test_attempt_id = ta.id "
		+ "INNER JOIN test t ON ta.test_id = t.id "
		+ "WHERE ta.student_id = ? AND ta.end IS NOT NULL "
		+ "GROUP BY ta.id");
	stFinished.setInt(1, studentId);
	return stFinished;
    }
}
