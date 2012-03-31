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
    stTest.setInt(1, testId);
    ResultSet rsTest = stTest.executeQuery();
    rsTest.next();
    String sTestName = rsTest.getString("name");
    rsTest.close();
    stTest.close();

    PreparedStatement stStudents = cn.prepareStatement("SELECT s.id, s.firstname, s.lastname, "
	    + "MAX(ta.result) AS result, t.questioncount AS maxResult, "
	    + "CASE WHEN ta.result IS NULL THEN 0 ELSE 1 END AS tried "
	    + "FROM student s "
	    + "LEFT OUTER JOIN test_attempt ta ON s.id = ta.student_id AND ta.test_id = ? AND ta.end IS NOT NULL "
	    + "INNER JOIN test t ON t.id = ? "
	    + "GROUP BY s.id");
    stStudents.setInt(1, testId);
    stStudents.setInt(2, testId);
    ResultSet rsStudents = stStudents.executeQuery();

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати тесту <%= sTestName%></title>
	<link rel="stylesheet" href="styles.css"/>
    </head>
    <body>
	<div style="width: 50%">
	    <h2>Результати тесту <%= sTestName%> </h2>
	    <table style="width: 100%;">
		<tr>
		    <th>Студент</th>
		    <th>Кращий результат</th>
		</tr>
		<%
		    while (rsStudents.next()) {
		%>
		<tr>
		    <td><%= rsStudents.getString("firstname") + " " + rsStudents.getString("lastname")%></td>
		    <td><%= rsStudents.getBoolean("tried")
			    ? String.format("%.1f/%d", rsStudents.getFloat("result"), rsStudents.getInt("maxResult"))
			    : "-"%></td>
		</tr>
		<%			}
		%>
	    </table>
	</div>
    </body>
</html>
<%

    rsStudents.close();
    stStudents.close();
    cn.close();
%>
