/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import dbutils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

/**
 *
 * @author seth
 */
public class Question {
    
    public class Answer {
        private int id;
        private String text;
        private boolean correct;

        public Answer(int id, String text, boolean correct) {
            this.id = id;
            this.text = text;
            this.correct = correct;
        }

        public boolean isCorrect() {
            return correct;
        }

        public void setCorrect(boolean correct) {
            this.correct = correct;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }
    }

    private int id;
    private int testId;
    private String text;
    private String comment;
    private LinkedList<Answer> answers;
    private boolean multiChoice;

    public Question() {
    }

    public Question(int id) {
        this.id = id;
    }
    
    public void fill() throws SQLException {
        Connection cn = DBUtils.conn();
        PreparedStatement st = cn.prepareStatement("SELECT text, comment, multiselect "
                + "FROM question WHERE id = ?");
        st.setInt(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            setText(rs.getString("text"));
            setComment(rs.getString("comment"));
            multiChoice = rs.getBoolean("multiselect");
        }
        if (rs != null)
            rs.close();
        if (st != null)
            st.close();
        
        st = cn.prepareStatement("SELECT id, text, correct FROM answer WHERE question_id = ?");
        st.setInt(1, id);
        rs = st.executeQuery();
        answers = new LinkedList<Answer>();
        while (rs.next()) {
            int ansId = rs.getInt("id");
            String ansText = rs.getString("text");
            boolean ansCorrect = rs.getBoolean("correct");
            answers.add(new Answer(ansId, ansText, ansCorrect));
        }
        if (rs != null)
            rs.close();
        if (st != null)
            st.close();
        
        if (cn != null)
            cn.close();
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
    
    public boolean isMultiChoice() {
        return multiChoice;
    }

    public LinkedList<Answer> getAnswers() {
        return answers;
    }

    public void setAnswers(LinkedList<Answer> answers) {
        this.answers = answers;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
