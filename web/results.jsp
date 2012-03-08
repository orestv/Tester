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
Connection cn = dbutils.DBUtils.conn();
PreparedStatement st = cn.prepareStatement("SELECT CASE WHEN EXISTS("
	+ "SELECT * FROM test_attempt WHERE id = ? AND student_id = ?)"
	+ " THEN 1 ELSE 0 END AS loginValid;");
st.setInt(1, attemptId);
st.setInt(2, user.getId());
ResultSet rs = st.executeQuery();
rs.next();
boolean loginValid = rs.getBoolean("loginValid");
rs.close();
st.close();
if (!loginValid) {
    cn.close();
    response.sendRedirect("dashboard.jsp");
    return;
}

if (cn != null)
    cn.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати тесту</title>
    </head>
    <body>
        <a href="dashboard.jsp">повернутись назад</a>
    </body>
</html>
