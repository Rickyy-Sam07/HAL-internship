<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Invalidate the session
    if (session != null) {
        session.invalidate();
    }
    
    // Redirect to login page with logout message
    response.sendRedirect("login.jsp?logout=true");
%>
