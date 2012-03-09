/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import Data.Question;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;

/**
 *
 * @author seth
 */
public class ResultProcessor {

    public static LinkedList<Question> getDetailedResults(int attemptId, Connection cn) throws SQLException {
	
	LinkedList<Question> result = new LinkedList<Question>();

	PreparedStatement stDetailedResults = cn.prepareStatement("SELECT q.id AS question_id, "
		+ "q.text AS question_text, q.comment AS question_comment, q.multiselect AS multiselect, "
		+ "a.id AS answer_id, a.text AS answer_text, a.correct AS correct, "
		+ "CASE WHEN sa.id IS NULL THEN 0 ELSE 1 END AS selected "
		+ "FROM test_attempt ta "
		+ "INNER JOIN test t ON ta.test_id = t.id "
		+ "INNER JOIN question_sequence qs ON qs.test_id = t.id AND (qs.student_id IS NULL OR qs.student_id = ta.student_id) "
		+ "INNER JOIN question_sequence_questions qsq ON qsq.sequence_id = qs.id "
		+ "INNER JOIN question q ON qsq.question_id = q.id "
		+ "INNER JOIN answer a ON a.question_id = q.id "
		+ "LEFT OUTER JOIN student_answer sa ON sa.test_attempt_id = ta.id "
		+ " AND sa.answer_id = a.id "
		+ "WHERE ta.id = ? "
		+ "ORDER BY qsq.order ASC;");
	stDetailedResults.setInt(1, attemptId);
	ResultSet rsDetailedResults = stDetailedResults.executeQuery();
	int qid_old = -1;
	float points = 0;
	int answers = 0;
	Question question = null;
	while (rsDetailedResults.next()) {
	    int qid = rsDetailedResults.getInt("question_id");
	    if (qid_old != qid) {
		if (question != null) {
		    question.setPointsTaken(question.isMultiSelect() ? points/answers : points);
		    result.add(question);
		}
		points = 0;
		answers = 0;
		String qtext = rsDetailedResults.getString("question_text");
		String qcomment = rsDetailedResults.getString("question_comment");
		boolean multiselect = rsDetailedResults.getBoolean("multiselect");
		question = new Question(qid, qtext, qcomment, multiselect);
		qid_old = qid;
	    }
	    int aid = rsDetailedResults.getInt("answer_id");
	    String atext = rsDetailedResults.getString("answer_text");
	    boolean correct = rsDetailedResults.getBoolean("correct");
	    boolean selected = rsDetailedResults.getBoolean("selected");
	    if ((selected && correct) || (question.isMultiSelect() && selected == correct)) {
		points++;
	    }
	    answers++;
	    Question.Answer ans = new Question.Answer(aid, atext, correct, selected);
	    question.getAnswers().add(ans);
	}
	rsDetailedResults.close();
	stDetailedResults.close();
	if (question != null) {
	    question.setPointsTaken(question.isMultiSelect() ? points/answers : points);
	    result.add(question);
	}

	return result;
    }
}
