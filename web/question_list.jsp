<%-- 
    Document   : question_list
    Created on : Mar 4, 2012, 3:33:28 PM
    Author     : seth
--%>
<%@page import="processors.Question"%>
<%@page import="java.util.LinkedList"%>
<%@page import="processors.Question.Answer"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="processors.Admin" id="admin" scope="session"/>
<jsp:setProperty name="admin" property="*"/>
<%
if (!admin.isLoggedIn()) {
    response.sendRedirect("admin.jsp");
    return;
}
String topic = request.getParameter("topic");
int topicId = -1;
if (topic != null)
    topicId = Integer.parseInt(topic);
Connection cn = dbutils.DBUtils.conn();
String title = "Список питань";
if (topicId != -1) {
    PreparedStatement st = cn.prepareStatement("SELECT name FROM topic WHERE id = ?");
    st.setInt(1, topicId);
    ResultSet rs = st.executeQuery();
    if (rs.next())
	title += " до теми " + rs.getString("name");
    rs.close();
    st.close();
}
String sql = "SELECT q.id AS question_id, q.text AS question_text, q.comment, "
	+ "a.id AS answer_id, a.text AS answer_text, a.correct "
	+ "FROM question q LEFT OUTER JOIN answer a ON q.id = a.question_id ";
if (topicId != -1)
    sql += "WHERE q.topic_id = ?;";
PreparedStatement st = cn.prepareStatement(sql);
if (topicId != -1)
    st.setInt(1, topicId);
ResultSet rs = st.executeQuery();
LinkedList<Question> questions = new LinkedList<Question>();
Question q = null;
int qid_old = -1;
while (rs.next()) {
    int qid = rs.getInt("question_id");
    if (qid_old != qid || q == null) {
	q = new Question(qid);
	q.setText(rs.getString("question_text"));
	q.setComment(rs.getString("comment"));
	questions.add(q);
	qid_old = qid;
    }    
    Question.Answer ans = new Answer(rs.getInt("answer_id"), rs.getString("answer_text"), rs.getBoolean("correct"));
    q.getAnswers().add(ans);
}
rs.close();
st.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Питання</title>
	<style>
	    table {
		font-size: 12px;
		border: 1px solid black;
	    }
	</style>
    </head>
    <body>
	<a href="admin_dashboard.jsp">на головну</a>
        <h1><%=title%></h1>
	    <table>
	<%
	for (Question question : questions) {
	    %>
		<tr>
		    <td width="50%">
			<h3><%=question.getText()%></h3>
		    </td>
		    <td>
			<ul>
			<%
			for (Answer a : question.getAnswers()) {
			    %>
			    <li <%=a.isCorrect() ? "style=\"color: green;\"" : ""%>><%=a.getText()%></li>
			    <%
			}
			%>
			</ul>
		    </td>
		    <td>
			<%if (question.getComment() != null && !question.getComment().isEmpty()) {%>
			<i>(<%=question.getComment()%>)</i>
			<%}%>
		    </td>
		    <td>
			<a href="question_edit.jsp?id=<%=question.getId()%>"><img src="images/modify.ico"/></a>
			<a href="QuestionDelete?id=<%=question.getId()%>"><img src="images/delete.ico"/></a>
		    </td>	
		</tr>
	    <%
	}
	%>
	    </table>
    </body>
</html>

<%
cn.close();
%>