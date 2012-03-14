<%-- 
    Document   : results_by_test
    Created on : Mar 14, 2012, 9:48:59 PM
    Author     : seth
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="Data.Admin" id="admin" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (!admin.isLoggedIn()) {
	response.sendRedirect("admin.jsp");
	return;
    }
    int testId = Integer.parseInt(request.getParameter("tid"));
    int studentId = Integer.parseInt(request.getParameter("sid"));
    Connection cn = dbutils.DBUtils.conn();
    
    PreparedStatement stStudent = cn.prepareStatement("SELECT firstname, lastname "
	    + "FROM student WHERE id = ?;");
    stStudent.setInt(1, studentId);
    ResultSet rsStudent = stStudent.executeQuery();
    
    rsStudent.close();
    stStudent.close();
    
    PreparedStatement st = cn.prepareStatement("SELECT ta.id AS attempt_id, "
	    + "TestResult(ta.id) AS result, COUNT(qsq.question_id) AS max_result "
	    + "FROM test_attempt ta "
	    + "INNER JOIN test t ON ta.test_id = t.id "
	    + "INNER JOIN question_sequence qs ON qs.test_id = t.id AND "
		+ "qs.student_id = ta.id "
	    + "INNER JOIN question_sequence_questions qsq ON qs.id = qsq.sequence_id "
	    + "WHERE t.id = ? AND (ta.student_id = ? OR ta.student_id IS NULL) "
	    + "GROUP BY qs.id;");
    st.setInt(1, testId);
    st.setInt(2, studentId);
    
    ResultSet rs = st.executeQuery();
    
    rs.close();
    st.close();
    cn.close();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати студента</title>
    </head>
    <body>
        <a href="admin_dashboard.jsp">Повернутись</a>
    </body>
</html>
