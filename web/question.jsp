<%-- 
    Document   : question
    Created on : Mar 2, 2012, 10:01:12 PM
    Author     : seth
--%>
<%@page import="Data.Question"%>
<jsp:useBean class="Data.User" id="user" scope="session"/>
<jsp:useBean class="Data.Question" id="question" scope="session"/>
<jsp:useBean class="Data.Test" scope="session" id="test"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String controlType = question.isMultiChoice() ? "checkbox" : "radio";
question.fill();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Запитання</title>
    </head>
    <body>
        <%=question.getText()%>
        <form action="process.jsp" method="POST">
        <ul>
            <%
            for (Question.Answer answer : question.getAnswers()) {
            %>
            <li>
                <input type="<%=controlType%>" name="answer" value="<%=answer.getId()%>"/><%=answer.getText()%>
            </li>
            <%
            }
        %>
        </ul>
        <input type="submit" value="<%= test.isLast() ? "Finish" : "Next >>"%>"/>
        </form>
    </body>
</html>
