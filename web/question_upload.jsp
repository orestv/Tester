<%-- 
    Document   : question_upload
    Created on : Mar 3, 2012, 3:37:38 PM
    Author     : seth
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
int topicId = Integer.parseInt(request.getParameter("topic"));
Connection cn = dbutils.DBUtils.conn();
PreparedStatement st = cn.prepareStatement("SELECT name FROM topic WHERE id = ?");
st.setInt(1, topicId);
ResultSet rs = st.executeQuery();
boolean notFound = false;
String topicName = null;
if (rs.next()) 
    topicName = rs.getString("name");
else
    notFound = true;
rs.close();
st.close();
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Завантаження питань</title>
    </head>
    <body>
        <h1>Завантаження питань до теми <%=topicName%></h1>
        <form action="QuestionsUpload" enctype="multipart/form-data" method="post">
            <input type="file"/>
            <input type="submit"/>
        </form>
    </body>
</html>
<%
if (cn != null)
    cn.close();
%>