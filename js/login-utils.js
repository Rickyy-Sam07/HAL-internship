/**
 * Shared Login Page Utilities
 * Contains reusable functions for login page enhancements
 */

/**
 * Creates floating particle animation in the background
 */
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

/**
 * Enhances the login form with password toggle and loading state
 */
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
