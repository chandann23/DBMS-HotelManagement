# Features Guide - Hotel Management System

## 🏠 Landing Page

### Navigation Bar
- **Logo**: Grand Hotel with hotel icon
- **Links**: Home, Rooms, Amenities, Contact
- **Buttons**: 
  - "Book Now" (Customer Portal)
  - "Admin Login" (Admin Dashboard)

### Hero Section
- Large gradient background (purple to pink)
- Main heading: "Welcome to Grand Hotel"
- Subtitle: "Experience Luxury & Comfort Like Never Before"
- Two call-to-action buttons

### Features Section
Six feature cards with icons:
1. 🛏️ **Luxury Rooms** - Spacious and elegant
2. 🍽️ **Fine Dining** - World-class restaurants
3. 💆 **Spa & Wellness** - Premium spa services
4. 🏊 **Swimming Pool** - Olympic-sized pool
5. 🚗 **Free Parking** - Complimentary valet
6. 📶 **High-Speed WiFi** - Free internet

### Room Types Section
Four room cards with gradient backgrounds:
1. **Single Room** - ₹1,500/night (Purple gradient)
2. **Double Room** - ₹2,500/night (Pink gradient)
3. **Suite** - ₹5,000/night (Blue gradient)
4. **Deluxe Room** - ₹7,500/night (Green gradient)

Each card has a "Book Now" button.

### Contact Section
- Address, phone, email information
- Contact form with fields:
  - Your Name
  - Your Email
  - Your Message
  - Send Message button

### Footer
- Company description
- Quick links
- Social media links
- Copyright notice

---

## 🔐 Login Page

### Customer Login
- Name input field
- Email input field
- "Continue to Booking" button
- Back to Home button

### Admin Login
- Email input field
- Password input field
- "Login to Dashboard" button
- Demo credentials shown
- Back to Home button

---

## 👥 Customer Portal

### Header
- Hotel logo and name
- Welcome message with user name
- Navigation tabs:
  - Browse Rooms (active by default)
  - My Bookings
  - Logout button

### Browse Rooms Page

#### Filter Section
Five filter inputs in a row:
1. **Category** dropdown (All, Single, Double, Suite, Deluxe)
2. **Min Price** input
3. **Max Price** input
4. **Check-in** date picker
5. **Check-out** date picker

#### Room Grid
Cards displaying available rooms:
- Room number (large, colored)
- Room category
- Price per night
- Availability status badge (green)
- Calculated total for selected dates
- "Book Now" button

Features:
- Real-time filtering
- Price calculation based on nights
- Only shows available rooms
- Responsive grid layout

### My Bookings Page

Table showing user's reservations:
- Booking ID
- Room number and category
- Check-in date
- Check-out date
- Total amount
- Status badge (color-coded)

Empty state message if no bookings.

---

## 👨‍💼 Admin Dashboard

### Header
- Hotel logo and name
- "Admin: [Name]" label
- Navigation tabs:
  - Dashboard
  - Rooms
  - Guests
  - Staff
  - Reservations
  - Payments
  - Services
  - Logout button

---

### 📊 Dashboard Page

#### Statistics Cards (4 cards in a row)
1. **Total Rooms** (Purple gradient)
   - Total count
   - Available vs Occupied breakdown

2. **Total Guests** (Pink gradient)
   - Total count
   - Checked-in count

3. **Reservations** (Blue gradient)
   - Total count
   - Active reservations count

4. **Total Revenue** (Green gradient)
   - Total amount
   - Number of payments

#### Recent Reservations Table
Shows last 5 reservations with:
- ID, Guest, Room, Dates, Status, Amount

---

### 🛏️ Rooms Page

#### Add Room Form
Fields in a row:
- Room Number (number input)
- Category (dropdown: Single, Double, Suite, Deluxe)
- Rent per night (number input)
- "Save Room" button

#### Rooms Table
Columns:
- Room No (bold)
- Category
- Rent (₹ symbol)
- Status (colored badge)
- Last Cleaned date

Status badges:
- Green: Available
- Red: Occupied
- Yellow: Maintenance
- Gray: Cleaning

---

### 👥 Guests Page

#### Add Guest Form
Fields in a row:
- Full Name (required)
- Contact Number (required)
- Email (required)
- Nationality
- Gender (dropdown: Male, Female, Other)
- "Add Guest" button

#### Guests Table
Columns:
- ID
- Name
- Contact
- Email
- Nationality
- Gender
- Status (Checked-in / Not Checked-in badge)

---

### 👔 Staff Page

#### Add Staff Form
Fields in a row:
- Name (required)
- Department (dropdown: Front Desk, Housekeeping, Kitchen, Maintenance, Management)
- Age (number)
- Contact (required)
- Salary (number)
- "Add Staff" button

