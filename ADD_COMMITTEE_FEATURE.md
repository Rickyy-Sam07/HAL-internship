# Enhanced Add Committee Feature - Documentation

## Overview
The Add Committee feature has been completely redesigned to use a **dedicated full page** instead of a modal popup, providing a better user experience with real-time preview and advanced editing capabilities.

## New Features

### 1. **Dedicated Page Interface**
- Full-screen page (`add-committee.html`) instead of modal popup
- Better space for displaying information
- Cleaner, more organized layout
- Professional form design with sections

### 2. **Separate Representative Tables**
- **Management Representatives Table**
  - Add unlimited management representatives
  - Real-time preview of added members
  - Shows EID, Name, Post, Department, Role
  
- **Worker Representatives Table**
  - Add unlimited worker representatives
  - Separate table from management
  - Same detailed information display

### 3. **Role Constraints** ⭐
- **Chairman**: Only ONE per category (Management/Worker)
- **Secretary**: Only ONE per category (Management/Worker)
- **Member**: UNLIMITED per category
- Automatic validation prevents duplicate Chairman/Secretary
- Clear error messages when constraint is violated

### 4. **Live Preview Tables**
- Real-time updates as you add members
- Instantly see all added representatives
- Color-coded role badges:
  - 🟠 **Chairman** - Orange badge
  - 🔵 **Secretary** - Blue badge
  - 🟢 **Member** - Green badge
- Empty state when no members added

### 5. **Edit Functionality** ✏️
- Click **Edit** button next to any member
- Form auto-populates with member's data
- Modify any field (EID, Role, etc.)
- Re-add to update the member
- Form highlights during edit mode
- Smooth scroll to form section

### 6. **Delete Functionality** 🗑️
- Click **Delete** button to remove member
- Confirmation dialog before deletion
- Instant table update after removal
- Success notification after deletion

### 7. **Auto-Generated Committee ID**
- Committee ID field shows "Auto-generated"
- Backend assigns ID automatically on creation
- Displayed in success message after creation
- Format: `HAL-COM-{number}`

### 8. **Advanced Validation**
- ✅ All required fields checked
- ✅ EID validation against employee database
- ✅ Date validation (end date > start date)
- ✅ At least one management rep required
- ✅ At least one worker rep required
- ✅ Chairman and Secretary must exist in both categories
- ✅ Role constraint validation
- ✅ Duplicate EID prevention
- ✅ Real-time error messages

## User Flow

### Step 1: Access the Page
1. Login to the system
2. Click **"ADD DATA"** button on dashboard
3. Redirects to `add-committee.html`

### Step 2: Fill Committee Information
```
Committee Name: Works Committee 2025
Start Date: 2025-01-01
End Date: 2025-12-31
```

### Step 3: Add Management Representatives
1. Enter EID (e.g., HAL001)
2. Auto-fills Name, Post, Department
3. Select Role (Chairman/Secretary/Member)
4. Click **"+ Add Management Rep"**
5. Member appears in table below
6. Repeat for more members

### Step 4: Add Worker Representatives
1. Enter EID (e.g., HAL101)
2. Auto-fills employee details
3. Select Role (Chairman/Secretary/Member)
4. Click **"+ Add Worker Rep"**
5. Member appears in table below
6. Repeat for more members

### Step 5: Edit/Delete Members (Optional)
- **Edit**: Click Edit → Form populates → Modify → Re-add
- **Delete**: Click Delete → Confirm → Member removed

### Step 6: Submit Committee
1. Review all information
2. Click **"Create Committee"**
3. Validation checks run
4. Committee created in backend
5. Success message with Committee ID
6. Redirect to dashboard

## Role Constraint Rules

### Chairman Constraint
```
Management: ✅ Only 1 Chairman allowed
Workers: ✅ Only 1 Chairman allowed
Total: Maximum 2 Chairmen (1 per category)
```

### Secretary Constraint
```
Management: ✅ Only 1 Secretary allowed
Workers: ✅ Only 1 Secretary allowed
Total: Maximum 2 Secretaries (1 per category)
```

### Member Role
```
Management: ✅ Unlimited Members
Workers: ✅ Unlimited Members
```

### Example Valid Committee
```
Management Representatives:
├── HAL001 - John Doe - Chairman
├── HAL002 - Jane Smith - Secretary
├── HAL003 - Bob Johnson - Member
└── HAL004 - Alice Brown - Member

Worker Representatives:
├── HAL101 - Mike Wilson - Chairman
├── HAL102 - Sarah Davis - Secretary
├── HAL103 - Tom Anderson - Member
└── HAL104 - Emma Martinez - Member
```

