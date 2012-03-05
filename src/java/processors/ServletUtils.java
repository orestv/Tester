/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import java.io.UnsupportedEncodingException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author seth
 */
public class ServletUtils {
    public static String decodeParameter(String input) {
	if (input == null)
	    return null;
	try {
	    return new String(input.getBytes("ISO8859-1"), "UTF-8");
	} catch (UnsupportedEncodingException ex) {
	    Logger.getLogger(ServletUtils.class.getName()).log(Level.SEVERE, null, ex);
	}
	return null;
    }
}
