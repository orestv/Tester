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
			+ "topic.name AS topic_name FROM test "
			+ "INNER JOIN test_topics tt ON test.id = tt.test_id "
			+ "INNER JOIN topic ON tt.topic_id = topic.id");
		ResultSet rs = st.executeQuery();
		boolean testsAvailable = false;
	    %>
	    <h2>Доступні тести:</h2><ul><%
		while (rs.next()) {
		    testsAvailable = true;
		%>
		<li><a href="test.jsp?t=<%=rs.getInt("id")%>"><%=rs.getString("test_name")%></a></li>
		<%
		    }
		    st.close();
		    rs.close();
		%>
	    </ul>
	</div>
	<div id="completedTests" style="float: left">
	    <h2>Завершені тести: </h2>
	    <ul>
		<%
		    PreparedStatement stFinished = cn.prepareStatement("SELECT t.name AS testname, "
			    + "a.id AS attempt_id, a.start AS start, a.end AS end "
			    + "FROM test_attempt a INNER JOIN test t ON a.test_id = t.id "
			    + "WHERE a.student_id = ? AND a.end IS NOT NULL;");
		    stFinished.setInt(1, user.getId());
		    rs = stFinished.executeQuery();
		    while (rs.next()) {
		%>
		<li><%=rs.getString("testname")%> (<%= DBUtils.format(rs.getTimestamp("start")) %> - <%= DBUtils.format(rs.getTimestamp("end")) %>)
		    <a href="results.jsp?id=<%=rs.getInt("attempt_id")%>">переглянути результат</a></li>
		<%
		    }
		    rs.close();
		    stFinished.close();
		%>
	    </ul>
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