<%-- 
    Document   : firstPage
    Created on : Mar 1, 2012, 10:02:41 PM
    Author     : seth
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<jsp:useBean id="login" scope="session" class="processors.LoginData"/>
<jsp:setProperty name="login" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String url = "jdbc:mysql://localhost/tests";
String user = "application";
String password = "medicine";

Connection conn = null;
Statement stat = null;
ResultSet rs = null;

String questionList = null;

try {
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection(url, user, password);
    stat = conn.createStatement();
    rs = stat.executeQuery("SELECT id, firstname FROM student;");
    StringBuilder sb = new StringBuilder();
    while (rs.next()) {
        sb.append(rs.getString("firstname")).append("</br>");
    }
    questionList = sb.toString();
} catch (Exception ex) {
    
} finally {
    if (rs != null)
        rs.close();
    if (stat != null)
        stat.close();
    if (conn != null)
        conn.close();
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello, <%= login.getUserId()%>!</h1>
        <%=questionList%>
    </body>
</html>
