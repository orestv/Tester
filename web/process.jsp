<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="processors.Question"%>
<jsp:useBean class="processors.User" id="user" scope="session"/>
<jsp:useBean class="processors.Question" id="question" scope="session"/>
<jsp:useBean class="processors.Test" scope="session" id="test"/>
<jsp:setProperty name="user" property="*"/>
<jsp:setProperty name="question" property="*"/>
<jsp:setProperty name="test" property="*"/>
<%
String[] answers = request.getParameterValues("answer");
if (answers == null) {
    response.sendRedirect("question.jsp");
    return;
}
Connection cn = dbutils.DBUtils.conn();
for (String ansId : answers) {
    PreparedStatement st = cn.prepareStatement("INSERT INTO student_answer "
            + "(student_id, test_id, question_id, answer_id) "
            + "VALUES (?, ?, ?, ?);");
    st.setInt(1, user.getId());
    st.setInt(2, question.getTestId());
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