<%-- 
    Document   : finish
    Created on : Mar 2, 2012, 11:26:14 PM
    Author     : seth
--%>

<%@page import="java.sql.Connection"%>
<jsp:useBean class="Data.User" scope="session" id="user"/>
<jsp:useBean class="Data.TestAttempt" scope="session" id="testAttempt"/>
<jsp:setProperty name="testAttempt" property="*"/>
<jsp:setProperty name="user" property="*"/>
<%
Connection cn = dbutils.DBUtils.conn();
testAttempt.finish(cn);
cn.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Завершено</title>
    </head>
    <body>
        <h1>Тест завершено!</h1>
	<a href="dashboard.jsp">Повернутись</a>
    </body>
</html>
