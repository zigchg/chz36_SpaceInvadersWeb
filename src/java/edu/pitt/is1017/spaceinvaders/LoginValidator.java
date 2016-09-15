/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.pitt.is1017.spaceinvaders;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chong
 */
@WebServlet(name = "LoginValidator", urlPatterns = {"/LoginValidator"})
public class LoginValidator extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userName = "";
            String password = "";
            User user;
            if (request.getParameter("btnSubmit") != null) {
                if (request.getParameter("txtUserName") != null) {
                    if (!request.getParameter("txtUserName").equals("")) {
                        userName = request.getParameter("txtUserName");
                    }
                }
                if (request.getParameter("txtPassword") != null) {
                    if (!request.getParameter("txtPassword").equals("")) {
                        password = request.getParameter("txtPassword");
                    }
                }

                if (!userName.equals("") && !password.equals("")) {
                    //out.println(userName + " " + password);
                    user = new User(userName, password);
                    if (user.isLoggedIn()) {
                        //out.println(user.getEmail());
                        String userID = user.getUserID() + "";
                        Cookie loginCookie = new Cookie("userID", userID);
                        loginCookie.setMaxAge(1*60*60);
                        response.addCookie(loginCookie);
                        response.sendRedirect("game.jsp");
                    } else {
                        RequestDispatcher rd = getServletContext().getRequestDispatcher("/index.jsp");
                        out.println("<script>alert('User name and password combination does not match any records.');</script>");
                        rd.include(request, response);
                    }
                } else {
                    RequestDispatcher rd = getServletContext().getRequestDispatcher("/index.jsp");
                    out.println("<script>alert('You must enter both username and password.');</script>");
                    rd.include(request, response);
                }
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(LoginValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(LoginValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
