<%-- 
    Document   : finish
    Created on : Mar 2, 2012, 11:26:14 PM
    Author     : seth
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="Data.User" scope="session" id="user"/>
<jsp:useBean class="Data.TestAttempt" scope="session" id="testAttempt"/>
<jsp:setProperty name="testAttempt" property="*"/>
<jsp:setProperty name="user" property="*"/>
<%
Connection cn = dbutils.DBUtils.conn();
testAttempt.finish(cn);

PreparedStatement st = cn.prepareStatement("SELECT final, test.id AS test_id FROM test "
	+ "INNER JOIN test_attempt ta ON ta.test_id = test.id WHERE ta.id = ?;");
st.setInt(1, testAttempt.getId());
ResultSet rsFinal = st.executeQuery();
rsFinal.next();
boolean isFinal = rsFinal.getBoolean("final");

String redirectUrl = isFinal ? "dashboard.jsp" : String.format("results.jsp?id=%d", testAttempt.getId());

cn.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Завершено</title>
	<script>
	    function scheduleRedirect() {
		setTimeout(performRedirect, 3000);
	    }
	    function performRedirect() {
		window.location.href = '<%= redirectUrl %>';
	    }
	</script>
	<link rel="stylesheet" href="styles.css"/>
    </head>
    <body onload="scheduleRedirect();">
        <h1>Тест завершено!</h1>
	<center>Ви будете автоматично скеровані на наступну сторінку через декілька секунд...</center>
    </body>
</html>
