// API Configuration
const API_BASE_URL = window.location.origin;

// Global Data Storage
let employeeDatabase = {};
let managementMembers = [];
let workerMembers = [];
let editingIndex = { type: null, index: -1 };

// Initialize page on load
window.addEventListener('DOMContentLoaded', async () => {
    initializeSession();
    await fetchEmployees();
});

// Initialize session from localStorage
function initializeSession() {
    const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    const loggedInUser = localStorage.getItem('loggedInUser') || '';
    const userRole = localStorage.getItem('userRole') || 'Guest';
    
    if (!isLoggedIn) {
        alert('Please login to add committees');
        window.location.href = 'index.html';
        return;
    }
    
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
}

// Logout function
function logout() {
    localStorage.clear();
    sessionStorage.clear();
    window.location.href = 'committee-view.html';
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
    } catch (error) {
        console.error('Error fetching employees:', error);
        alert('Failed to load employees. Please check your connection.');
    }
}

// Fetch employee info by EID
function fetchEmployeeInfo(type) {
    const prefix = type === 'management' ? 'mgmt' : 'worker';
    const eidInput = document.getElementById(`${prefix}-eid`);
    const nameInput = document.getElementById(`${prefix}-name`);
    const postInput = document.getElementById(`${prefix}-post`);
    const deptInput = document.getElementById(`${prefix}-dept`);
    const errorDiv = document.getElementById(`${prefix}-error`);
    
    const eid = eidInput.value.trim();
    errorDiv.classList.remove('show');
    
    if (!eid) {
        nameInput.value = '';
        postInput.value = '';
        deptInput.value = '';
        eidInput.classList.remove('input-valid', 'input-invalid');
        return;
    }
    
    // Convert to number for database lookup
    const eidNumber = parseInt(eid);
    
    if (employeeDatabase[eidNumber]) {
        const employee = employeeDatabase[eidNumber];
        nameInput.value = employee.name;
        postInput.value = employee.post;
        deptInput.value = employee.dept;
        
        eidInput.classList.remove('input-invalid');
        eidInput.classList.add('input-valid');
    } else {
        nameInput.value = '';
        postInput.value = '';
        deptInput.value = '';
        
        eidInput.classList.remove('input-valid');
        eidInput.classList.add('input-invalid');
        
        const availableIds = Object.keys(employeeDatabase).sort((a, b) => a - b);
        const range = availableIds.length > 0 ? `${availableIds[0]} to ${availableIds[availableIds.length - 1]}` : 'None';
        errorDiv.textContent = `Employee with ID "${eid}" not found in database. Available IDs: ${range}`;
        errorDiv.classList.add('show');
    }
}

// Check role constraints - Chairman and Secretary are unique across ENTIRE committee
function checkRoleConstraints(type, role) {
    // Only check for Chairman and Secretary (not Member)
    if (role !== 'Chairman' && role !== 'Secretary') {
        return false;
    }
    
    // Check in BOTH management and worker arrays
    const allMembers = [...managementMembers, ...workerMembers];
    const existingRole = allMembers.find(m => m.role === role);
    
    // If editing, exclude the current member being edited
    if (editingIndex.type && editingIndex.index !== -1) {
        const currentMembers = editingIndex.type === 'management' ? managementMembers : workerMembers;
        const editingMember = currentMembers[editingIndex.index];
        
        // If we found someone with this role and it's not the one we're editing
        return existingRole && existingRole !== editingMember;
    }
    
    return existingRole !== undefined;
}

