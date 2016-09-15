<%-- 
    Document   : register
    Created on : Mar 19, 2016, 10:54:08 AM
    Author     : Chong
--%>

<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion - Register</title>
    </head>
    <%
        String firstName = "";
        String lastName = "";
        String email = "";
        String password = "";
        
        User user;
        if(request.getParameter("btnRegister") != null){
            if(request.getParameter("txtFirstName") != null){
                if(request.getParameter("txtFirstName") != ""){
                    firstName = request.getParameter("txtFirstName");
                }
            }
            
            if(request.getParameter("txtLastName") != null){
                if(request.getParameter("txtLastName") != ""){
                    lastName = request.getParameter("txtLastName");
                }
            }
            
            if(request.getParameter("txtEmail") != null){
                if(request.getParameter("txtEmail") != ""){
                    email = request.getParameter("txtEmail");
                }
            }
            
            if(request.getParameter("txtPassword") != null){
                if(request.getParameter("txtPassword") != "" && 
                        request.getParameter("txtPassword").equals(request.getParameter("txtConfirmPassword")))
                {
                    password = request.getParameter("txtPassword");
                }
            }
            
            if(!email.equals("") && !password.equals("")
                    && !firstName.equals("") && !lastName.equals(""))
            {   
                user = new User (lastName, firstName, email, password);
                out.println("<script>alert('Successfully register.');location.href = \"index.jsp\";</script>");
            }
            else {
                out.println("<script>alert('You must enter all registion fields.');</script>");
            }
        }
    %>
    <body>
        <form id="frmRegister" action="register.jsp" method="post">
            <label for="txtFirstName">First Name: </label>&nbsp;<input type="text" id="txtFirstName" name="txtFirstName" value="">
            <br />
            <label for="txtLastName">Last Name: </label>&nbsp;<input type="text" id="txtLastName" name="txtLastName" value="">
            <br />
            <label for="txtEmail">Email: </label>&nbsp;<input type="text" id="txtEmail" name="txtEmail" value="">
            <br />
            <label for="txtPassword">Password: </label>&nbsp;<input type="password" id="txtPassword" name="txtPassword" value="">
            <br />
            <label for="txtConfirmPassword">Confirm Password: </label>&nbsp;<input type="password" id="txtConfirmPassword" name="txtConfirmPassword" value="">
            <br />
            <input type="submit" id="btnRegister" name="btnRegister" value="Register">&nbsp;
            <input onclick="location.href = 'index.jsp';" type="button" id="btnCancel" name="btnCancel" value="Cancel" >
        </form>
    </body>
</html>
