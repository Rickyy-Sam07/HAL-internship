// API Configuration - use relative URL when served from same server
const API_BASE_URL = window.location.origin;

// Check for URL parameters on page load
window.addEventListener('DOMContentLoaded', () => {
    // Initialize login enhancements
    createFloatingParticles();
    enhanceLoginForm();
    
    // Check for messages in URL
    const urlParams = new URLSearchParams(window.location.search);
    const errorMsg = urlParams.get('error');
    const logoutMsg = urlParams.get('logout');
    
    if (logoutMsg === 'true') {
        showMessage('success', 'Logged out successfully!');
        // Clear session
        sessionStorage.clear();
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('loggedInUser');
        localStorage.removeItem('userRole');
    }
    
    if (errorMsg === 'invalid') {
        showMessage('error', 'Invalid username or password');
    } else if (errorMsg === 'backend') {
        showMessage('error', 'Cannot connect to backend server. Please ensure the backend is running.');
    } else if (errorMsg === 'missing') {
        showMessage('error', 'Please enter both username and password.');
    }
});

// Handle login form submission
document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();
    const submitBtn = document.querySelector('.btn-login');
    
    // Validation
    if (!username || !password) {
        showMessage('error', 'Please enter both username and password.');
        return;
    }
    
    // Disable button and show loading
    submitBtn.disabled = true;
    submitBtn.textContent = 'Signing In...';
    
    try {
        // Call backend API for authentication
        const response = await fetch(`${API_BASE_URL}/api/hr/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username, password })
        });
        
        if (response.ok) {
            const data = await response.json();
            
            // Store session data
            localStorage.setItem('isLoggedIn', 'true');
            localStorage.setItem('loggedInUser', username);
            localStorage.setItem('userRole', 'HR Administrator');
            
            // Redirect to committee view (without loggedIn parameter)
            window.location.href = 'committee-view.html';
        } else {
            // Invalid credentials
            showMessage('error', 'Invalid username or password');
            submitBtn.disabled = false;
            submitBtn.textContent = 'Login';
        }
    } catch (error) {
        // Backend connection error
        console.error('Login error:', error);
        showMessage('error', 'Cannot connect to backend server. Please ensure the backend is running.');
        submitBtn.disabled = false;
        submitBtn.textContent = 'Login';
    }
});

// Show error or success message
function showMessage(type, message) {
    const errorDiv = document.getElementById('errorMessage');
    const successDiv = document.getElementById('successMessage');
    
    // Hide both first
    errorDiv.classList.remove('show');
    successDiv.classList.remove('show');
    
    if (type === 'error') {
        errorDiv.textContent = message;
        errorDiv.classList.add('show');
    } else if (type === 'success') {
        successDiv.textContent = message;
        successDiv.classList.add('show');
    }
}
