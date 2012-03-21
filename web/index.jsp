<%-- 
    Document   : index
    Created on : Mar 21, 2012, 10:57:15 PM
    Author     : seth
--%>

<jsp:useBean id="login" scope="session" class="Data.LoginData"/>
<jsp:useBean scope="session" id="user" class="Data.User"/>
<jsp:setProperty name="user" property="*"/>
<jsp:setProperty name="login" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Вхід</title>
    </head>
    <body>
        <form action="LoginHandler" method="POST">
	    <table>
		<tr>
		    <td>Ім’я:</td>
		    <td><input type="text" name="firstname"/></td>
		</tr>
		<tr>
		    <td>Прізвище:</td>
		    <td><input type="text" name="lastname"/></td>
		</tr>
		<tr>
		    <td colspan="2"><input type="submit"/></td>
		</tr>
	</form>
    </body>
</html>