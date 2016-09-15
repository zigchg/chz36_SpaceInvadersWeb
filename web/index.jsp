<%-- 
    Document   : index
    Created on : Mar 18, 2016, 9:05:19 PM
    Author     : Chong
--%>

<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion - Login</title>
    </head>

    <body>
        <form id="frmLogin" action="LoginValidator" method="post">
            <label for="txtUserName">User Name: </label>&nbsp;<input type="text" id="txtUserName" name="txtUserName" value="">
            <br />
            <label for="txtPassword">Password: </label>&nbsp;<input type="password" id="txtPassword" name="txtPassword" value="">
            <br />
            <input type="submit" id="btnSubmit" name="btnSubmit" value="Login">&nbsp;
            <input onclick="location.href = 'register.jsp';" type="button" id="btnRegister" name="btnRegister" value="Register" >
        </form>
    </body>
</html>
