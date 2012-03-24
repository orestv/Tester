/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import dbutils.DBUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author seth
 */
public class LoginHandler extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.setContentType("text/html;charset=UTF-8");
	PrintWriter out = response.getWriter();
	Connection cn = null;
	String sHash = null;
	String firstname = request.getParameter("firstname");
	String lastname = request.getParameter("lastname");
	try {
	    cn = DBUtils.conn();
	    sHash = findHash(firstname, lastname, cn);
	    if (sHash == null) {
		sHash = addStudent(firstname, lastname, cn);
	    }
	    response.sendRedirect(String.format("dashboard.jsp?u=%s", sHash));
	} catch (SQLException ex) {
	    out.write(ex.getMessage());
	} finally {
	    try {
		if (cn != null) {
		    cn.close();
		}
	    } catch (SQLException ex) {
		Logger.getLogger(LoginHandler.class.getName()).log(Level.SEVERE, null, ex);
	    }
	    out.close();
	}
    }

    private String findHash(String firstname, String lastname, Connection cn) throws SQLException {
	PreparedStatement stFindHash = cn.prepareStatement("SELECT hash FROM student "
		+ "WHERE firstname = ? AND lastname = ?;");
	stFindHash.setString(1, firstname);
	stFindHash.setString(2, lastname);
	ResultSet rsHash = stFindHash.executeQuery();
	if (!rsHash.next()) {
	    return null;
	}
	String result = rsHash.getString("hash");
	rsHash.close();
	stFindHash.close();
	return result;
    }

    private String addStudent(String firstname, String lastname, Connection cn) throws SQLException {
	String sResult = null;
	PreparedStatement stAdd = cn.prepareStatement("INSERT INTO student (firstname, lastname, hash) "
		+ "VALUES (?, ?, SHA1(CONCAT(?, ?))); ", Statement.RETURN_GENERATED_KEYS);
	stAdd.setString(1, firstname);
	stAdd.setString(2, lastname);
	stAdd.setString(3, firstname);
	stAdd.setString(4, lastname);
	stAdd.executeUpdate();
	ResultSet rsKey = stAdd.getGeneratedKeys();
	rsKey.next();
	int studentId = rsKey.getInt(1);
	rsKey.close();
	stAdd.close();
	
	PreparedStatement stHash = cn.prepareStatement("SELECT hash FROM student WHERE id = ?;");
	stHash.setInt(1, studentId);
	ResultSet rsHash = stHash.executeQuery();
	rsHash.next();
	sResult = rsHash.getString("hash");
	rsHash.close();
	stHash.close();
	return sResult;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	request.setCharacterEncoding("UTF-8");
	processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
	return "Short description";
    }// </editor-fold>
}
