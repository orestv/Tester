/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Data;

import java.util.LinkedList;

/**
 *
 * @author seth
 */
public class Test {
    private LinkedList<Topic> topics;
    private int id;
    private String name;
    private boolean isFinal;

    public Test(int id, String name, boolean isFinal) {
	this.id = id;
	this.name = name;
	this.isFinal = isFinal;
    }
    
    public boolean isFinal(){
	return isFinal;
    }
    
    public void setFinal(boolean isFinal) {
	this.isFinal = isFinal;
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

    public LinkedList<Topic> getTopics() {
	if (topics == null)
	    topics = new LinkedList<Topic>();
	return topics;
    }

    public void setTopics(LinkedList<Topic> topics) {
	this.topics = topics;
    }
    
}
