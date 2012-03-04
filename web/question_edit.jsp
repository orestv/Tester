<%-- 
    Document   : question_edit
    Created on : Mar 4, 2012, 10:00:17 PM
    Author     : seth
--%>

<%@page import="processors.Question.Answer"%>
<%@page import="processors.Question"%>
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
Question question = new Question(questionId);
question.fill();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Редагування питання</title>
	<script>
	    function addAnswer() {
		var liAdd = document.getElementById('liAdd');
		var ul = document.getElementById('answers');
		var input = document.createElement('input');
		input.setAttribute('type', 'text');
		input.setAttribute('name', 'ans_new');
		var li = document.createElement("li");
		li.appendChild(input);
		ul.insertBefore(li, liAdd);
	    }
	</script>
    </head>
    <body>
        <form action="QuestionEdit" method="post">
	    <table>
		<tr>
		    <td>
			Текст
		    </td>
		    <td>
			<textarea cols="50" rows="5" name="questionText"><%=question.getText()%></textarea>
		    </td>
		</tr>
		<tr>
		    <td>
			Коментар
		    </td>
		    <td>
			<textarea cols="50" rows="5" name="questionComment"><%=question.getComment()%></textarea>
		    </td>
		</tr>
		<tr>
		    <td>
			Варіанти відповіді
		    </td>
		    <td>
			<ul id="answers">
			    <%
			    for (Answer a : question.getAnswers()) {
				%>
				<li>
				    <input type="text" name="ans_<%=a.getId()%>" value="<%=a.getText()%>"/>
				    <a href><img src="images/delete.ico" width="16"/></a>
				</li>
				<%
			    }
			    %>
			    <li id="liAdd">
				<a href="javascript:addAnswer();"><img src="images/add.ico" width="16"/></a>
			    </li>
			</ul>
			
		    </td>
		</tr>
	    </table>    
	    <input type="hidden" name="questionId" value="<%=question.getId()%>"/>
	    <input type="submit" value="Зберегти"/>
	</form>
    </body>
</html>
