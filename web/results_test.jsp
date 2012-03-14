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
    
    
    cn.close();
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
