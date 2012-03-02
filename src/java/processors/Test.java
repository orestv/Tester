/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import java.util.LinkedList;

/**
 *
 * @author seth
 */
public class Test {
    private LinkedList<Integer> questionIds = new LinkedList<Integer>();
    private int currentIndex = 0;

    public LinkedList<Integer> getQuestionIds() {
        if (questionIds == null)
            questionIds = new LinkedList<Integer>();
        return questionIds;
    }

    public void setQuestionIds(LinkedList<Integer> questionIds) {
        this.questionIds = questionIds;
    }

    public int getCurrentQuestionId() {
        return questionIds.size() >= currentIndex + 1 ? questionIds.get(currentIndex) : 0;
    }
    
    public void moveNext() {
        currentIndex++;
    }
    
    public void clear() {
       getQuestionIds().clear();
    }
    
    public boolean isLast() {
        return questionIds.size() == currentIndex + 1;
    }
}
