# Committee Management System

A beautiful, dynamic web application with **React Components** for managing committee information at HAL.

## 🚀 NEW! React-Powered Features

### ✨ 5 Cool React Components Added:

1. **📊 Animated Stats Counter**
   - Numbers count up from 0 when scrolled into view
   - Shows total committees, management reps, and worker reps
   - Beautiful gradient cards with hover effects

2. **🎴 3D Flip Committee Cards**
   - Click any card to flip and see full representative details
   - Smooth 3D animations with perspective transforms
   - Search term highlighting in real-time
   - Hover effects with lift and shadow

3. **🔍 Smart Search Bar**
   - Live autocomplete suggestions as you type
   - Shows top 5 matching committees in a beautiful dropdown
   - Click any suggestion to auto-scroll to that committee
   - Animated entrance with staggered items

4. **🎪 Recent Committees Carousel**
   - Auto-rotating showcase of top 5 recent committees
   - Play/Pause control for user preference
   - Click any slide to scroll to full details
   - Navigation dots for manual control
   - Shimmer effect and glassmorphism design

5. **🎯 Enhanced Search Experience**
   - Real-time filtering with instant results
   - "No results" state with beautiful empty message
   - Highlighted search terms in committee cards

### 🎨 Technical Stack:
- **React 18** - Modern functional components with hooks
- **Babel Standalone** - JSX transformation in browser
- **CSS-in-JS** - Inline styles for component isolation
- **Intersection Observer API** - Scroll-triggered animations
- **Vanilla JavaScript** - For legacy form handling

## Features

### Public Access (All Users)
- 🔍 **Search Functionality**: Search committees by name or ID
- 👀 **View Committee Details**: See all committee information including:
  - Committee name and ID
  - Duration (From date and Till date)
  - Management Representatives (Post, Department, EID)
  - Worker Representatives (Post, Department, EID)
- 📱 **Responsive Design**: Works on all devices
- ✨ **Beautiful UI**: Modern gradient design with smooth animations

### Admin Access (After Login)
- ➕ **Add Committee Data**: Create new committee entries
- ✏️ **Edit Data**: Modify committee information while adding
- 💾 **Save & Continue**: Save progress and keep editing
- ✅ **Submit**: Finalize and publish committee data
- 🔒 **Login Protection**: Only authenticated users can add/modify data

## Files

1. **committee-view.html** - Main page with React components and committee display
2. **login.html** - Admin login page with premium design
3. **README.md** - This documentation file
4. **REACT_COMPONENTS.md** - Detailed React components documentation
5. **PREMIUM_FEATURES.md** - Premium features documentation
6. **SETUP_INSTRUCTIONS.md** - Setup and deployment guide

## How to Use

### For Regular Users
1. Open `committee-view.jsp` in your browser
2. Browse all committees
3. Use the search box to find specific committees
4. View detailed information about representatives

### For Admins
1. Click "ADD DATA" button on the main page
2. You'll be redirected to login page
3. Enter credentials:
   - **Username**: `admin`
   - **Password**: `admin123`
4. After login, a modal will appear
5. Fill in committee details:
   - Committee name and ID
   - Duration (from and till dates)
   - Add management representatives (Post, Dept, EID)
   - Add worker representatives (Post, Dept, EID)
6. Click "Save & Continue Editing" to save and keep editing
7. Click "Submit" to finalize and publish
8. Edit button disappears after submission

## Mock Data

The system comes with 3 pre-loaded committees:
1. Safety & Health Committee
2. Welfare Committee
3. Training & Development Committee

## Technical Details

### Technologies Used
- **React 18** - Modern UI components with hooks
- HTML5
- CSS3 (with modern gradients and animations)
- JavaScript (ES6+)
- JSX (Babel transformation)
- Responsive Design

### Key Features Implementation

#### React Components
```javascript
// 5 Major Components:
1. StatsCounter - Animated number counting
2. AnimatedCommitteeCard - 3D flip cards
3. SmartSearchBar - Live autocomplete
4. RecentCommitteesCarousel - Auto-rotating slides
5. ReactEnhancedApp - Main container
```

#### Search Functionality
```javascript
function searchCommittees() {
    // React-powered live search
    // Shows suggestions dropdown
    // Highlights matching text
    // Auto-scrolls to results
}
```

#### Dynamic Representative Addition
- Add/remove management representatives dynamically
- Add/remove worker representatives dynamically
- Validates all fields before submission

#### Login Protection
- Redirects to login when "ADD DATA" is clicked
- Validates credentials
- Opens modal only after successful login

#### Edit vs Submit
- **Save**: Keeps edit functionality active
- **Submit**: Finalizes data and hides edit button

## Deployment

### For JSP Server (Tomcat, etc.)
1. Copy `committee-view.jsp` and `login.jsp` to your web application directory
2. Deploy to your servlet container
3. Access via: `http://localhost:8080/your-app/committee-view.jsp`

### For Quick Testing (HTML mode)
1. Rename files to `.html` extension
2. Open directly in browser
3. All features work except server-side session management

## Future Enhancements

- [ ] Connect to real database
- [ ] Implement server-side authentication
- [ ] Add user management
- [ ] Export committee data to PDF/Excel
- [ ] Email notifications
- [ ] Audit trail for changes
- [ ] Advanced search filters
- [ ] File attachments for committees

## Browser Support

- ✅ Chrome (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ✅ Mobile browsers

## Security Notes

⚠️ **Important**: The current implementation uses client-side authentication for demonstration purposes only. For production use:

1. Implement server-side session management
2. Use secure password hashing
3. Add CSRF protection
4. Implement role-based access control
5. Use HTTPS
6. Validate all inputs on the server side

## Contact

For issues or questions, contact the HAL IT Department.

---

**Version**: 1.0  
**Last Updated**: October 29, 2025  
**Author**: HAL Internship Project
