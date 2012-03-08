<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="Data.Question"%>
<jsp:useBean class="Data.User" id="user" scope="session"/>
<jsp:useBean class="Data.Question" id="question" scope="session"/>
<jsp:useBean class="Data.Test" scope="session" id="test"/>
<jsp:useBean class="Data.TestAttempt" scope="session" id="testAttempt"/>
<jsp:setProperty name="user" property="*"/>
<jsp:setProperty name="question" property="*"/>
<jsp:setProperty name="test" property="*"/>
<jsp:setProperty name="testAttempt" property="*"/>
<%
String[] answers = request.getParameterValues("answer");
if (answers == null) {
    response.sendRedirect("question.jsp");
    return;
}
Connection cn = dbutils.DBUtils.conn();
for (String ansId : answers) {
    PreparedStatement st = cn.prepareStatement("INSERT INTO student_answer "
            + "(student_id, test_attempt_id, question_id, answer_id) "
            + "VALUES (?, ?, ?, ?);");
    st.setInt(1, user.getId());
    st.setInt(2, testAttempt.getId());
    st.setInt(3, question.getId());
    st.setInt(4, Integer.parseInt(ansId));
    st.execute();
    st.close();
}
if (cn != null)
    cn.close();
if (!test.isLast()) {
    test.moveNext();
    question.setId(test.getCurrentQuestionId());
    response.sendRedirect("question.jsp");
} else {
    response.sendRedirect("finish.jsp");
}
%>