## Validation Examples

### ✅ Valid Scenarios
- Add multiple members with different roles
- One Chairman + One Secretary + Many Members per category
- Edit member role if no constraint violation
- Delete and re-add members

### ❌ Invalid Scenarios
```
Error: "Only one Chairman is allowed per category"
→ Trying to add 2nd Chairman when 1 already exists

Error: "Only one Secretary is allowed per category"
→ Trying to add 2nd Secretary when 1 already exists

Error: "Employee HAL001 is already added to this category"
→ Trying to add duplicate EID

Error: "Invalid EID. Please enter a valid employee ID"
→ EID not found in database

Error: "Management representatives must have at least one Chairman and one Secretary"
→ Trying to submit without required roles
```

## Technical Implementation

### Files Structure
```
HAL-Internship/
├── add-committee.html          # Main page HTML
├── styles/
│   └── add-committee.css      # Page-specific styles
└── js/
    └── add-committee.js       # Page logic & validation
```

### Key JavaScript Functions
```javascript
fetchEmployeeInfo(type)         // Auto-fetch employee by EID
addMember(type)                 // Add member to list
editMember(type, index)         // Edit existing member
deleteMember(type, index)       // Remove member
checkRoleConstraints(type, role)// Validate role limits
updateTable(type)               // Refresh preview table
submitCommittee()               // Create committee via API
```

### API Integration
```javascript
POST /api/committee/create
Body: {
  committee_name: "Works Committee 2025",
  start_date: "2025-01-01",
  end_date: "2025-12-31",
  members: [
    { employee_id: "HAL001", role: "Chairman", member_type: "Management" },
    { employee_id: "HAL002", role: "Secretary", member_type: "Management" },
    { employee_id: "HAL101", role: "Chairman", member_type: "Working" },
    { employee_id: "HAL102", role: "Secretary", member_type: "Working" }
  ]
}

Response: {
  message: "Committee created successfully",
  committee_id: 4
}
```

## Benefits

### For Users
✅ **Better UX** - Full page with more space
✅ **Real-time Feedback** - Instant table updates
✅ **Easy Editing** - Modify members anytime
✅ **Clear Constraints** - Role limits clearly shown
✅ **Less Errors** - Comprehensive validation

### For Admins
✅ **Data Integrity** - Role constraints enforced
✅ **Audit Trail** - Clear member lists before submission
✅ **Flexibility** - Easy to add/remove members
✅ **Error Prevention** - Multiple validation layers

## Testing Checklist

### Basic Functionality
- [ ] Page loads correctly
- [ ] User session validated
- [ ] Employee database loaded
- [ ] EID auto-fetch works
- [ ] All form fields functional

### Role Constraints
- [ ] Can add 1 Chairman per category
- [ ] Cannot add 2nd Chairman
- [ ] Can add 1 Secretary per category
- [ ] Cannot add 2nd Secretary
- [ ] Can add unlimited Members
- [ ] Error messages show correctly

### Edit/Delete
- [ ] Edit button populates form
- [ ] Can modify member details
- [ ] Update saves correctly
- [ ] Delete button works
- [ ] Confirmation dialog appears
- [ ] Table updates after delete

### Validation
- [ ] Required fields validated
- [ ] Date validation works
- [ ] EID validation works
- [ ] Duplicate EID prevented
- [ ] Chairman/Secretary required
- [ ] Success message shows
- [ ] Redirect to dashboard works

## Troubleshooting

### Issue: "Employee not found"
**Solution**: Use valid EIDs (HAL001-HAL028 for Management, HAL101-HAL128 for Workers)

### Issue: "Role constraint error"
**Solution**: Delete existing Chairman/Secretary before adding new one, or use Member role

### Issue: "Form doesn't populate on Edit"
**Solution**: Ensure JavaScript is loaded, check browser console for errors

### Issue: "Committee not created"
**Solution**: Ensure all validations pass, check backend is running

## Future Enhancements (Optional)

- [ ] Drag-and-drop member ordering
- [ ] Bulk import from CSV
- [ ] Member search/filter in tables
- [ ] Role change bulk actions
- [ ] Print preview before submission
- [ ] Save draft functionality
- [ ] Committee templates

---

**Version**: 1.0
**Last Updated**: November 3, 2025
**Author**: HAL Internship Team
