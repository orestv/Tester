<%-- 
    Document   : dashboard
    Created on : Mar 2, 2012, 8:46:48 PM
    Author     : seth
--%>
<%@page import="dbutils.DBUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="Data.User"%>
<jsp:useBean scope="session" id="user" class="Data.User"/>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
    Connection cn = dbutils.DBUtils.conn();
    if (user.getId() == -1) {
	boolean userNotFound = true;
	String userHash = request.getParameter("u");
	PreparedStatement st = cn.prepareStatement("SELECT id, firstname, lastname, email "
		+ "FROM student WHERE hash = ?");
	st.setString(1, userHash);
	ResultSet rs = st.executeQuery();
	if (rs.next()) {
	    int id = rs.getInt("id");
	    String firstname = rs.getString("firstname");
	    String lastname = rs.getString("lastname");
	    String email = rs.getString("email");
	    user.setId(id);
	    user.setFirstname(firstname);
	    user.setLastname(lastname);
	    user.setEmail(email);
	    userNotFound = false;
	}
	if (rs != null) {
	    rs.close();
	}
	if (st != null) {
	    st.close();
	}
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
    </head>
    <body>
	<%if (user.getId() != -1) {%>	
        <h1>Доброго дня, <%=user.getFirstname()%>!</h1>
	<div id="availableTests" style="float:left;">
	    <%
		PreparedStatement st = cn.prepareStatement("SELECT DISTINCT (test.id), test.name AS test_name, "
			+ "MAX(TestResult(ta.id)) AS result, COUNT(DISTINCT qsq.question_id) AS maxResult FROM test "
			+ "LEFT OUTER JOIN test_attempt ta ON ta.test_id = test.id "
			+ "AND ta.student_id = ? "
			+ "INNER JOIN question_sequence qs "
			+ "ON qs.test_id = test.id AND (qs.student_id = ? OR qs.student_id IS NULL) "
			+ "INNER JOIN question_sequence_questions qsq "
			+ "ON qsq.sequence_id = qs.id "
			+ "GROUP BY test.id, qs.id;");
		st.setInt(1, user.getId());
		st.setInt(2, user.getId());
		ResultSet rs = st.executeQuery();
		boolean testsAvailable = false;
	    %>
	    <h2>Доступні тести:</h2>
	    <table>
		<tr>
		    <th>Назва</th>
		    <th>Кращий результат</th>
		</tr>
		<%
		    while (rs.next()) {
			testsAvailable = true;
			float result = rs.getFloat("result");
			int maxResult = rs.getInt("maxResult");
			String sResult = (result != -1 ? String.format("%.2f із %d", result, maxResult) : "N/A");
		%>
		<tr>
		    <td>
			<a href="test.jsp?t=<%=rs.getInt("id")%>"><%=rs.getString("test_name")%></a>
		    </td>
		    <td style="text-align: center;">
			<%= sResult %>			
		    </td>
		</tr>
		    <%
			}
			st.close();
			rs.close();
		    %>
	    </table>
	</div>
	<div id="completedTests" style="float: left; margin-left: 55px;">
	    <h2>Завершені тести: </h2>
	    <table>
		<tr>
		    <th>Тест</th>
		    <th>Час завершення</th>
		    <th>Бали</th>		    
		    <th>Дії</th>
		</tr>
		<%
		    PreparedStatement stFinished = cn.prepareStatement("SELECT ta.id AS attempt_id, t.id AS test_id, "
			    + "t.name AS test_name, ta.start AS start, ta.end AS end, t.final AS final, "
			    + "COUNT(question_id) AS max, SUM(points) AS taken "
			    + "FROM (SELECT ta.id AS test_attempt_id, q.id AS question_id,      "
			    + "CASE WHEN q.multiselect         "
			    + "THEN SUM( CASE WHEN (a.correct = 1 AND sa.id IS NOT NULL)                          "
			    + "OR (a.correct = 0 AND sa.id IS NULL)                         "
			    + "THEN 1 ELSE 0 END) / COUNT(a.id)     "
			    + "ELSE SUM(CASE WHEN a.correct = 1 AND sa.id IS NOT NULL THEN 1 ELSE 0 END)     "
			    + "END AS points     "
			    + "FROM test_attempt ta     "
			    + "INNER JOIN test t ON ta.test_id = t.id     "
			    + "INNER JOIN question_sequence qs  ON qs.test_id = t.id AND (qs.student_id IS NULL OR qs.student_id = ta.student_id)     "
			    + "INNER JOIN question_sequence_questions qsq ON qsq.sequence_id = qs.id     "
			    + "INNER JOIN question q ON qsq.question_id = q.id     "
			    + "INNER JOIN answer a ON a.question_id = q.id     "
			    + "LEFT OUTER JOIN student_answer sa ON sa.test_attempt_id = ta.id AND sa.answer_id = a.id     "
			    + "GROUP BY ta.id, q.id     ORDER BY q.id ) pts "
			    + "INNER JOIN test_attempt ta     ON pts.test_attempt_id = ta.id "
			    + "INNER JOIN test t ON ta.test_id = t.id "
			    + "WHERE ta.student_id = ? AND ta.end IS NOT NULL "
			    + "GROUP BY ta.id");
		    stFinished.setInt(1, user.getId());
		    rs = stFinished.executeQuery();
		    while (rs.next()) {
		%>
		<tr>
		    <td>
			<%= rs.getString("test_name")%>
		    </td>
		    <td>
			<%= DBUtils.format(rs.getTimestamp("end"))%>
		    </td>
		    <td>
			<%= rs.getFloat("taken")%>/<%= rs.getInt("max")%>
		    </td>
		    <td>
			<% if (!rs.getBoolean("final")) {%>
			<a href="results.jsp?id=<%=rs.getInt("attempt_id")%>">Переглянути результат</a><br/>
			<% }%>
			<a href="test.jsp?t=<%= rs.getInt("test_id")%>">Пройти ще раз</a>
		    </td>
		</tr>   
		<%
		    }
		%>
	    </table>
	    <%

		rs.close();
		stFinished.close();
	    %>
	</div>
	<%} else {%>
        Не вдалось знайти користувача. Будь ласка, переконайтесь у правильності посилання, використаного для входу на сторінку.
	<%}%>
    </body>
</html>
<%
    if (cn != null) {
	cn.close();
    }
%>