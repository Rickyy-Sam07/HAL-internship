<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Get form parameters
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Validate credentials (in real application, check against database)
    if (username != null && password != null) {
        if (username.equals("admin") && password.equals("admin123")) {
            // Set session attributes
            session.setAttribute("loggedInUser", username);
            session.setAttribute("userRole", "Administrator");
            session.setAttribute("isLoggedIn", true);
            
            // Redirect to committee view page
            response.sendRedirect("committee-view.jsp?loggedIn=true");
        } else {
            // Invalid credentials
            response.sendRedirect("login.jsp?error=invalid");
        }
    } else {
        // Missing parameters
        response.sendRedirect("login.jsp?error=missing");
    }
%>