// Add member to the list
function addMember(type) {
    const prefix = type === 'management' ? 'mgmt' : 'worker';
    const eidInput = document.getElementById(`${prefix}-eid`);
    const nameInput = document.getElementById(`${prefix}-name`);
    const postInput = document.getElementById(`${prefix}-post`);
    const deptInput = document.getElementById(`${prefix}-dept`);
    const roleSelect = document.getElementById(`${prefix}-role`);
    const errorDiv = document.getElementById(`${prefix}-error`);
    
    const eid = eidInput.value.trim();
    const name = nameInput.value.trim();
    const post = postInput.value.trim();
    const dept = deptInput.value.trim();
    const role = roleSelect.value;
    
    errorDiv.classList.remove('show');
    
    // Validation
    if (!eid || !name || !post || !dept || !role) {
        errorDiv.textContent = 'Please fill all fields before adding a member';
        errorDiv.classList.add('show');
        return;
    }
    
    // Convert to number and check if employee exists
    const eidNumber = parseInt(eid);
    if (!employeeDatabase[eidNumber]) {
        errorDiv.textContent = 'Invalid Employee ID. Please enter a valid employee ID.';
        errorDiv.classList.add('show');
        return;
    }
    
    // Check role constraints (Chairman and Secretary can only be one across entire committee)
    if ((role === 'Chairman' || role === 'Secretary') && checkRoleConstraints(type, role)) {
        errorDiv.textContent = `Only one ${role} is allowed in the entire committee (across both Management and Worker representatives). Please select a different role or remove the existing ${role}.`;
        errorDiv.classList.add('show');
        return;
    }
    
    // Check for duplicate EID
    const members = type === 'management' ? managementMembers : workerMembers;
    const duplicateIndex = members.findIndex(m => parseInt(m.eid) === eidNumber);
    
    if (duplicateIndex !== -1 && (editingIndex.type !== type || editingIndex.index !== duplicateIndex)) {
        errorDiv.textContent = `Employee ${eidNumber} is already added to this category.`;
        errorDiv.classList.add('show');
        return;
    }
    
    const memberData = { eid: eidNumber, name, post, dept, role };
    
    // Add or update member
    if (editingIndex.type === type && editingIndex.index !== -1) {
        // Update existing member
        if (type === 'management') {
            managementMembers[editingIndex.index] = memberData;
        } else {
            workerMembers[editingIndex.index] = memberData;
        }
        editingIndex = { type: null, index: -1 };
    } else {
        // Add new member
        if (type === 'management') {
            managementMembers.push(memberData);
        } else {
            workerMembers.push(memberData);
        }
    }
    
    // Clear form
    clearMemberForm(type);
    
    // Update table
    updateTable(type);
    
    // Show success message briefly
    const successMsg = document.createElement('div');
    successMsg.className = 'success-message';
    successMsg.textContent = editingIndex.index !== -1 ? 'Member updated successfully!' : 'Member added successfully!';
    successMsg.style.cssText = 'position:fixed;top:100px;right:20px;background:#2e7d32;color:white;padding:15px 25px;border-radius:8px;z-index:9999;animation:slideIn 0.3s ease';
    document.body.appendChild(successMsg);
    setTimeout(() => successMsg.remove(), 2000);
}

// Clear member form
function clearMemberForm(type) {
    const prefix = type === 'management' ? 'mgmt' : 'worker';
    document.getElementById(`${prefix}-eid`).value = '';
    document.getElementById(`${prefix}-name`).value = '';
    document.getElementById(`${prefix}-post`).value = '';
    document.getElementById(`${prefix}-dept`).value = '';
    document.getElementById(`${prefix}-role`).value = '';
    document.getElementById(`${prefix}-eid`).classList.remove('input-valid', 'input-invalid');
    document.getElementById(`${prefix}-error`).classList.remove('show');
    
    // Reset editing state
    editingIndex = { type: null, index: -1 };
}

