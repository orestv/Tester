<%-- 
    Document   : results.test
    Created on : Mar 14, 2012, 10:34:22 PM
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

    int testId = Integer.parseInt(request.getParameter("id"));

    Connection cn = dbutils.DBUtils.conn();
    PreparedStatement stTest = cn.prepareStatement("SELECT name FROM test WHERE id = ?;");
    ResultSet rsTest = stTest.executeQuery();
    rsTest.next();
    String sTestName = rsTest.getString("name");
    rsTest.close();
    stTest.close();

    PreparedStatement stStudents = cn.prepareStatement("SELECT t.id, t.name, t.questionCount AS maxResult, "
	    + "MAX(ta.result) AS result, s.id, s.firstname, s.lastname "
	    + "FROM test t "
	    + "LEFT OUTER JOIN test_attempt ta ON t.id = ta.test_id AND t.id = ? "
	    + "RIGHT OUTER JOIN student s ON ta.student_id = s.id "
	    + "GROUP BY t.id, s.id ORDER BY s.lastname, s.firstname;");
    stStudents.setInt(1, testId);
    ResultSet rsStudents = stStudents.executeQuery();

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати тесту <%= sTestName%></title>
    </head>
    <body>
	<table>
	    <tr>
		<th>Студент</th>
		<th>Кращий результат</th>
	    </tr>
	    <%
		while (rsStudents.next()) {
	    %>
	    <tr>
		<td><%= rsStudents.getString("firstname") + rsStudents.getString("lastname") %></td>
		<td><%= rsStudents.getFloat("result") %> / <%= rsStudents.getInt("maxResult") %></td>
	    </tr>
	    <%			}
	    %>
	</table>
    </body>
</html>
<%

    rsStudents.close();
    stStudents.close();
    cn.close();
%>