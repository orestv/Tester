/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

/**
 *
 * @author seth
 */
public class Admin {
    private boolean loggedIn = false;

    public boolean isLoggedIn() {
        return loggedIn;
    }

    public void setLoggedIn(boolean loggedIn) {
        this.loggedIn = loggedIn;
    }
    
    public static boolean isPasswordValid(String password) {
        return "HardTaught".equals(password);
    }
}
