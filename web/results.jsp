<%-- 
    Document   : results
    Created on : Mar 8, 2012, 10:51:52 PM
    Author     : seth
--%>

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

PreparedStatement stTotals = cn.prepareStatement("SELECT SUM(points) AS taken FROM "
	+ "(SELECT q.id, q.text, "
	+ "CASE WHEN q.multiselect =1 THEN "
	    + "SUM(CASE WHEN (a.correct=1 AND sa.id IS NOT NULL) "
		+ "OR ( a.correct =0 AND sa.id IS NULL ) "
		+ "THEN 1 ELSE 0 END) / COUNT( a.id )  "
		+ "ELSE SUM(CASE WHEN a.correct=1 "
		    + "AND sa.id IS NOT NULL THEN 1 ELSE 0 END) END "
	    + "AS points "
	+ "FROM student_answer sa "
	+ "RIGHT OUTER JOIN answer a ON sa.answer_id = a.id "
	+ "AND sa.test_attempt_id = ? "
	+ "INNER JOIN question q ON a.question_id = q.id "
	+ "GROUP BY q.id, q.text) "
    + "pts");
stTotals.setInt(1, attemptId);
ResultSet rsTotals = stTotals.executeQuery();
rsTotals.next();
float pointsTaken = rsTotals.getFloat("taken");
rsTotals.close();
stTotals.close();
PreparedStatement stQuestionCount = cn.prepareStatement("SELECT COUNT(DISTINCT a.question_id) AS questionCount FROM test_attempt ta "
	+ "INNER JOIN student_answer sa ON sa.test_attempt_id = ta.id "
	+ "INNER JOIN answer a ON sa.answer_id = a.id "
	+ "WHERE ta.id = ?;");
stQuestionCount.setInt(1, attemptId);
ResultSet rsQuestionCount = stQuestionCount.executeQuery();
rsQuestionCount.next();
int pointsTotal = rsQuestionCount.getInt("questionCount");
rsQuestionCount.close();
stQuestionCount.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати тесту <%=name%></title>
    </head>
    <body>
        <a href="dashboard.jsp">повернутись назад</a><br/>
	Ваш результат - <%=pointsTaken%>/<%=pointsTotal%>
    </body>
</html>


<%
if (cn != null)
    cn.close();
%>