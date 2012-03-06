<%-- 
    Document   : admin_dashboard
    Created on : Mar 3, 2012, 2:49:36 PM
    Author     : seth
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean class="processors.Admin" id="admin" scope="session"/>
<jsp:setProperty name="admin" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
if (!admin.isLoggedIn()) {
    response.sendRedirect("admin.jsp");
    return;
}
Connection cn = dbutils.DBUtils.conn();
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
        <title>JSP Page</title>
    </head>
    <body>
        <div id="topicList">
            <table>
                <tr>
                    <th colspan="99">
                        Теми
                    </th>
                </tr>
                <tr>
                    <th>Назва</th>
                    <th>Кількість запитань</th>
                    <th>Дії</th>
                </tr>                
            <%
            Statement st = cn.createStatement();
            ResultSet rs = st.executeQuery("SELECT t.id, t.name, "
                    + "COUNT(q.id) AS question_count "
                    + "FROM topic t "
                    + "LEFT OUTER JOIN question q ON t.id = q.topic_id "
		    + "GROUP BY t.id, t.name;");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int questionCount = rs.getInt("question_count");
            %>
                <tr>
                    <td><%=name%></td>
                    <td><%=questionCount%>
                        <a href="question_list.jsp?topic=<%=id%>"><img src="images/modify.ico" width="16"/></a>
                        <a href="question_upload.jsp?topic=<%=id%>"><img src="images/upload.ico" width="16"/></a>
                    </td>
                    <td>                        
                        <a href><img src="images/modify.ico" width="16"/></a>
                        <a onclick="return confirm('Ви впевнені, що бажаєте видалити цю тему?');" href="TopicDelete?id=<%=id%>"><img src="images/delete.ico" width="16"/></a>
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
    </body>
</html>
<%
if (cn != null)
    cn.close();
%>