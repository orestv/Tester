/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processors;

import Data.Question;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;
import java.util.Map.Entry;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author seth
 */
public class QuestionEdit extends HttpServlet {
    private PreparedStatement stAddAnswer;
    private PreparedStatement stUpdateAnswer;
    private Connection cn;

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
	int id = -1;
	Question q = null;
	try {
	    String sQuestionId = request.getParameter("questionId");
	    id = Integer.parseInt(sQuestionId);
	    q = new Question(id);
	    q.fill();
	    String text = ServletUtils.decodeParameter(request.getParameter("questionText"));
	    String comment = ServletUtils.decodeParameter(request.getParameter("questionComment"));
	    cn = dbutils.DBUtils.conn();
	    stAddAnswer = cn.prepareStatement("INSERT INTO answer (question_id, "
		    + "text, correct) VALUES (?, ?, ?);");
	    stUpdateAnswer = cn.prepareStatement("UPDATE answer SET text = ?, "
		    + "correct = ? WHERE id = ?;");
	    PreparedStatement stUpdateQuestion = cn.prepareStatement("UPDATE question "
		    + "SET text = ?, comment = ? WHERE id = ?;");
	    stUpdateQuestion.setString(1, text);
	    stUpdateQuestion.setString(2, comment);
	    stUpdateQuestion.setInt(3, id);
	    stUpdateQuestion.execute();
	    
	    Map<String, String[]> parameterMap = request.getParameterMap();
	    for (Entry<String, String[]> entry : parameterMap.entrySet()) {
		String key = entry.getKey();
		String[] values = entry.getValue();
	    }
	} catch (SQLException ex) {
	} finally {	    
	    response.sendRedirect("question_list.jsp?topic=" + Integer.toString(q.getTopicId()));
	    out.close();
	}
    }
    
    private void addAnswer(String text, boolean isCorrect) {
	
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
