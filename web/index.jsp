<jsp:useBean id="login" scope="session" class="processors.LoginData"/>
<jsp:useBean scope="session" id="user" class="processors.User"/>
<jsp:setProperty name="user" property="*"/>
<jsp:setProperty name="login" property="*"/>
<html>
    <head>
        Login
    </head>
    <body>
        <form method="GET" action="dashboard.jsp">
            UID: <input type="text" name="u" value="567948122aa5d4c7c8eb8b8c2c7af85cf6537dde"/>          
            <input type="submit"/>
        </form>
    </body>    
</html>