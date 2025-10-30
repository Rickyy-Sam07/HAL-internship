<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Committee Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-blue: #1976d2;
            --dark-blue: #1565c0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: 
                url('https://upload.wikimedia.org/wikipedia/en/thumb/3/3e/Hindustan_Aeronautics_Limited_Logo.svg/1200px-Hindustan_Aeronautics_Limited_Logo.svg.png') center center / cover no-repeat fixed,
                linear-gradient(135deg, #1565c0 0%, #1976d2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            pointer-events: none;
            z-index: 0;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 
                0 15px 50px rgba(0, 0, 0, 0.3),
                0 5px 15px rgba(0, 0, 0, 0.2);
            padding: 50px 45px;
            width: 100%;
            max-width: 460px;
            animation: slideIn 0.5s ease;
            border: 2px solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 10;
            overflow: hidden;
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 200px;
            height: 200px;
            background: rgba(25, 118, 210, 0.1);
            border-radius: 50%;
            opacity: 0.5;
            pointer-events: none;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            z-index: 2;
        }

        .login-header h1 {
            color: var(--dark-blue);
            font-size: 2rem;
            margin-bottom: 10px;
            font-weight: 700;
            background: linear-gradient(135deg, #1565c0 0%, #1976d2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid rgba(224, 231, 237, 0.5);
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.2);
            background: rgba(255, 255, 255, 0.8);
            transform: translateY(-2px);
        }

        .btn-login {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
            color: white;
            font-size: 17px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn-login:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(25, 118, 210, 0.4);
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .back-link a:hover {
            color: var(--dark-blue);
            transform: translateX(-5px);
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            font-size: 14px;
        }

        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <%
        // Check if there's a logout message
        String logoutMsg = request.getParameter("logout");
        String errorMsg = request.getParameter("error");
        
        // Handle logout
        if ("true".equals(logoutMsg)) {
            session.invalidate();
        }
    %>

    <div class="login-container">
        <div class="login-header">
            <h1>Admin Login</h1>
            <p>HAL Committee Management System</p>
        </div>

        <% if ("true".equals(logoutMsg)) { %>
            <div class="success-message" style="display: block;">
                Logged out successfully!
            </div>
        <% } %>

        <% if ("invalid".equals(errorMsg)) { %>
            <div class="error-message" style="display: block;">
                Invalid username or password
            </div>
        <% } %>

        <% if ("backend".equals(errorMsg)) { %>
            <div class="error-message" style="display: block;">
                Cannot connect to backend server. Please ensure the backend is running.
            </div>
        <% } %>

        <% if ("missing".equals(errorMsg)) { %>
            <div class="error-message" style="display: block;">
                Please enter both username and password.
            </div>
        <% } %>

        <div id="errorMessage" class="error-message"></div>
        <div id="successMessage" class="success-message"></div>

        <form action="authenticate.jsp" method="post" id="loginForm">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required placeholder="Enter your username">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>

            <button type="submit" class="btn-login">Login</button>
        </form>

        <div class="back-link">
            <a href="committee-view.jsp">Back to Committee View</a>
        </div>
    </div>

    <script>
        // Demo credentials info
        console.log('Demo credentials - Username: admin, Password: admin123');

        // Enhanced Login Form
        window.addEventListener('DOMContentLoaded', () => {
            createFloatingParticles();
            enhanceLoginForm();
        });

        function createFloatingParticles() {
            const particlesContainer = document.createElement('div');
            particlesContainer.id = 'particles-container';
            particlesContainer.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 0;
                overflow: hidden;
            `;

            for (let i = 0; i < 20; i++) {
                const particle = document.createElement('div');
                const size = Math.random() * 60 + 20;
                const x = Math.random() * 100;
                const y = Math.random() * 100;
                const delay = Math.random() * 5;
                const duration = Math.random() * 10 + 10;

                particle.className = 'particle';
                particle.style.cssText = `
                    position: absolute;
                    left: ${x}%;
                    top: ${y}%;
                    width: ${size}px;
                    height: ${size}px;
                    background: radial-gradient(circle, rgba(25, 118, 210, ${Math.random() * 0.1}) 0%, transparent 70%);
                    border-radius: 50%;
                    animation: floatParticle ${duration}s ease-in-out infinite ${delay}s;
                `;

                particlesContainer.appendChild(particle);
            }

            document.body.prepend(particlesContainer);
        }

        function enhanceLoginForm() {
            const form = document.getElementById('loginForm');
            const passwordInput = document.getElementById('password');

            // Show/Hide Password Toggle
            const passwordWrapper = passwordInput.parentElement;
            const toggleButton = document.createElement('button');
            toggleButton.type = 'button';
            toggleButton.className = 'toggle-password';
            toggleButton.innerHTML = 'Show';
            toggleButton.style.cssText = `
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                cursor: pointer;
                font-size: 0.85em;
                padding: 5px 10px;
                transition: all 0.3s;
                opacity: 0.6;
                z-index: 10;
                color: #1976d2;
                font-weight: 600;
            `;
            
            toggleButton.addEventListener('click', () => {
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggleButton.innerHTML = 'Hide';
                } else {
                    passwordInput.type = 'password';
                    toggleButton.innerHTML = 'Show';
                }
            });

            passwordWrapper.style.position = 'relative';
            passwordWrapper.appendChild(toggleButton);

            // Loading state on submit
            form.addEventListener('submit', function(e) {
                const loginButton = form.querySelector('.btn-login');
                loginButton.disabled = true;
                loginButton.innerHTML = 'Signing In...';
                loginButton.style.opacity = '0.7';
            });
        }
    </script>
</body>
</html>
