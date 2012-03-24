/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

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
    
    public static class Answer {
        private int id;
        private String text;
        private boolean correct;
	private boolean selected = false;

        public Answer(int id, String text, boolean correct) {
            this.id = id;
            this.text = text;
            this.correct = correct;
        }
	
	public Answer (int id, String text, boolean correct, boolean selected) {
	    this(id, text, correct);
	    this.selected = selected;
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

	public boolean isSelected() {
	    return selected;
	}

	public void setSelected(boolean selected) {
	    this.selected = selected;
	}
    }

    private int id;
    private int topicId;
    private String text;
    private String comment;
    private LinkedList<Answer> answers = new LinkedList<Answer>();
    private boolean multiSelect;
    private float pointsTaken;

    public float getPointsTaken() {
	return pointsTaken;
    }

    public void setPointsTaken(float pointsTaken) {
	this.pointsTaken = pointsTaken;
    }

    public Question() {
    }

    public Question(int id) {
        this.id = id;
    }
    
    public Question (int id, String text, String comment, boolean multiselect) {
	this.id = id;
	this.text = text;
	this.comment = comment;
	this.multiSelect = multiselect;
    }
    
    public void fill() throws SQLException {
        Connection cn = DBUtils.conn();
        PreparedStatement st = cn.prepareStatement("SELECT text, topic_id, comment, multiselect "
                + "FROM question WHERE id = ?");
        st.setInt(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            setText(rs.getString("text"));
            setComment(rs.getString("comment"));
	    setTopicId(rs.getInt("topic_id"));
            multiSelect = rs.getBoolean("multiselect");
        }
        if (rs != null)
            rs.close();
        if (st != null)
            st.close();
        
        st = cn.prepareStatement("SELECT id, text, correct FROM answer WHERE question_id = ? ORDER BY RAND();");
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
    
    public boolean isMultiSelect() {
        return multiSelect;
    }

    public LinkedList<Answer> getAnswers() {
        return answers;
    }

    public void setAnswers(LinkedList<Answer> answers) {
        this.answers = answers;
    }

    public int getTopicId() {
        return topicId;
    }

    public void setTopicId(int topicId) {
        this.topicId = topicId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