#### Staff Table
Columns:
- ID
- Name
- Department
- Age
- Contact
- Salary (₹ symbol)
- Join Date

---

### 📅 Reservations Page

#### Create Reservation Form
Fields in a row:
- Guest (dropdown with name and email)
- Room (dropdown with room number, category, and price)
- Check-in Date (date picker, min: today)
- Check-out Date (date picker, min: check-in date)
- "Create Reservation" button

#### Reservations Table
Columns:
- ID
- Guest name
- Room (number and category)
- Check-in date
- Check-out date
- Amount (₹ symbol)
- Status (colored badge)
- Actions (buttons based on status)

Action buttons:
- **Confirmed**: "Check In" (green), "Cancel" (red)
- **CheckedIn**: "Check Out" (gray), "Cancel" (red)
- **CheckedOut**: No actions
- **Cancelled**: No actions

Status colors:
- Blue: Confirmed
- Yellow: CheckedIn
- Gray: CheckedOut
- Red: Cancelled

---

### 💳 Payments Page

#### Record Payment Form
Fields in a row:
- Reservation (dropdown showing: ID, Guest, Room, Total, Paid, Due)
- Amount (auto-filled with total, editable)
- Payment Method (dropdown: Cash, Card, UPI, Online)
- "Record Payment" button

#### Payments Table
Columns:
- Payment ID
- Reservation ID
- Guest name
- Amount (₹ symbol)
- Method
- Date (with time)
- Status (Completed badge)

Features:
- Shows amount already paid
- Shows amount due
- Prevents overpayment
- Only shows active reservations

---

### 🛎️ Services Page

#### Add Service Form
Fields in a row:
- Service Name (required)
- Description (wider field)
- Charges (number, required)
- "Add Service" button

#### Services Grid
Cards displaying services:
- Service name (large, colored)
- Description
- Price (₹ symbol)
- "Active" status badge

Examples:
- Room Service - ₹200
- Laundry - ₹150
- Spa - ₹1,500
- Airport Transfer - ₹800
- Extra Bed - ₹500
- Breakfast - ₹300
- Mini Bar - ₹250
- Gym Access - ₹100

---

## 🎨 Design Elements

### Color Scheme
- Primary: Purple (#667eea)
- Secondary: Pink (#764ba2)
- Success: Green (#10b981)
- Danger: Red (#ef4444)
- Warning: Yellow (#f59e0b)
- Info: Blue (#3b82f6)

### Typography
- Headings: Bold, large
- Body: Regular, readable
- Labels: Medium weight, smaller

### Buttons
- Primary: Purple background, white text
- Success: Green background
- Danger: Red background
- Secondary: Gray background
- Outline: Transparent with border

### Cards
- White background
- Rounded corners (12px)
- Shadow on hover
- Smooth transitions

### Forms
- Light gray background
- Rounded inputs
- Purple focus border
- Inline layout
- Validation messages

### Tables
- Striped rows on hover
- Bordered cells
- Header with gray background
- Responsive design

### Status Badges
- Rounded pill shape
- Color-coded backgrounds
- Small, uppercase text
- Inline display

---

## 📱 Responsive Features

### Mobile Adaptations
- Stacked navigation
- Single column forms
- Scrollable tables
- Touch-friendly buttons
- Larger tap targets
- Simplified layouts

### Tablet Adaptations
- Two-column grids
- Flexible forms
- Optimized spacing
- Readable typography

### Desktop Features
- Multi-column layouts
- Hover effects
- Larger displays
- Side-by-side forms

---

## ✨ Interactive Features

### Animations
- Button hover effects
- Card lift on hover
- Smooth transitions
- Fade in/out messages
- Loading spinners

### Feedback
- Success messages (green)
- Error messages (red)
- Info messages (blue)
- Auto-dismiss after 3-4 seconds

### Validation
- Required field indicators
- Real-time validation
- Error highlighting
- Helpful error messages

### User Experience
- Smooth scrolling
- Keyboard navigation
- Focus indicators
- Loading states
- Empty states
- Confirmation dialogs (via alerts)

---

## 🎯 Key User Flows

### Customer Books a Room
1. Land on homepage
2. Click "Book Now"
3. Enter name and email
4. Browse available rooms
5. Filter by preferences
6. Select dates
7. Click "Book Now" on desired room
8. See success message
9. View booking in "My Bookings"

### Admin Checks In Guest
1. Login as admin
2. Go to Reservations
3. Find confirmed reservation
4. Click "Check In"
5. Status updates to CheckedIn
6. Room status updates automatically

### Admin Records Payment
1. Go to Payments
2. Select reservation from dropdown
3. See amount due
4. Enter payment amount
5. Select payment method
6. Click "Record Payment"
7. Payment appears in table

---

This guide covers all visual and functional aspects of the hotel management system!
