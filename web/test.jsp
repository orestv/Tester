<%-- 
    Document   : test
    Created on : Mar 2, 2012, 9:43:39 PM
    Author     : seth
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="dbutils.DBUtils"%>
<jsp:useBean class="Data.User" scope="session" id="user"/>
<jsp:useBean class="Data.Question" scope="session" id="question"/>
<jsp:useBean class="Data.Test" scope="session" id="test"/>
<jsp:setProperty name="user" property="*"/>
<jsp:setProperty name="question" property="*"/>
<jsp:setProperty name="test" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
int testId = Integer.parseInt(request.getParameter("t"));
Connection cn = DBUtils.conn();
String sQuery = "SELECT question_id FROM question_sequence qs "
        + "INNER JOIN question_sequence_questions qsq "
        + "ON qs.id = qsq.sequence_id "
        + "WHERE qs.test_id = ? AND (qs.student_id = ? OR ISNULL(qs.student_id) = 1) "
        + "ORDER BY \"qsq.order\" ASC;";
PreparedStatement st = cn.prepareStatement(sQuery);
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