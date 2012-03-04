<%-- 
    Document   : question_edit
    Created on : Mar 4, 2012, 10:00:17 PM
    Author     : seth
--%>

<jsp:useBean class="processors.Admin" id="admin" scope="session"/>
<jsp:setProperty name="admin" property="*"/>
<%
if (!admin.isLoggedIn()) {
    response.sendRedirect("admin.jsp");
    return;
}
String sQuestionId = request.getParameter("qid");
int questionId = -1;
if (sQuestionId != null)
    questionId = Integer.parseInt(sQuestionId);
if (questionId == -1) {
    response.sendRedirect("question_list.jsp");
    return;
}
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
