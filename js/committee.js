// API Configuration - use relative URL when served from same server
const API_BASE_URL = window.location.origin;

// Global Data Storage
let committees = [];
let employeeDatabase = {};

// Initialize page on load
window.addEventListener('DOMContentLoaded', async () => {
    initializeSession();
    await fetchEmployees();
    await fetchCommittees();
    displayRecentCommittees();
    displayCommittees();
    
    // Clean URL if coming from login
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('loggedIn') === 'true') {
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

// Initialize session from localStorage
function initializeSession() {
    const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    const loggedInUser = localStorage.getItem('loggedInUser') || '';
    const userRole = localStorage.getItem('userRole') || 'Guest';
    
    const actionButton = document.getElementById('actionButton');
    
    if (isLoggedIn && loggedInUser) {
        // Show user profile
        const userProfile = document.getElementById('userProfile');
        const userAvatar = document.getElementById('userAvatar');
        const userName = document.getElementById('userName');
        const userRoleSpan = document.getElementById('userRole');
        const logoutBtn = document.getElementById('logoutBtn');
        
        userProfile.style.display = 'flex';
        userAvatar.textContent = loggedInUser.substring(0, 1).toUpperCase();
        userName.textContent = loggedInUser === 'admin' ? 'Administrator' : loggedInUser;
        userRoleSpan.textContent = userRole;
        
        logoutBtn.onclick = logout;
        
        // Show ADD COMMITTEE button and set click handler
        actionButton.textContent = 'ADD COMMITTEE';
        actionButton.classList.add('btn-add');
        actionButton.onclick = () => {
            window.location.href = 'add-committee.html';
        };
    } else {
        // Show LOGIN button
        actionButton.textContent = 'LOGIN';
        actionButton.classList.add('btn-login');
        actionButton.onclick = redirectToLogin;
    }
}

// Logout function
function logout() {
    localStorage.clear();
    sessionStorage.clear();
    window.location.href = 'committee-view.html';
}

// Redirect to login
function redirectToLogin() {
    window.location.href = 'index.html';
}

// Fetch all employees from backend
async function fetchEmployees() {
    try {
        const response = await fetch(`${API_BASE_URL}/api/employees`);
        if (!response.ok) throw new Error('Failed to fetch employees');
        
        const data = await response.json();
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

// Fetch all committees from backend
async function fetchCommittees() {
    try {
        const response = await fetch(`${API_BASE_URL}/api/committees`);
        if (!response.ok) throw new Error('Failed to fetch committees');
        
        const data = await response.json();
        committees = data.committees.map(committee => {
            return {
                id: `HAL-COM-${committee.committee_id}`,
                name: committee.committee_name,
                fromDate: committee.start_date,
                tillDate: committee.end_date,
                managementReps: committee.members
                    .filter(m => m.member_type === 'Management')
                    .map(m => ({
                        name: m.employee_name || 'N/A',
                        post: m.post || m.designation || 'N/A',
                        role: m.committee_role || 'Member',
                        dept: m.department_name || 'N/A',
                        eid: m.employee_id.toString()
                    })),
                workerReps: committee.members
                    .filter(m => m.member_type === 'Working')
                    .map(m => ({
                        name: m.employee_name || 'N/A',
                        post: m.post || m.designation || 'N/A',
                        role: m.committee_role || 'Member',
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

// Create committee via API
async function createCommitteeAPI(committeeData) {
    try {
        const response = await fetch(`${API_BASE_URL}/api/committee/create`, {
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

// Display recent committees
function displayRecentCommittees() {
    const container = document.getElementById('recentCommittees');
    const recentCommittees = [...committees].slice(-5).reverse();
    
    if (recentCommittees.length === 0) {
        container.innerHTML = '<p style="color: #666; font-style: italic;">No committees added yet.</p>';
        return;
    }

    container.innerHTML = recentCommittees.map((committee, index) => `
        <div class="recent-item" onclick="scrollToCommittee('${committee.id}')" style="animation-delay: ${index * 0.1}s;">
            <span class="recent-item-name">${committee.name}</span>
            <span class="recent-item-badge">${committee.id}</span>
        </div>
    `).join('');
}

// Scroll to committee with smooth animation
function scrollToCommittee(committeeId) {
    const allCards = document.querySelectorAll('.committee-card');
    allCards.forEach(card => {
        if (card.querySelector('.committee-id').textContent.includes(committeeId)) {
            const headerHeight = document.querySelector('.header').offsetHeight;
            const searchBoxHeight = document.querySelector('.search-box').offsetHeight;
            const offset = headerHeight + searchBoxHeight + 40;
            
            const cardPosition = card.getBoundingClientRect().top + window.pageYOffset - offset;
            
            window.scrollTo({
                top: cardPosition,
                behavior: 'smooth'
            });
            
            card.style.animation = 'highlightCard 1s ease';
            setTimeout(() => {
                card.style.animation = '';
            }, 1000);
        }
    });
}

// Display all committees
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
                    <div class="committee-title">${committee.name || 'Unnamed Committee'}</div>
                    <div class="committee-id">ID: ${committee.id || 'N/A'}</div>
                </div>

                <div class="duration-section">
                    <div class="duration-item">
                        <span class="duration-label">From:</span>
                        <span class="duration-value">${formatDate(committee.fromDate)}</span>
                    </div>
                    <div class="duration-item">
                        <span class="duration-label">Duration:</span>
                        <span class="duration-value">${calculateDuration(committee.fromDate, committee.tillDate)}</span>
                    </div>
                    <div class="duration-item">
                        <span class="duration-label">Till Date:</span>
                        <span class="duration-value">${formatDate(committee.tillDate)}</span>
                    </div>
                </div>

                <div class="representatives-section">
                    <div class="rep-group">
                        <h3>Management Representatives</h3>
                        <table class="rep-table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Role</th>
                                    <th>Post</th>
                                    <th>Dept</th>
                                    <th>EID</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${(committee.managementReps || []).map(rep => {
                                    const employee = employeeDatabase[rep.eid] || {};
                                    return `
                                    <tr>
                                        <td>${rep.name || employee.name || 'N/A'}</td>
                                        <td>${rep.role || 'N/A'}</td>
                                        <td>${rep.post || employee.post || 'N/A'}</td>
                                        <td>${rep.dept || employee.dept || 'N/A'}</td>
                                        <td>${rep.eid || 'N/A'}</td>
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
                                    <th>Role</th>
                                    <th>Post</th>
                                    <th>Dept</th>
                                    <th>EID</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${(committee.workerReps || []).map(rep => {
                                    const employee = employeeDatabase[rep.eid] || {};
                                    return `
                                    <tr>
                                        <td>${rep.name || employee.name || 'N/A'}</td>
                                        <td>${rep.role || 'N/A'}</td>
                                        <td>${rep.post || employee.post || 'N/A'}</td>
                                        <td>${rep.dept || employee.dept || 'N/A'}</td>
                                        <td>${rep.eid || 'N/A'}</td>
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

// Search committees
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
                <div class="committee-title">${committee.name}</div>
                <div class="committee-id">ID: ${committee.id}</div>
            </div>

            <div class="duration-section">
                <div class="duration-item">
                    <span class="duration-label">From:</span>
                    <span class="duration-value">${formatDate(committee.fromDate)}</span>
                </div>
                <div class="duration-item">
                    <span class="duration-label">Duration:</span>
                    <span class="duration-value">${calculateDuration(committee.fromDate, committee.tillDate)}</span>
                </div>
                <div class="duration-item">
                    <span class="duration-label">Till Date:</span>
                    <span class="duration-value">${formatDate(committee.tillDate)}</span>
                </div>
            </div>

            <div class="representatives-section">
                <div class="rep-group">
                    <h3>Management Representatives</h3>
                    <table class="rep-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Post</th>
                                <th>Dept</th>
                                <th>EID</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${committee.managementReps.map(rep => {
                                const employee = employeeDatabase[rep.eid] || {};
                                return `
                                <tr>
                                    <td>${rep.name || employee.name || 'N/A'}</td>
                                    <td>${rep.role || 'N/A'}</td>
                                    <td>${rep.post || employee.post || 'N/A'}</td>
                                    <td>${rep.dept || employee.dept || 'N/A'}</td>
                                    <td>${rep.eid}</td>
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
                                <th>Role</th>
                                <th>Post</th>
                                <th>Dept</th>
                                <th>EID</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${committee.workerReps.map(rep => {
                                const employee = employeeDatabase[rep.eid] || {};
                                return `
                                <tr>
                                    <td>${rep.name || employee.name || 'N/A'}</td>
                                    <td>${rep.role || 'N/A'}</td>
                                    <td>${rep.post || employee.post || 'N/A'}</td>
                                    <td>${rep.dept || employee.dept || 'N/A'}</td>
                                    <td>${rep.eid}</td>
                                </tr>
                            `;}).join('')}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    `).join('');
}

// Format date
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
}

// Calculate duration
function calculateDuration(fromDate, tillDate) {
    const from = new Date(fromDate);
    const till = new Date(tillDate);
    const months = (till.getFullYear() - from.getFullYear()) * 12 + (till.getMonth() - from.getMonth());
    return `${months} months`;
}

