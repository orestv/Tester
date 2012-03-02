<%-- 
    Document   : test
    Created on : Mar 2, 2012, 9:43:39 PM
    Author     : seth
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="dbutils.DBUtils"%>
<jsp:useBean class="processors.User" scope="session" id="user"/>
<jsp:useBean class="processors.Question" scope="session" id="question"/>
<jsp:useBean class="processors.Test" scope="session" id="test"/>
<jsp:setProperty name="user" property="*"/>
<jsp:setProperty name="question" property="*"/>
<jsp:setProperty name="test" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
int testId = Integer.parseInt(request.getParameter("t"));
question.setTestId(testId);
Connection cn = DBUtils.conn();
PreparedStatement st = cn.prepareStatement("SELECT question_id FROM student_question "
        + "WHERE test_id = ? AND (student_id = ? OR ISNULL(student_id) = 1)"
        + "ORDER BY \"order\";");
st.setInt(1, testId);
st.setInt(2, user.getId());
ResultSet rs = st.executeQuery();
test.clear();
while (rs.next())
    test.getQuestionIds().add(rs.getInt("question_id"));
question.setId(test.getCurrentQuestionId());
if (rs != null)
    rs.close();
if (st != null)
    st.close();
if (cn != null)
    cn.close();
response.sendRedirect("question.jsp");
%>