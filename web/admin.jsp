<%-- 
    Document   : admin
    Created on : Mar 3, 2012, 2:49:17 PM
    Author     : seth
--%>
<%@page import="Data.Admin"%>
<jsp:useBean class="Data.Admin" id="admin" scope="session"/>
<jsp:setProperty name="admin" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String password = request.getParameter("pwd");
if (Admin.isPasswordValid(password)){
    admin.setLoggedIn(true);
    response.sendRedirect("admin_dashboard.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Вхід адміністратора</title>
    </head>
    <body>
	<div style="width: 30%;margin: auto;margin-top: 15%;">
	    <form action="admin.jsp" method="POST">
		Введіть пароль: <input type="password" name="pwd" autofocus/>
		<input type="submit" value="Вхід"/>
	    </form>
	</div>
    </body>
</html>
