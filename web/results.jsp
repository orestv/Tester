<%-- 
    Document   : results
    Created on : Mar 8, 2012, 10:51:52 PM
    Author     : seth
--%>

<%@page import="java.util.LinkedList"%>
<%@page import="processors.ResultProcessor"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Dictionary"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="Data.Question.Answer"%>
<%@page import="Data.Question"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="Data.User" scope="session" id="user"/>
<%
int attemptId = Integer.parseInt(request.getParameter("id"));
int testId = -1;
Connection cn = dbutils.DBUtils.conn();
PreparedStatement st = cn.prepareStatement("SELECT test_id FROM test_attempt "
	+ "WHERE id = ? AND student_id = ?");
st.setInt(1, attemptId);
st.setInt(2, user.getId());
ResultSet rs = st.executeQuery();
boolean loginValid = false;
if (rs.next()) {
    loginValid = true;
    testId = rs.getInt("test_id");
}
rs.close();
st.close();
if (!loginValid) {
    cn.close();
    response.sendRedirect("dashboard.jsp");
    return;
}

PreparedStatement stTest = cn.prepareStatement("SELECT name, final FROM test WHERE id = ?;");
stTest.setInt(1, testId);
ResultSet rsTest = stTest.executeQuery();
rsTest.next();
String name = rsTest.getString("name");
boolean isFinal = rsTest.getBoolean("final");
rsTest.close();
stTest.close();

LinkedList<Question> questionPoints = ResultProcessor.getDetailedResults(attemptId, cn);
float pointsTaken = 0;
int pointsTotal = 0;
for (Question q : questionPoints) {
    pointsTaken += q.getPointsTaken();
    pointsTotal++;
}
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати тесту <%= name %></title>
    </head>
    <body>
        <a href="dashboard.jsp">повернутись назад</a><br/>
	Ваш результат - <%= pointsTaken %>/<%= pointsTotal %><br/>
	<%if (!isFinal) {%>
	<table>
	    <tr>
		<th>Питання</th>
		<th>Відповіді</th>
		<th>Бали</th>
		<th>Коментар</th>
	    </tr>
	    <%
	    for (Question q : questionPoints) {
		String controlType = (q.isMultiSelect() ? "checkbox" : "radio");
    %>
	    <tr>
		<td width="30%">
		    <%= q.getText() %>
		</td>
		<td width="40%">
		    <ul style="list-style-type: none;">
			<% for (Answer a : q.getAnswers()) { %>
			<li <%= a.isCorrect() ? "style=\"color: green;\"" : "" %>>
			    <input type="<%= controlType %>" disabled <%= a.isSelected() ? "checked" : "" %>/> <%= a.getText() %>
			</li>
			<% } %>
		    </ul>
		</td>
		<td style="text-align: center;">
		    <%= q.getPointsTaken() %>
		</td>
		<td>
		    <%= q.getComment() != null ? q.getComment() : "" %>
		</td>
	    </tr>	    
	    <%}%>	    
	</table>	
	<%}%>
    </body>
</html>


<%
if (cn != null)
    cn.close();
%>