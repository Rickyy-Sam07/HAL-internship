<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.io.*,java.net.*,org.json.*" %>
<%
    // Get form parameters
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Validate credentials against FastAPI backend
    if (username != null && password != null) {
        try {
            // Call FastAPI backend for authentication
            String apiUrl = "http://127.0.0.1:8001/api/hr/login";
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            
            // Create JSON body
            String jsonBody = "{\"username\":\"" + username + "\",\"password\":\"" + password + "\"}";
            
            // Send request
            OutputStream os = conn.getOutputStream();
            os.write(jsonBody.getBytes("UTF-8"));
            os.flush();
            os.close();
            
            // Get response
            int responseCode = conn.getResponseCode();
            
            if (responseCode == 200) {
                // Authentication successful
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuffer response_body = new StringBuffer();
                while ((inputLine = in.readLine()) != null) {
                    response_body.append(inputLine);
                }
                in.close();
                
                // Set session attributes
                session.setAttribute("loggedInUser", username);
                session.setAttribute("userRole", "HR Administrator");
                session.setAttribute("isLoggedIn", true);
                
                // Redirect to committee view page
                response.sendRedirect("committee-view.jsp?loggedIn=true");
            } else {
                // Invalid credentials (401 or other error)
                response.sendRedirect("login.jsp?error=invalid");
            }
            
        } catch (Exception e) {
            // Backend connection error
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=backend");
        }
    } else {
        // Missing parameters
        response.sendRedirect("login.jsp?error=missing");
    }
%>
