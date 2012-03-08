/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

/**
 *
 * @author seth
 */
public class Topic {
    private int id;
    private String name;
    private int questionCount = -1;
    private boolean questionCountKnown = false;
    
    public Topic(int id, String name) {
	setId(id);
	setName(name);
    }
    
    public Topic(int id, String name, int questionCount) {
	this(id, name);
	setQuestionCount(questionCount);
    }

    public boolean isQuestionCountKnown() {
	return questionCountKnown;
    }

    public int getQuestionCount() {
	return questionCount;
    }

    public void setQuestionCount(int questionCount) {
	this.questionCount = questionCount;
	questionCountKnown = true;
    }

    public int getId() {
	return id;
    }

    public void setId(int id) {
	this.id = id;
    }

    public String getName() {
	return name;
    }

    public void setName(String name) {
	this.name = name;
    }
    
}
