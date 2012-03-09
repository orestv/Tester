<%-- 
    Document   : results
    Created on : Mar 8, 2012, 10:51:52 PM
    Author     : seth
--%>

<%@page import="Data.Question.Answer"%>
<%@page import="Data.Question"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="Data.User" scope="session" id="user"/>
<%
int attemptId = Integer.parseInt(request.getParameter("id"));
int testId = -1;
Connection cn = dbutils.DBUtils.conn();
PreparedStatement st = cn.prepareStatement("SELECT test_id FROM test_attempt "
	+ "WHERE id = ? AND student_id = ?");
st.setInt(1, attemptId);
st.setInt(2, user.getId());
ResultSet rs = st.executeQuery();
boolean loginValid = false;
if (rs.next()) {
    loginValid = true;
    testId = rs.getInt("test_id");
}
rs.close();
st.close();
if (!loginValid) {
    cn.close();
    response.sendRedirect("dashboard.jsp");
    return;
}

PreparedStatement stTest = cn.prepareStatement("SELECT name, final FROM test WHERE id = ?;");
stTest.setInt(1, testId);
ResultSet rsTest = stTest.executeQuery();
rsTest.next();
String name = rsTest.getString("name");
boolean isFinal = rsTest.getBoolean("final");
rsTest.close();
stTest.close();

PreparedStatement stTotals = cn.prepareStatement("SELECT SUM(points) AS taken FROM "
	+ "(SELECT q.id, q.text, "
	+ "CASE WHEN q.multiselect =1 THEN "
	    + "SUM(CASE WHEN (a.correct=1 AND sa.id IS NOT NULL) "
		+ "OR ( a.correct =0 AND sa.id IS NULL ) "
		+ "THEN 1 ELSE 0 END) / COUNT( a.id )  "
		+ "ELSE SUM(CASE WHEN a.correct=1 "
		    + "AND sa.id IS NOT NULL THEN 1 ELSE 0 END) END "
	    + "AS points "
	+ "FROM student_answer sa "
	+ "RIGHT OUTER JOIN answer a ON sa.answer_id = a.id "
	+ "AND sa.test_attempt_id = ? "
	+ "INNER JOIN question q ON a.question_id = q.id "
	+ "GROUP BY q.id, q.text) "
    + "pts");
stTotals.setInt(1, attemptId);
ResultSet rsTotals = stTotals.executeQuery();
rsTotals.next();
float pointsTaken = rsTotals.getFloat("taken");
rsTotals.close();
stTotals.close();
PreparedStatement stQuestionCount = cn.prepareStatement("SELECT COUNT(DISTINCT a.question_id) AS questionCount FROM test_attempt ta "
	+ "INNER JOIN student_answer sa ON sa.test_attempt_id = ta.id "
	+ "INNER JOIN answer a ON sa.answer_id = a.id "
	+ "WHERE ta.id = ?;");
stQuestionCount.setInt(1, attemptId);
ResultSet rsQuestionCount = stQuestionCount.executeQuery();
rsQuestionCount.next();
int pointsTotal = rsQuestionCount.getInt("questionCount");
rsQuestionCount.close();
stQuestionCount.close();
HashMap<Question, Float> questionPoints = null;
if (!isFinal) {
    questionPoints = new HashMap<Question, Float>();
    PreparedStatement stDetailedResults = cn.prepareStatement("SELECT q.id AS question_id, q.text AS question_text, "
	    + "q.comment AS question_comment, a.id AS answer_id, a.text AS answer_text, q.multiselect AS multiselect, a.correct AS correct, "
	    + "CASE WHEN sa.id IS NULL THEN 0 ELSE 1 END AS picked "
	    + "FROM student_answer sa "
	    + "RIGHT OUTER JOIN answer a ON sa.answer_id = a.id "
	    + "AND sa.test_attempt_id = ? "
	    + "INNER JOIN question q ON a.question_id = q.id "
	    + "ORDER BY q.id DESC;");
    stDetailedResults.setInt(1, attemptId);
    ResultSet rsDetailedResults = stDetailedResults.executeQuery();
    int qid_old = -1;
    float points = 0;
    int answers = 0;
    Question question = null;
    while (rsDetailedResults.next()) {
	int qid = rsDetailedResults.getInt("question_id");
	if (qid_old != qid) {
	    if (question != null)
		questionPoints.put(question, new Float(question.isMultiChoice() ? points/answers : points));
	    points = 0;
	    answers = 0;
	    String qtext = rsDetailedResults.getString("question_text");
	    String qcomment = rsDetailedResults.getString("question_comment");
	    boolean multiselect = rsDetailedResults.getBoolean("multiselect");
	    question = new Question(qid, qtext, qcomment, multiselect);
	    qid_old = qid;
	}
	int aid = rsDetailedResults.getInt("answer_id");
	String atext = rsDetailedResults.getString("answer_text");
	boolean correct = rsDetailedResults.getBoolean("correct");
	boolean selected = rsDetailedResults.getBoolean("picked");
	if ((selected && correct) || (question.isMultiChoice() && selected == correct))
	    points++;
	answers++;
	Question.Answer ans = new Question.Answer(aid, atext, correct, selected);
	question.getAnswers().add(ans);
    }    
    rsDetailedResults.close();
    stDetailedResults.close();
}


%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Результати тесту <%=name%></title>
    </head>
    <body>
        <a href="dashboard.jsp">повернутись назад</a><br/>
	Ваш результат - <%=pointsTaken%>/<%=pointsTotal%>
    </body>
</html>


<%
if (cn != null)
    cn.close();
%>