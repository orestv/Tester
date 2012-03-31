<%-- 
    Document   : admin_dashboard
    Created on : Mar 3, 2012, 2:49:36 PM
    Author     : seth
--%>

<%@page import="Data.Test"%>
<%@page import="Data.Topic"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="Data.Admin" id="admin" scope="session"/>
<jsp:setProperty name="admin" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (!admin.isLoggedIn()) {
	response.sendRedirect("admin.jsp");
	return;
    }
    Connection cn = dbutils.DBUtils.conn();
    Statement st = cn.createStatement();
    ResultSet rs = st.executeQuery("SELECT t.id, t.name, "
	    + "COUNT(q.id) AS question_count "
	    + "FROM topic t "
	    + "LEFT OUTER JOIN question q ON t.id = q.topic_id "
	    + "GROUP BY t.id, t.name;");
    LinkedList<Topic> topics = new LinkedList<Topic>();
    while (rs.next()) {
	int id = rs.getInt("id");
	String name = rs.getString("name");
	int questionCount = rs.getInt("question_count");
	topics.add(new Topic(id, name, questionCount));
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            table td {
                text-align: center;
            }
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Адміністрування</title>
	<script>
	    function testTopicCheckboxChanged(sender, topicQuestionCount) {
		var questionCountInput = document.getElementById('questionCount');
		var questionCountSpan = document.getElementById('spQuestionCount');
		var questionCount = new Number(questionCountInput.getAttribute('max'));
		if (sender.checked)
		    questionCount += topicQuestionCount;
		else
		    questionCount -= topicQuestionCount;
		questionCountInput.setAttribute('max', questionCount);
		questionCountSpan.textContent = questionCount;
		if (Number(questionCountInput.value) > questionCount)
		    questionCountInput.value = questionCount;
	    }
	</script>
	<link rel="stylesheet" href="styles.css"/>
    </head>
    <body>
        <div id="topicList" style="border-style: 1px solid black; float: left;">
	    <h2>Теми</h2>
            <table>
                <tr>
                    <th>Назва</th>
                    <th>Кількість запитань</th>
                    <th>Дії</th>
                </tr>                
		<%
		    for (Topic t : topics) {
		%>
                <tr>
                    <td><%=t.getName()%></td>
                    <td><%=t.getQuestionCount()%>
                        <a href="question_list.jsp?topic=<%=t.getId()%>"><img src="images/modify.ico" width="16"/></a>
                        <a href="question_upload.jsp?topic=<%=t.getId()%>"><img src="images/upload.ico" width="16"/></a>
                    </td>
                    <td>                        
                        <a href><img src="images/modify.ico" width="16"/></a>
                        <a onclick="return confirm('Ви впевнені, що бажаєте видалити цю тему?');" href="TopicDelete?id=<%=t.getId()%>"><img src="images/delete.ico" width="16"/></a>
                    </td>
                </tr>
		<%}%>            
		<tr>
		    <td colspan="3">
			<form action="TopicAdd" method="POST">
			    Назва: <input type="text" name="name"/>
			    <input type="submit" value="Додати тему"/>
			</form>
		    </td>
		</tr>
            </table>
        </div>
	<div style="float: left; margin-left: 15px;">
	    <h2>Створити тест</h2>		
	    <form action="TestAdd" method="POST">
		Назва тесту: <input type="text" name="name" value="Тест"/><br/>
		<input type="radio" name="type" value="trial"/> Пробний <br/>
		<input type="radio" name="type" value="final"/> Контрольний<br/>
		<h3>Теми:</h3>
		<ul style="list-style-type: none;">
		    <%
			for (Topic t : topics) {
		    %>
		    <li><input type="checkbox" name="topics" onchange="testTopicCheckboxChanged(this, <%=t.getQuestionCount()%>);" value="<%=t.getId()%>"/> <%=t.getName()%> (<%=t.getQuestionCount()%> питань) </li>
			<%
			    }
			%>
		</ul>
		Кількість питань: <input id="questionCount" type="number" name="questionCount" value="0" min="0" max="0"/> (до <span id="spQuestionCount">0</span>)<br/>
		<input type="submit" value="Створити тест"/>
	    </form>
	</div>
	<%
	    LinkedList<Test> tests = new LinkedList<Test>();
	    Statement stTests = cn.createStatement();
	    ResultSet rsTests = stTests.executeQuery("SELECT test.id AS test_id, "
		    + "test.name AS test_name, test.final AS final, "
		    + "topic.id AS topic_id, topic.name AS topic_name "
		    + "FROM test "
		    + "LEFT OUTER JOIN test_topics tt ON test.id = tt.test_id "
		    + "LEFT OUTER JOIN topic ON topic.id = tt.topic_id;");

	    int tid_old = -1;
	    Test test = null;
	    while (rsTests.next()) {
		int testId = rsTests.getInt("test_id");
		if (tid_old != testId) {
		    if (test != null) {
			tests.add(test);
		    }
		    String testName = rsTests.getString("test_name");
		    boolean isFinal = rsTests.getBoolean("final");
		    test = new Test(testId, testName, isFinal);
		    tid_old = testId;
		}
		String topicName = rsTests.getString("topic_name");
		if (topicName != null) {
		    int topicId = rsTests.getInt("topic_id");
		    test.getTopics().add(new Topic(topicId, topicName));
		}
	    }
	    if (test != null) {
		tests.add(test);
	    }

	    stTests.close();
	    rsTests.close();
	%>
	<div style="float: left; margin-left: 15px">
	    <h2>Тести</h2>
	    <table>
		<tr>
		    <th>Назва</th>
		    <th>Тип</th>
		    <th>Теми</th>
		</tr>
		<%
		    for (Test t : tests) {%>
		<tr>
		    <td>
			<a href="results_test.jsp?id=<%= t.getId()%>"><%= t.getName()%></a>
		    </td>
		    <td>
			<%= t.isFinal() ? "Контрольний" : "Пробний" %>
		    </td>
		    <td>
			<ul>
			    <% for (Topic topic : t.getTopics()) {%>
			    <li><%= topic.getName()%> </li>
			    <% }%>
			</ul>
		    </td>
		</tr>
		<%
		    }
		%>
	    </table>
	</div>
	<%
	    Statement stStudents = cn.createStatement();
	    ResultSet rsStudents = stStudents.executeQuery("SELECT id, firstname, lastname "
		    + "FROM student ORDER BY lastname, firstname;");
	%>
	<div style="float: left; margin-left: 15px;">
	    <h2>Студенти</h2>
	    <form action="StudentAdd" method="POST">
		<table>
		    <tr>
			<th>
			    Прізвище
			</th>
			<th>
			    Ім’я
			</th>
			<th>
			    Дії
			</th>
		    </tr>
		    <%
			while (rsStudents.next()) {
		    %>
		    <tr>
			<td>
			    <%= rsStudents.getString("lastname")%>
			</td>
			<td>
			    <%= rsStudents.getString("firstname")%> 
			</td>
			<td>
			    <a href="StudentDelete?id=<%= rsStudents.getInt("id")%>" onclick="return alert('Ви впевнені, що хочете видалити цього студента та його результати тестувань?')">
				<img src="images/delete.ico"/>
			    </a>
			</td>
		    </tr>
		    <% }%>
		    <tr>
			<td>
			    <input type="text" name="lastName" required="true"/> 
			</td>
			<td>
			    <input type="text" name="firstName" required="true"/>
			</td>
			<td>
			    <input type="submit" value="Додати"/>
			</td>
		    </tr>
		</table>
	    </form>
	</div>
	<%
	    rsStudents.close();
	    stStudents.close();
	%>
    </body>
</html>
<%
    if (cn != null) {
	cn.close();
    }
%>