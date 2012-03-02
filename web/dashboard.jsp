<%-- 
    Document   : dashboard
    Created on : Mar 2, 2012, 8:46:48 PM
    Author     : seth
--%>
<%@page import="processors.User"%>
<jsp:useBean scope="session" id="user" class="processors.User"/>
<jsp:setProperty name="user" property="*"/>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
boolean userNotFound = true;
String userHash = request.getParameter("u");
Connection cn = dbutils.DBUtils.conn();
PreparedStatement st = cn.prepareStatement("SELECT id, firstname, lastname, email "
        + "FROM student WHERE hash = ?");
st.setString(1, userHash);
ResultSet rs = st.executeQuery();
if (rs.next()) {
    int id = rs.getInt("id");
    String firstname = rs.getString("firstname");
    String lastname = rs.getString("lastname");
    String email = rs.getString("email");
    user.setId(id);
    user.setFirstname(firstname);
    user.setLastname(lastname);
    user.setEmail(email);
    userNotFound = false;
}
if (rs != null)
    rs.close();
if (st != null)
    st.close();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
    </head>
    <body>
    <%if (!userNotFound) {%>
        <h1>Доброго дня, <%=user.getFirstname()%>!</h1>
        <%
        st = cn.prepareStatement("SELECT id, topic FROM test WHERE started = 1");
        rs = st.executeQuery();
        boolean testsAvailable = false;
        %>
        Доступні наступні тести:<ul><%            
        while (rs.next()) {
            testsAvailable = true;
            %>
            <li><a href="test.jsp?t=<%=rs.getInt("id")%>"><%=rs.getString("topic")%></a></li>
            <%
        }
        %>
        </ul>
    <%} else {%>
        Не вдалось знайти користувача. Будь ласка, переконайтесь у правильності посилання, використаного для входу на сторінку.
    <%}%>
    </body>
</html>
<%
if (cn != null)
    cn.close();
%>