// Update table display
function updateTable(type) {
    const members = type === 'management' ? managementMembers : workerMembers;
    const tbody = document.getElementById(`${type}TableBody`);
    
    if (members.length === 0) {
        tbody.innerHTML = `
            <tr class="empty-row">
                <td colspan="6">No ${type} representatives added yet</td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = members.map((member, index) => `
        <tr>
            <td><strong>${member.eid}</strong></td>
            <td>${member.name}</td>
            <td>${member.post}</td>
            <td>${member.dept}</td>
            <td><span class="role-badge role-${member.role.toLowerCase()}">${member.role}</span></td>
            <td>
                <div class="action-buttons">
                    <button class="btn-edit" onclick="editMember('${type}', ${index})">
                        Edit
                    </button>
                    <button class="btn-delete" onclick="deleteMember('${type}', ${index})">
                        Delete
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

// Edit member
function editMember(type, index) {
    const prefix = type === 'management' ? 'mgmt' : 'worker';
    const members = type === 'management' ? managementMembers : workerMembers;
    const member = members[index];
    
    // Populate form with member data
    document.getElementById(`${prefix}-eid`).value = member.eid;
    document.getElementById(`${prefix}-name`).value = member.name;
    document.getElementById(`${prefix}-post`).value = member.post;
    document.getElementById(`${prefix}-dept`).value = member.dept;
    document.getElementById(`${prefix}-role`).value = member.role;
    
    // Mark EID as valid
    document.getElementById(`${prefix}-eid`).classList.add('input-valid');
    
    // Set editing state
    editingIndex = { type, index };
    
    // Scroll to form
    const formId = type === 'management' ? 'managementForm' : 'workerForm';
    document.getElementById(formId).scrollIntoView({ behavior: 'smooth', block: 'center' });
    
    // Highlight form
    const form = document.getElementById(formId);
    form.style.border = '3px solid #1976d2';
    setTimeout(() => {
        form.style.border = '';
    }, 2000);
}

// Delete member
function deleteMember(type, index) {
    if (!confirm('Are you sure you want to remove this member?')) {
        return;
    }
    
    if (type === 'management') {
        managementMembers.splice(index, 1);
    } else {
        workerMembers.splice(index, 1);
    }
    
    updateTable(type);
    
    // Show success message
    const successMsg = document.createElement('div');
    successMsg.className = 'success-message';
    successMsg.textContent = 'Member removed successfully!';
    successMsg.style.cssText = 'position:fixed;top:100px;right:20px;background:#d32f2f;color:white;padding:15px 25px;border-radius:8px;z-index:9999;animation:slideIn 0.3s ease';
    document.body.appendChild(successMsg);
    setTimeout(() => successMsg.remove(), 2000);
}

// Validate committee form
function validateCommitteeForm() {
    const committeeName = document.getElementById('committeeName').value.trim();
    const fromDate = document.getElementById('fromDate').value;
    const tillDate = document.getElementById('tillDate').value;
    
    if (!committeeName) {
        alert('Please enter committee name');
        return false;
    }
    
    if (!fromDate || !tillDate) {
        alert('Please select start and end dates');
        return false;
    }
    
    if (new Date(fromDate) >= new Date(tillDate)) {
        alert('End date must be after start date');
        return false;
    }
    
    if (managementMembers.length === 0) {
        alert('Please add at least one management representative');
        return false;
    }
    
    if (workerMembers.length === 0) {
        alert('Please add at least one worker representative');
        return false;
    }
    
    // Check if Chairman and Secretary exist across entire committee (not per category)
    const allMembers = [...managementMembers, ...workerMembers];
    const chairman = allMembers.find(m => m.role === 'Chairman');
    const secretary = allMembers.find(m => m.role === 'Secretary');
    
    if (!chairman) {
        alert('Committee must have exactly one Chairman (can be from either Management or Worker representatives)');
        return false;
    }
    
    if (!secretary) {
        alert('Committee must have exactly one Secretary (can be from either Management or Worker representatives)');
        return false;
    }
    
    return true;
}

// Submit committee
async function submitCommittee() {
    if (!validateCommitteeForm()) {
        return;
    }
    
    const committeeName = document.getElementById('committeeName').value.trim();
    const fromDate = document.getElementById('fromDate').value;
    const tillDate = document.getElementById('tillDate').value;
    
    // Prepare data for API
    const managementAPIMembers = managementMembers.map(m => ({
        employee_id: m.eid,
        role: m.role,
        member_type: 'Management'
    }));
    
    const workerAPIMembers = workerMembers.map(m => ({
        employee_id: m.eid,
        role: m.role,
        member_type: 'Working'
    }));
    
    const committeeData = {
        committee_name: committeeName,
        start_date: fromDate,
        end_date: tillDate,
        members: [...managementAPIMembers, ...workerAPIMembers]
    };
    
    try {
        // Show loading state
        const submitBtn = document.querySelector('.btn-submit');
        submitBtn.textContent = 'Creating Committee...';
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
        
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
        
        // Update the committee ID field to show the generated ID
        document.getElementById('committeeId').value = `HAL-COM-${result.committee_id}`;
        
        // Show success message with the generated ID
        const successModal = document.createElement('div');
        successModal.innerHTML = `
            <div style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:10000;display:flex;align-items:center;justify-content:center;">
                <div style="background:white;padding:30px;border-radius:12px;text-align:center;max-width:400px;box-shadow:0 10px 30px rgba(0,0,0,0.3);">
                    <div style="color:#2e7d32;font-size:48px;margin-bottom:15px;">✓</div>
                    <h2 style="color:#2e7d32;margin-bottom:15px;">Committee Created Successfully!</h2>
                    <p style="margin-bottom:20px;font-size:16px;">Your committee has been assigned ID:</p>
                    <div style="background:#e8f5e9;padding:15px;border-radius:8px;font-family:monospace;font-size:18px;font-weight:bold;color:#1b5e20;margin-bottom:20px;">HAL-COM-${result.committee_id}</div>
                    <button onclick="this.parentElement.parentElement.remove(); window.location.href='committee-view.html';" 
                            style="background:#1976d2;color:white;border:none;padding:12px 24px;border-radius:6px;cursor:pointer;font-size:16px;">Go to Dashboard</button>
                </div>
            </div>
        `;
        document.body.appendChild(successModal);
        
    } catch (error) {
        console.error('Error creating committee:', error);
        alert('Error creating committee: ' + error.message);
        
        // Reset button
        const submitBtn = document.querySelector('.btn-submit');
        submitBtn.textContent = 'Create Committee';
        submitBtn.classList.remove('loading');
        submitBtn.disabled = false;
    }
}
