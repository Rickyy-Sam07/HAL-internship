<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Check if user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userRole = (String) session.getAttribute("userRole");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    
    // Set default values if null
    if (loggedInUser == null) loggedInUser = "";
    if (userRole == null) userRole = "Guest";
    if (isLoggedIn == null) isLoggedIn = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Committee Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-blue: #1976d2;
            --dark-blue: #1565c0;
            --accent-blue: #42a5f5;
            --dark-gray: #37474f;
            --light-bg: #e8eef3;
            --success-green: #2e7d32;
            --error-red: #d32f2f;
            --warning-orange: #f57c00;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e8eef3 0%, #f5f8fa 100%);
            min-height: 100vh;
            padding: 0;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated Background Pattern */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(25, 118, 210, 0.03) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(66, 165, 245, 0.03) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        .page-wrapper {
            position: relative;
            z-index: 1;
            padding: 20px;
        }

        /* Top Header Bar with Logo */
        .top-header {
            background: linear-gradient(to right, #1565c0, #1976d2);
            padding: 15px 0;
            box-shadow: 0 4px 12px rgba(21, 101, 192, 0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .top-header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px;
        }

        .logo-container {
            display: flex;
            align-items: center;
            gap: 20px;
            animation: fadeInLeft 0.8s ease;
        }

        /* User Profile Section */
        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            animation: fadeInRight 0.8s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .user-profile:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #42a5f5, #1e88e5);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            border: 2px solid rgba(255, 255, 255, 0.8);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .user-info {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .user-name {
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            line-height: 1.2;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }

        .user-role {
            color: rgba(255, 255, 255, 0.85);
            font-size: 0.75rem;
            line-height: 1.2;
        }

        .logout-btn {
            background: rgba(211, 47, 47, 0.9);
            color: white;
            border: none;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .logout-btn:hover {
            background: #c62828;
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        @keyframes fadeInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .hal-logo {
            height: 60px;
            width: auto;
            filter: brightness(0) invert(1);
            transition: all 0.4s ease;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-5px);
            }
        }

        .hal-logo:hover {
            transform: scale(1.1) rotate(5deg);
            filter: brightness(0) invert(1) drop-shadow(0 0 10px rgba(255,255,255,0.5));
        }

        .logo-text {
            color: white;
            line-height: 1.2;
        }

        .logo-text h1 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .logo-text p {
            font-size: 0.9rem;
            opacity: 0.95;
            font-weight: 400;
            letter-spacing: 0.5px;
        }

        .container {
            max-width: 1400px;
            margin: 30px auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 
                0 10px 40px rgba(0, 0, 0, 0.08),
                0 2px 8px rgba(0, 0, 0, 0.04);
            padding: 40px;
            border-top: 4px solid var(--primary-blue);
            animation: fadeInUp 0.6s ease;
            position: relative;
            overflow: hidden;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Decorative corner elements */
        .container::before,
        .container::after {
            content: '';
            position: absolute;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            opacity: 0.05;
            pointer-events: none;
        }

        .container::before {
            background: var(--primary-blue);
            top: -100px;
            right: -100px;
        }

        .container::after {
            background: var(--accent-blue);
            bottom: -100px;
            left: -100px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
            flex-wrap: wrap;
            gap: 20px;
            position: sticky;
            top: 20px;
            background: linear-gradient(135deg, #e8eef3 0%, #f5f8fa 100%);
            padding: 20px 0;
            z-index: 999;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border-radius: 12px;
            margin-top: -65px;
        }

        .header h1 {
            color: var(--dark-blue);
            font-size: 2.2rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #1565c0 0%, #1976d2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .header-buttons {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn {
            padding: 12px 28px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            display: inline-block;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn::before {
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

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-login {
            background: var(--dark-gray);
            color: white;
            border: 2px solid transparent;
            box-shadow: 0 4px 16px rgba(55, 71, 79, 0.3);
            font-size: 16px;
            padding: 14px 32px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-login:hover {
            background: #263238;
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 24px rgba(55, 71, 79, 0.4);
        }

        .btn-add {
            background: var(--primary-blue);
            color: white;
            border: 2px solid transparent;
            box-shadow: 0 4px 16px rgba(25, 118, 210, 0.3);
            animation: pulse 2s infinite;
            font-size: 16px;
            padding: 14px 32px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 4px 12px rgba(25, 118, 210, 0.2);
            }
            50% {
                box-shadow: 0 4px 20px rgba(25, 118, 210, 0.4);
            }
        }

        .btn-add:hover {
            background: var(--dark-blue);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 24px rgba(25, 118, 210, 0.4);
            animation: none;
        }

        .search-box {
            margin-bottom: 35px;
            margin-top: 130px;
            position: relative;
            z-index: 1;
        }

        .search-box input {
            width: 100%;
            padding: 16px 50px 16px 20px;
            border: 2px solid #e0e7ed;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8fafc;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.1),
                        0 4px 12px rgba(25, 118, 210, 0.15);
            background: white;
            transform: translateY(-2px);
        }

        .search-box::after {
            content: '🔍';
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 20px;
            pointer-events: none;
            opacity: 0.5;
        }

        /* Recent Committees Section */
        .recent-section {
            background: linear-gradient(135deg, #e3f2fd 0%, #f5f9fc 100%);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 35px;
            border-left: 4px solid var(--primary-blue);
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.08);
            animation: slideInRight 0.6s ease;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .recent-section h2 {
            color: var(--dark-blue);
            font-size: 1.4rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .recent-section h2::before {
            content: '⭐';
            font-size: 1.6rem;
            animation: rotate 3s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .recent-committees {
            display: grid;
            gap: 12px;
        }

        .recent-item {
            background: white;
            padding: 16px 20px;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid #e3e8ef;
            position: relative;
            overflow: hidden;
        }

        .recent-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 3px;
            background: var(--primary-blue);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .recent-item:hover {
            transform: translateX(8px);
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.15);
            border-color: var(--primary-blue);
        }

        .recent-item:hover::before {
            transform: scaleY(1);
        }

        .recent-item-name {
            font-weight: 600;
            color: #1a1a1a;
            font-size: 14px;
        }

        .recent-item-badge {
            background: var(--primary-blue);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .committee-card {
            background: linear-gradient(to bottom, #ffffff 0%, #fafbfc 100%);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 
                0 4px 12px rgba(0, 0, 0, 0.06),
                0 1px 3px rgba(0, 0, 0, 0.04);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #e8eef3;
            border-left: 5px solid var(--primary-blue);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.5s ease forwards;
            opacity: 0;
        }

        .committee-card:nth-child(1) { animation-delay: 0.1s; }
        .committee-card:nth-child(2) { animation-delay: 0.2s; }
        .committee-card:nth-child(3) { animation-delay: 0.3s; }
        .committee-card:nth-child(4) { animation-delay: 0.4s; }
        .committee-card:nth-child(5) { animation-delay: 0.5s; }

        .committee-card::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, transparent 0%, rgba(25, 118, 210, 0.02) 100%);
            opacity: 0;
            transition: opacity 0.4s ease;
            pointer-events: none;
        }

        .committee-card:hover {
            transform: translateY(-8px);
            box-shadow: 
                0 12px 32px rgba(25, 118, 210, 0.15),
                0 4px 12px rgba(0, 0, 0, 0.08);
            border-left-width: 6px;
        }

        .committee-card:hover::after {
            opacity: 1;
        }

        .committee-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .committee-title {
            font-size: 1.6rem;
            color: #1a1a1a;
            font-weight: 700;
            position: relative;
            display: inline-block;
        }

        .committee-title::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0;
            height: 3px;
            background: linear-gradient(to right, var(--primary-blue), var(--accent-blue));
            transition: width 0.4s ease;
        }

        .committee-card:hover .committee-title::after {
            width: 100%;
        }

        .committee-id {
            background: linear-gradient(135deg, #37474f 0%, #263238 100%);
            color: white;
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.8px;
            box-shadow: 0 4px 12px rgba(55, 71, 79, 0.2);
            transition: all 0.3s ease;
        }

        .committee-id:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(55, 71, 79, 0.3);
        }

        .duration-section {
            display: flex;
            gap: 30px;
            margin-bottom: 28px;
            padding: 20px;
            background: linear-gradient(135deg, #e3f2fd 0%, #f0f7ff 100%);
            border-radius: 10px;
            border-left: 4px solid var(--primary-blue);
            box-shadow: inset 0 2px 4px rgba(25, 118, 210, 0.05);
            transition: all 0.3s ease;
        }

        .duration-section:hover {
            box-shadow: inset 0 2px 8px rgba(25, 118, 210, 0.1);
            transform: scale(1.01);
        }

        .duration-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .duration-label {
            font-weight: 600;
            color: #1976d2;
        }

        .duration-value {
            color: #263238;
            font-weight: 500;
        }

        .representatives-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
        }

        .rep-group {
            background: #ffffff;
            padding: 24px;
            border-radius: 10px;
            border: 1px solid #e8eef3;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
        }

        .rep-group:hover {
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }

        .rep-group h3 {
            color: var(--dark-blue);
            margin-bottom: 18px;
            font-size: 1.2rem;
            font-weight: 700;
            padding-bottom: 12px;
            border-bottom: 3px solid var(--primary-blue);
            position: relative;
        }

        .rep-group h3::before {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--accent-blue);
            animation: slideWidth 2s ease-in-out infinite;
        }

        @keyframes slideWidth {
            0%, 100% { width: 60px; }
            50% { width: 100px; }
        }

        .rep-table {
            width: 100%;
            border-collapse: collapse;
        }

        .rep-table thead {
            background: linear-gradient(135deg, #1565c0 0%, #1976d2 100%);
            color: white;
        }

        .rep-table th {
            padding: 14px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .rep-table td {
            padding: 14px;
            border-bottom: 1px solid #e8eef3;
            font-size: 14px;
            color: #37474f;
            transition: all 0.2s ease;
        }

        .rep-table tbody tr {
            background: white;
            transition: all 0.3s ease;
        }

        .rep-table tbody tr:hover {
            background: linear-gradient(to right, #e3f2fd 0%, #f0f7ff 100%);
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(25, 118, 210, 0.1);
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 1.2rem;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            overflow-y: auto;
            padding: 20px;
        }

        .modal-content {
            background: white;
            max-width: 900px;
            margin: 50px auto;
            border-radius: 6px;
            padding: 30px;
            position: relative;
            animation: slideDown 0.3s ease;
            border: 1px solid #d0d0d0;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .modal-header h2 {
            color: #333;
            font-size: 1.8rem;
        }

        .close-btn {
            font-size: 2rem;
            color: #999;
            cursor: pointer;
            border: none;
            background: none;
            transition: all 0.3s ease;
        }

        .close-btn:hover {
            color: #f5576c;
            transform: rotate(90deg);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #1976d2;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
        }

        .rep-form-section {
            background: #f5f9fc;
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #dde7f0;
            border-left: 3px solid #1976d2;
        }

        .rep-form-section h3 {
            color: #1565c0;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .rep-item {
            background: white;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 15px;
            border: 1px solid #e3e8ef;
            border-left: 3px solid #42a5f5;
        }

        .rep-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .rep-inputs {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .btn-small {
            padding: 8px 15px;
            font-size: 14px;
        }

        .btn-add-rep {
            background: #2e7d32;
            color: white;
            margin-top: 10px;
            border: 1px solid #2e7d32;
        }

        .btn-add-rep:hover {
            background: #1b5e20;
            border-color: #1b5e20;
            box-shadow: 0 2px 8px rgba(46, 125, 50, 0.3);
        }

        .btn-remove {
            background: #d32f2f;
            color: white;
            border: 1px solid #d32f2f;
        }

        .btn-remove:hover {
            background: #c62828;
            border-color: #c62828;
            box-shadow: 0 2px 8px rgba(211, 47, 47, 0.3);
        }

        .btn-edit {
            background: #f57c00;
            color: white;
            margin-left: 10px;
            border: 1px solid #f57c00;
        }

        .btn-edit:hover {
            background: #ef6c00;
            border-color: #ef6c00;
            box-shadow: 0 2px 8px rgba(245, 124, 0, 0.3);
        }

        .btn-submit {
            background: #1976d2;
            color: white;
            width: 100%;
            padding: 14px;
            font-size: 16px;
            margin-top: 20px;
            border: 1px solid #1976d2;
        }

        .btn-submit:hover {
            background: #1565c0;
            border-color: #1565c0;
            box-shadow: 0 2px 8px rgba(25, 118, 210, 0.3);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .form-actions .btn {
            flex: 1;
        }

        @media (max-width: 768px) {
            .representatives-section {
                grid-template-columns: 1fr;
            }

            .rep-inputs {
                grid-template-columns: 1fr;
            }

            .header h1 {
                font-size: 1.5rem;
            }

            .duration-section {
                flex-direction: column;
                gap: 10px;
            }
        }

        .hidden {
            display: none;
        }

        /* Highlight Animation for Scrolled Card */
        @keyframes highlightCard {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
            }
            50% {
                transform: scale(1.02);
                box-shadow: 0 12px 32px rgba(25, 118, 210, 0.3);
            }
        }
    </style>
</head>
<body>
    <!-- Top Header with Logo -->
    <div class="top-header">
        <div class="top-header-content">
            <div class="logo-container">
                     <img src="https://upload.wikimedia.org/wikipedia/en/thumb/3/3e/Hindustan_Aeronautics_Limited_Logo.svg/1200px-Hindustan_Aeronautics_Limited_Logo.svg.png"
                     alt="HAL Logo" class="hal-logo">
                <div class="logo-text">
                    <h1>Hindustan Aeronautics Limited</h1>
                    <p>Committee Management System</p>
                </div>
            </div>
            
            <!-- User Profile Section -->
            <% if (isLoggedIn && loggedInUser != null && !loggedInUser.isEmpty()) { %>
            <div class="user-profile" id="userProfile" style="display: flex;">
                <div class="user-avatar" id="userAvatar"><%=loggedInUser.substring(0, 1).toUpperCase()%></div>
                <div class="user-info">
                    <span class="user-name" id="userName"><%=loggedInUser.equals("admin") ? "Administrator" : loggedInUser%></span>
                    <span class="user-role"><%=userRole%></span>
                </div>
                <form action="logout.jsp" method="post" style="display: inline;">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
            <% } %>
        </div>
    </div>

    <div class="page-wrapper">
        <div class="container">
            <div class="header">
                <h1>Committee Management Portal</h1>
                <div class="header-buttons">
                    <% if (!isLoggedIn) { %>
                        <button class="btn btn-login" onclick="redirectToLogin()">Login</button>
                    <% } else { %>
                        <button class="btn btn-add" onclick="handleAddData()">ADD DATA</button>
                    <% } %>
                </div>
            </div>

            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by committee name or ID..." onkeyup="searchCommittees()">
            </div>

            <!-- Recent Committees Section -->
            <div class="recent-section">
                <h2>Recently Added Committees</h2>
                <div class="recent-committees" id="recentCommittees">
                    <!-- Recent committees will be displayed here -->
                </div>
            </div>

            <div id="committeeList">
                <!-- Committees will be displayed here -->
            </div>
        </div>
    </div>

    <!-- Add/Edit Committee Modal -->
    <div id="committeeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add Committee Data</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>

            <form id="committeeForm">
                <div class="form-group">
                    <label>Committee Name *</label>
                    <input type="text" id="committeeName" required>
                </div>

                <div class="form-group">
                    <label>Committee ID *</label>
                    <input type="text" id="committeeId" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label>From Date *</label>
                        <input type="date" id="fromDate" required>
                    </div>

                    <div class="form-group">
                        <label>Till Date *</label>
                        <input type="date" id="tillDate" required>
                    </div>
                </div>

                <!-- Management Representatives -->
                <div class="rep-form-section">
                    <h3>Management Representatives</h3>
                    <div id="managementReps">
                        <!-- Management reps will be added here -->
                    </div>
                    <button type="button" class="btn btn-add-rep btn-small" onclick="addRepresentative('management')">+ Add Management Rep</button>
                </div>

                <!-- Worker Representatives -->
                <div class="rep-form-section">
                    <h3>Worker Representatives</h3>
                    <div id="workerReps">
                        <!-- Worker reps will be added here -->
                    </div>
                    <button type="button" class="btn btn-add-rep btn-small" onclick="addRepresentative('worker')">+ Add Worker Rep</button>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-edit btn-submit" id="saveBtn" onclick="saveCommittee()">Save & Continue Editing</button>
                    <button type="button" class="btn btn-submit" onclick="submitCommittee()">Submit</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // ========================================
        // API CONFIGURATION
        // ========================================
        // TODO: Update this URL when you provide the backend details
        const API_BASE_URL = 'http://127.0.0.1:8001';  // Your FastAPI backend URL
        
        // ========================================
        // GLOBAL DATA STORAGE
        // ========================================
        let committees = [];  // Will be populated from API
        let employeeDatabase = {};  // Will be populated from API
        
        let currentEditingIndex = -1;
        let isLoggedIn = <%= isLoggedIn %>; // Get login state from JSP session

        // ========================================
        // API FUNCTIONS - TO BE IMPLEMENTED
        // ========================================
        
        /**
         * Fetch all employees from backend
         * Expected API endpoint: GET /api/employees
         * Expected response: { employees: [{employee_id, employee_name, designation, department_name}] }
         */
        async function fetchEmployees() {
            try {
                const response = await fetch(`\${API_BASE_URL}/api/employees`);
                if (!response.ok) throw new Error('Failed to fetch employees');
                
                const data = await response.json();
                // Transform backend data to frontend format
                employeeDatabase = {};
                data.employees.forEach(emp => {
                    employeeDatabase[emp.employee_id] = {
                        name: emp.employee_name,
                        post: emp.designation,
                        dept: emp.department_name
                    };
                });
                
                console.log('Employees loaded:', Object.keys(employeeDatabase).length);
                return employeeDatabase;
            } catch (error) {
                console.error('Error fetching employees:', error);
                alert('Failed to load employees from backend. Please check your connection.');
                return {};
            }
        }
        
        /**
         * Fetch all committees from backend
         * Expected API endpoint: GET /api/committees
         * Expected response: { committees: [{committee_id, committee_name, start_date, end_date, members: [...]}] }
         */
        async function fetchCommittees() {
            try {
                const response = await fetch(`\${API_BASE_URL}/api/committees`);
                if (!response.ok) throw new Error('Failed to fetch committees');
                
                const data = await response.json();
                // Transform backend data to frontend format
                committees = data.committees.map(committee => {
                    return {
                        id: `HAL-COM-\${committee.committee_id}`,
                        name: committee.committee_name,
                        fromDate: committee.start_date,
                        tillDate: committee.end_date,
                        managementReps: committee.members
                            .filter(m => m.member_type === 'Management')
                            .map(m => ({
                                post: m.role,
                                dept: m.department_name || 'N/A',
                                eid: m.employee_id.toString()
                            })),
                        workerReps: committee.members
                            .filter(m => m.member_type === 'Working')
                            .map(m => ({
                                post: m.role,
                                dept: m.department_name || 'N/A',
                                eid: m.employee_id.toString()
                            }))
                    };
                });
                
                console.log('Committees loaded:', committees.length);
                return committees;
            } catch (error) {
                console.error('Error fetching committees:', error);
                alert('Failed to load committees from backend. Please check your connection.');
                return [];
            }
        }
        
        /**
         * Create a new committee via API
         * Expected API endpoint: POST /api/committee/create
         * Request body: { committee_name, start_date, end_date, members: [{employee_id, role, member_type}] }
         */
        async function createCommitteeAPI(committeeData) {
            try {
                const response = await fetch(`\${API_BASE_URL}/api/committee/create`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(committeeData)
                });
                
                if (!response.ok) {
                    const error = await response.json();
                    throw new Error(error.detail || 'Failed to create committee');
                }
                
                const result = await response.json();
                console.log('Committee created:', result);
                return result;
            } catch (error) {
                console.error('Error creating committee:', error);
                throw error;
            }
        }

        // ========================================
        // INITIALIZE PAGE - LOAD DATA FROM BACKEND
        // ========================================
        window.onload = async function() {
            // Fetch data from backend on page load
            await fetchEmployees();
            await fetchCommittees();
            
            displayRecentCommittees();
            displayCommittees();
            
            // Check if user just logged in and open modal
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('loggedIn') === 'true' && isLoggedIn) {
                openModal();
                // Clean URL
                window.history.replaceState({}, document.title, window.location.pathname);
            }
            
            // User profile handled by JSP server-side
        };

        function displayRecentCommittees() {
            const container = document.getElementById('recentCommittees');
            const recentCommittees = [...committees].slice(-5).reverse(); // Get last 5, most recent first
            
            if (recentCommittees.length === 0) {
                container.innerHTML = '<p style="color: #666; font-style: italic;">No committees added yet.</p>';
                return;
            }

            container.innerHTML = recentCommittees.map((committee, index) => `
                <div class="recent-item" onclick="scrollToCommittee('\${committee.id}')" style="animation-delay: \${index * 0.1}s;">
                    <span class="recent-item-name">\${committee.name}</span>
                    <span class="recent-item-badge">\${committee.id}</span>
                </div>
            `).join('');
        }

        function scrollToCommittee(committeeId) {
            const allCards = document.querySelectorAll('.committee-card');
            allCards.forEach(card => {
                if (card.querySelector('.committee-id').textContent.includes(committeeId)) {
                    card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    card.style.animation = 'highlightCard 1s ease';
                    setTimeout(() => {
                        card.style.animation = '';
                    }, 1000);
                }
            });
        }

        function displayCommittees() {
            const container = document.getElementById('committeeList');
            
            if (committees.length === 0) {
                container.innerHTML = '<div class="no-data">No committees found. Add some data to get started!</div>';
                return;
            }

            try {
                container.innerHTML = committees.map(committee => `
                    <div class="committee-card">
                        <div class="committee-header">
                            <div class="committee-title">\${committee.name || 'Unnamed Committee'}</div>
                            <div class="committee-id">ID: \${committee.id || 'N/A'}</div>
                        </div>

                        <div class="duration-section">
                            <div class="duration-item">
                                <span class="duration-label">From:</span>
                                <span class="duration-value">\${formatDate(committee.fromDate)}</span>
                            </div>
                            <div class="duration-item">
                                <span class="duration-label">Duration:</span>
                                <span class="duration-value">\${calculateDuration(committee.fromDate, committee.tillDate)}</span>
                            </div>
                            <div class="duration-item">
                                <span class="duration-label">Till Date:</span>
                                <span class="duration-value">\${formatDate(committee.tillDate)}</span>
                            </div>
                        </div>

                        <div class="representatives-section">
                            <div class="rep-group">
                                <h3>Management Representatives</h3>
                                <table class="rep-table">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Post</th>
                                            <th>Dept</th>
                                            <th>EID</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        \${(committee.managementReps || []).map(rep => {
                                            const employee = employeeDatabase[rep.eid] || {};
                                            return `
                                            <tr>
                                                <td>\${employee.name || 'N/A'}</td>
                                                <td>\${rep.post || 'N/A'}</td>
                                                <td>\${rep.dept || 'N/A'}</td>
                                                <td>\${rep.eid || 'N/A'}</td>
                                            </tr>
                                        `;}).join('')}
                                    </tbody>
                                </table>
                            </div>

                            <div class="rep-group">
                                <h3>Worker Representatives</h3>
                                <table class="rep-table">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Post</th>
                                            <th>Dept</th>
                                            <th>EID</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        \${(committee.workerReps || []).map(rep => {
                                            const employee = employeeDatabase[rep.eid] || {};
                                            return `
                                            <tr>
                                                <td>\${employee.name || 'N/A'}</td>
                                                <td>\${rep.post || 'N/A'}</td>
                                                <td>\${rep.dept || 'N/A'}</td>
                                                <td>\${rep.eid || 'N/A'}</td>
                                            </tr>
                                        `;}).join('')}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                `).join('');
            } catch (error) {
                console.error('Error displaying committees:', error);
                container.innerHTML = '<div class="no-data" style="color: red;">Error displaying committees. Please refresh the page.</div>';
            }
        }

        function searchCommittees() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const filteredCommittees = committees.filter(committee => 
                committee.name.toLowerCase().includes(searchTerm) ||
                committee.id.toLowerCase().includes(searchTerm)
            );

            const container = document.getElementById('committeeList');
            
            if (filteredCommittees.length === 0) {
                container.innerHTML = '<div class="no-data">No matching committees found.</div>';
                return;
            }

            container.innerHTML = filteredCommittees.map(committee => `
                <div class="committee-card">
                    <div class="committee-header">
                        <div class="committee-title">\${committee.name}</div>
                        <div class="committee-id">ID: \${committee.id}</div>
                    </div>

                    <div class="duration-section">
                        <div class="duration-item">
                            <span class="duration-label">From:</span>
                            <span class="duration-value">\${formatDate(committee.fromDate)}</span>
                        </div>
                        <div class="duration-item">
                            <span class="duration-label">Duration:</span>
                            <span class="duration-value">\${calculateDuration(committee.fromDate, committee.tillDate)}</span>
                        </div>
                        <div class="duration-item">
                            <span class="duration-label">Till Date:</span>
                            <span class="duration-value">\${formatDate(committee.tillDate)}</span>
                        </div>
                    </div>

                    <div class="representatives-section">
                        <div class="rep-group">
                            <h3>Management Representatives</h3>
                            <table class="rep-table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Post</th>
                                        <th>Dept</th>
                                        <th>EID</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    \${committee.managementReps.map(rep => {
                                        const employee = employeeDatabase[rep.eid] || {};
                                        return `
                                        <tr>
                                            <td>\${employee.name || 'N/A'}</td>
                                            <td>\${rep.post}</td>
                                            <td>\${rep.dept}</td>
                                            <td>\${rep.eid}</td>
                                        </tr>
                                    `;}).join('')}
                                </tbody>
                            </table>
                        </div>

                        <div class="rep-group">
                            <h3>Worker Representatives</h3>
                            <table class="rep-table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Post</th>
                                        <th>Dept</th>
                                        <th>EID</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    \${committee.workerReps.map(rep => {
                                        const employee = employeeDatabase[rep.eid] || {};
                                        return `
                                        <tr>
                                            <td>\${employee.name || 'N/A'}</td>
                                            <td>\${rep.post}</td>
                                            <td>\${rep.dept}</td>
                                            <td>\${rep.eid}</td>
                                        </tr>
                                    `;}).join('')}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
        }

        function calculateDuration(fromDate, tillDate) {
            const from = new Date(fromDate);
            const till = new Date(tillDate);
            const months = (till.getFullYear() - from.getFullYear()) * 12 + (till.getMonth() - from.getMonth());
            return `\${months} months`;
        }

        function handleAddData() {
            // Check if user is logged in
            const isLoggedIn = <%= isLoggedIn %>;
            
            if (isLoggedIn) {
                // User is logged in, open the modal form
                openModal();
            } else {
                // User not logged in, redirect to login page
                redirectToLogin();
            }
        }

        function redirectToLogin() {
            // Redirect to login page
            window.location.href = 'login.jsp';
        }

        function openModal() {
            document.getElementById('committeeModal').style.display = 'block';
            resetForm();
        }

        function closeModal() {
            document.getElementById('committeeModal').style.display = 'none';
            resetForm();
        }

        function resetForm() {
            document.getElementById('committeeForm').reset();
            document.getElementById('managementReps').innerHTML = '';
            document.getElementById('workerReps').innerHTML = '';
            currentEditingIndex = -1;
            
            // Add initial representatives
            addRepresentative('management');
            addRepresentative('worker');
        }

        let managementRepCounter = 0;
        let workerRepCounter = 0;

        function addRepresentative(type) {
            const container = document.getElementById(type === 'management' ? 'managementReps' : 'workerReps');
            const counter = type === 'management' ? managementRepCounter++ : workerRepCounter++;
            
            const repItem = document.createElement('div');
            repItem.className = 'rep-item';
            repItem.id = `\${type}-rep-\${counter}`;
            
            repItem.innerHTML = `
                <div class="rep-item-header">
                    <strong>\${type === 'management' ? 'Management' : 'Worker'} Representative \${counter + 1}</strong>
                    <button type="button" class="btn btn-remove btn-small" onclick="removeRepresentative('\${type}', \${counter})">Remove</button>
                </div>
                <div class="rep-inputs">
                    <div class="form-group">
                        <label>EID *</label>
                        <input type="text" class="\${type}-eid" data-index="\${counter}" placeholder="Enter EID (e.g., HAL001)" 
                               onblur="fetchEmployeeInfo('\${type}', \${counter})" required>
                    </div>
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" class="\${type}-name" data-index="\${counter}" readonly style="background: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Post</label>
                        <input type="text" class="\${type}-post" data-index="\${counter}" readonly style="background: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Department</label>
                        <input type="text" class="\${type}-dept" data-index="\${counter}" readonly style="background: #f0f0f0;">
                    </div>
                </div>
            `;
            
            container.appendChild(repItem);
        }

        function fetchEmployeeInfo(type, index) {
            const eidInput = document.querySelector(`.\${type}-eid[data-index="\${index}"]`);
            const nameInput = document.querySelector(`.\${type}-name[data-index="\${index}"]`);
            const postInput = document.querySelector(`.\${type}-post[data-index="\${index}"]`);
            const deptInput = document.querySelector(`.\${type}-dept[data-index="\${index}"]`);
            
            const eid = eidInput.value.trim().toUpperCase();
            
            if (eid && employeeDatabase[eid]) {
                const employee = employeeDatabase[eid];
                nameInput.value = employee.name;
                postInput.value = employee.post;
                deptInput.value = employee.dept;
                
                // Visual feedback - success
                eidInput.style.borderColor = '#2e7d32';
                eidInput.style.background = '#e8f5e9';
            } else if (eid) {
                // Employee not found
                nameInput.value = '';
                postInput.value = '';
                deptInput.value = '';
                
                // Visual feedback - error
                eidInput.style.borderColor = '#d32f2f';
                eidInput.style.background = '#ffebee';
                
                alert(`Employee with EID "\${eid}" not found in database.\n\nAvailable EIDs: HAL001-HAL028 (Management), HAL101-HAL128 (Workers)`);
            } else {
                // Reset fields if EID is empty
                nameInput.value = '';
                postInput.value = '';
                deptInput.value = '';
                eidInput.style.borderColor = '';
                eidInput.style.background = '';
            }
        }

        function removeRepresentative(type, index) {
            const element = document.getElementById(`\${type}-rep-\${index}`);
            if (element) {
                element.remove();
            }
        }

        function saveCommittee() {
            if (!validateForm()) {
                alert('Please fill all required fields!');
                return;
            }

            const committeeData = getFormData();
            
            if (currentEditingIndex === -1) {
                committees.push(committeeData);
            } else {
                committees[currentEditingIndex] = committeeData;
            }

            displayRecentCommittees();
            displayCommittees();
            alert('Committee data saved! You can continue editing or submit.');
        }

        async function submitCommittee() {
            if (!validateForm()) {
                alert('Please fill all required fields!');
                return;
            }

            const committeeData = getFormData();
            
            try {
                if (currentEditingIndex === -1) {
                    // Create new committee via API
                    // Map management reps to committee roles: 1st=Chairman, 2nd=Secretary, rest=Member
                    const managementMembers = committeeData.managementReps.map((rep, index) => ({
                        employee_id: rep.eid,
                        role: index === 0 ? 'Chairman' : index === 1 ? 'Secretary' : 'Member',
                        member_type: 'Management'
                    }));
                    
                    // All worker reps are Members
                    const workerMembers = committeeData.workerReps.map(rep => ({
                        employee_id: rep.eid,
                        role: 'Member',
                        member_type: 'Working'
                    }));
                    
                    const apiData = {
                        committee_name: committeeData.name,
                        start_date: committeeData.fromDate,
                        end_date: committeeData.tillDate,
                        members: [...managementMembers, ...workerMembers]
                    };
                    
                    await createCommitteeAPI(apiData);
                    alert('Committee created successfully!');
                    
                    // Reload committees from API
                    await fetchCommittees();
                } else {
                    // Update existing committee (local only for now)
                    committees[currentEditingIndex] = committeeData;
                    alert('Committee updated successfully!');
                    // TODO: Implement API update endpoint
                }

                displayRecentCommittees();
                displayCommittees();
                closeModal();
                
                // Hide edit button after submit
                document.getElementById('saveBtn').classList.add('hidden');
                
                // Reset for next time
                setTimeout(() => {
                    document.getElementById('saveBtn').classList.remove('hidden');
                }, 100);
            } catch (error) {
                alert('Error saving committee: ' + error.message);
                console.error('Submit error:', error);
            }
        }

        function validateForm() {
            const name = document.getElementById('committeeName').value.trim();
            const id = document.getElementById('committeeId').value.trim();
            const fromDate = document.getElementById('fromDate').value;
            const tillDate = document.getElementById('tillDate').value;

            if (!name || !id || !fromDate || !tillDate) {
                return false;
            }

            const managementReps = document.querySelectorAll('#managementReps .rep-item');
            const workerReps = document.querySelectorAll('#workerReps .rep-item');

            if (managementReps.length === 0 || workerReps.length === 0) {
                alert('Please add at least one management and one worker representative!');
                return false;
            }

            return true;
        }

        function getFormData() {
            const managementReps = [];
            const managementItems = document.querySelectorAll('#managementReps .rep-item');
            managementItems.forEach((item, index) => {
                const eid = item.querySelector('.management-eid').value.trim();
                const name = item.querySelector('.management-name').value.trim();
                const post = item.querySelector('.management-post').value.trim();
                const dept = item.querySelector('.management-dept').value.trim();
                if (eid && name && post && dept) {
                    managementReps.push({ name, post, dept, eid });
                }
            });

            const workerReps = [];
            const workerItems = document.querySelectorAll('#workerReps .rep-item');
            workerItems.forEach((item, index) => {
                const eid = item.querySelector('.worker-eid').value.trim();
                const name = item.querySelector('.worker-name').value.trim();
                const post = item.querySelector('.worker-post').value.trim();
                const dept = item.querySelector('.worker-dept').value.trim();
                if (eid && name && post && dept) {
                    workerReps.push({ name, post, dept, eid });
                }
            });

            return {
                id: document.getElementById('committeeId').value.trim(),
                name: document.getElementById('committeeName').value.trim(),
                fromDate: document.getElementById('fromDate').value,
                tillDate: document.getElementById('tillDate').value,
                managementReps: managementReps,
                workerReps: workerReps
            };
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('committeeModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>