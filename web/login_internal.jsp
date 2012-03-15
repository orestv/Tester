<%-- 
    Document   : login_internal
    Created on : Mar 15, 2012, 9:47:32 PM
    Author     : seth
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
Connection cn = dbutils.DBUtils.conn();
Statement st = cn.createStatement();
ResultSet rs = st.executeQuery("SELECT firstname, lastname, email, hash FROM student;");
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Вхід під іменем студента</title>
    </head>
    <body>
        <table>
	    <%
	    while (rs.next()) {
	    %>
	    <tr>
		<td>
		    <%= rs.getString("firstname") + " " + rs.getString("lastname") %>
		</td>
		<td>
		    <%= rs.getString("email") %>
		</td>
		<td>
		    <a href="dashboard.jsp?u=<%= rs.getString("hash") %>">Увійти</a>
		</td>
	    </tr>
	    <% } %>
	</table>
    </body>
</html>

<%
rs.close();
st.close();
cn.close();
%>