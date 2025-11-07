# Hotel Management System - Architecture Explained

## 🏗️ System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER'S BROWSER                          │
│                     (http://localhost:3000)                     │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              REACT FRONTEND (Port 3000)                   │ │
│  │                                                            │ │
│  │  Components:                                               │ │
│  │  - LandingPage.jsx                                         │ │
│  │  - Login.jsx                                               │ │
│  │  - CustomerPortal.jsx                                      │ │
│  │  - AdminDashboard.jsx                                      │ │
│  │  - Dashboard.jsx, Rooms.jsx, Guests.jsx, etc.             │ │
│  │                                                            │ │
│  │  API Client (api.js):                                      │ │
│  │  - axios configured to http://localhost:5000/api           │ │
│  └──────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ HTTP Requests (axios)
                              ↓ (GET, POST, PUT)
┌─────────────────────────────────────────────────────────────────┐
│                    NODE.JS BACKEND (Port 5000)                  │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    server.js (Express)                    │ │
│  │                                                            │ │
│  │  Middleware:                                               │ │
│  │  - CORS (allows frontend to connect)                      │ │
│  │  - express.json() (parses JSON requests)                  │ │
│  │                                                            │ │
│  │  Routes:                                                   │ │
│  │  - /api/guests      → guestRoutes.js                      │ │
│  │  - /api/rooms       → roomRoutes.js                       │ │
│  │  - /api/reservations → reservationRoutes.js               │ │
│  │  - /api/payments    → paymentRoutes.js                    │ │
│  │  - /api/staff       → staffRoutes.js                      │ │
│  │  - /api/services    → serviceRoutes.js                    │ │
│  └──────────────────────────────────────────────────────────┘ │
│                              ↓                                  │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              config/db.js (Connection Pool)               │ │
│  │                                                            │ │
│  │  mysql2/promise:                                           │ │
│  │  - Creates connection pool (max 10 connections)           │ │
│  │  - Reads credentials from .env file                       │ │
│  │  - Maintains persistent connections                       │ │
│  └──────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ SQL Queries
                              ↓ (SELECT, INSERT, UPDATE, CALL)
┌─────────────────────────────────────────────────────────────────┐
│                    MYSQL DATABASE (Port 3306)                   │
│                                                                 │
│  Database: hotel_management                                     │
│                                                                 │
│  Tables:                                                        │
│  ┌────────────┐  ┌────────────┐  ┌──────────────┐            │
│  │   Guest    │  │    Room    │  │ Reservation  │            │
│  ├────────────┤  ├────────────┤  ├──────────────┤            │
│  │ Guest_ID   │  │ Room_No    │  │Reservation_ID│            │
│  │ Name       │  │ Category   │  │ Guest_ID (FK)│            │
│  │ Email      │  │ Rent       │  │ Room_No (FK) │            │
│  │ Contact    │  │ Status     │  │ Check_In_Date│            │
│  └────────────┘  └────────────┘  │ Check_Out_Date│           │
│                                   │ Total_Amount │            │
│  ┌────────────┐  ┌────────────┐  └──────────────┘            │
│  │  Payment   │  │   Staff    │                               │
│  ├────────────┤  ├────────────┤  ┌──────────────┐            │
│  │ Payment_ID │  │ Staff_ID   │  │  Services    │            │
│  │Reservation │  │ Name       │  ├──────────────┤            │
│  │   _ID (FK) │  │ Dept       │  │ Service_ID   │            │
│  │ Amount     │  │ Salary     │  │ Service_Name │            │
│  └────────────┘  └────────────┘  │ Charges      │            │
│                                   └──────────────┘            │
│  Stored Procedures:                                            │
│  - BookRoom(guestId, roomNo, checkIn, checkOut)               │
│  - MakePayment(reservationId, amount, method)                 │
│                                                                 │
│  Triggers:                                                      │
│  - Auto-update room status on reservation changes             │
│  - Auto-update guest check-in status                          │
│  - Audit logging                                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Database: MySQL

### What is MySQL?
MySQL is a **relational database management system (RDBMS)** that stores data in structured tables with relationships between them.

### Why MySQL for this project?
1. **Relational Data**: Hotel data has clear relationships (guests have reservations, reservations have payments)
2. **ACID Compliance**: Ensures data integrity for financial transactions
3. **Stored Procedures**: Business logic can be stored in the database
4. **Triggers**: Automatic actions when data changes
5. **Widely Used**: Industry standard for web applications

### Database Structure

#### Tables and Their Purpose:

**1. Guest Table**
```sql
CREATE TABLE Guest (
    Guest_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Nationality VARCHAR(50),
    Gender ENUM('Male', 'Female', 'Other'),
    Check_In_Status BOOLEAN DEFAULT FALSE
);
```
- Stores customer information
- `Check_In_Status` tracks if guest is currently checked in
- `Email` is unique (no duplicate guests)

**2. Room Table**
```sql
CREATE TABLE Room (
    Room_No INT PRIMARY KEY,
    Category ENUM('Single', 'Double', 'Suite', 'Deluxe'),
    Rent DECIMAL(10, 2) NOT NULL,
    Status ENUM('Available', 'Occupied', 'Maintenance', 'Cleaning')
);
```
- Stores room inventory
- `Status` tracks current room state
- `Rent` is price per night

**3. Reservation Table**
```sql
CREATE TABLE Reservation (
    Reservation_ID INT PRIMARY KEY AUTO_INCREMENT,
    Guest_ID INT NOT NULL,
    Room_No INT NOT NULL,
    Check_In_Date DATE NOT NULL,
    Check_Out_Date DATE NOT NULL,
    Total_Amount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Confirmed', 'CheckedIn', 'CheckedOut', 'Cancelled'),
    FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID),
    FOREIGN KEY (Room_No) REFERENCES Room(Room_No)
);
```
- Links guests to rooms
- Stores booking dates and total cost
- `FOREIGN KEY` ensures data integrity (can't book non-existent guest/room)

**4. Payment Table**
```sql
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Reservation_ID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Payment_Method ENUM('Cash', 'Card', 'UPI', 'Online'),
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID)
);
```
- Tracks all payments
- Linked to reservations
- Supports partial payments

**5. Staff Table**
```sql
CREATE TABLE Staff (
    Staff_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Dept VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Contact_Info VARCHAR(20) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Join_Date DATE NOT NULL
);
```
- Employee records
- Department and salary tracking

**6. Services Table**
```sql
CREATE TABLE Services (
    Service_ID INT PRIMARY KEY AUTO_INCREMENT,
    Service_Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    Charges DECIMAL(10, 2) NOT NULL
);
```
- Hotel services catalog
- Room service, spa, etc.

---

## 🔌 How Backend Connects to Database

### Step 1: Database Configuration (config/db.js)

```javascript
const mysql = require('mysql2/promise');
require('dotenv').config();

// Create connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,        // 'localhost'
  user: process.env.DB_USER,        // 'root'
  password: process.env.DB_PASSWORD, // your MySQL password
  database: process.env.DB_NAME,    // 'hotel_management'
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,              // Max 10 simultaneous connections
  queueLimit: 0
});

// Test connection
pool.getConnection()
  .then(() => console.log("✅ Connected to MySQL"))
  .catch(err => console.error("❌ DB Connection Error:", err.message));

module.exports = pool;
```

**What happens here:**
1. Reads database credentials from `.env` file
2. Creates a **connection pool** (reusable database connections)
3. Tests the connection on startup
4. Exports `pool` for use in routes

**Why Connection Pool?**
- Reuses connections instead of creating new ones
- Faster performance
- Handles multiple requests simultaneously

### Step 2: Environment Variables (.env)

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=hotel_management
DB_PORT=3306
PORT=5000
```

**Why .env file?**
- Keeps sensitive data (passwords) out of code
- Easy to change for different environments (dev, production)
- Not committed to version control

---

## 🛣️ Backend Routes Explained

### Example: Guest Routes (routes/guestRoutes.js)

```javascript
const express = require('express');
const router = express.Router();
const pool = require('../config/db');  // Import database connection

// GET all guests
router.get('/', async (req, res) => {
  try {
    // Execute SQL query
    const [rows] = await pool.query('SELECT * FROM Guest ORDER BY Guest_ID DESC');
    // Send JSON response
    res.json(rows);
  } catch (err) {
    // Send error response
    res.status(500).json({ error: err.message });
  }
});

// POST create new guest
router.post('/', async (req, res) => {
  try {
    // Extract data from request body
    const { Name, Contact_Info, Email, Nationality, Gender } = req.body;
    
    // Execute INSERT query with parameterized values (prevents SQL injection)
    const [result] = await pool.query(
      'INSERT INTO Guest (Name, Contact_Info, Email, Nationality, Gender) VALUES (?, ?, ?, ?, ?)',
      [Name, Contact_Info, Email, Nationality, Gender]
    );
    
    // Send success response
    res.json({ insertedId: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
```

**Flow:**
1. Frontend sends HTTP request → `axios.get('/api/guests')`
2. Express routes request to `guestRoutes.js`
3. Route handler executes SQL query using `pool.query()`
4. MySQL returns data
5. Backend sends JSON response to frontend
6. Frontend receives data and updates UI

### Example: Reservation Routes (with Stored Procedure)

```javascript
router.post('/', async (req, res) => {
  try {
    const { guestId, roomNo, checkIn, checkOut } = req.body;
    const conn = await pool.getConnection();
    
    try {
      // Call stored procedure
      await conn.query('CALL BookRoom(?, ?, ?, ?)', 
        [guestId, roomNo, checkIn, checkOut]);
      res.json({ message: 'Reservation created' });
    } catch (spErr) {
      res.status(400).json({ error: spErr.message });
    } finally {
      conn.release();  // Return connection to pool
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
```

**What's happening:**
1. Gets a connection from the pool
2. Calls `BookRoom` stored procedure in MySQL
3. Stored procedure validates data and creates reservation
4. Releases connection back to pool
5. Sends response to frontend

---

## 🌐 How Frontend Connects to Backend

### Step 1: API Configuration (src/api.js)

```javascript
import axios from 'axios';

const API = axios.create({
  baseURL: 'http://localhost:5000/api',  // Backend URL
  timeout: 6000,                          // 6 second timeout
});

export default API;
```

**What is axios?**
- JavaScript library for making HTTP requests
- Simpler than native `fetch()`
- Automatically handles JSON parsing

### Step 2: Using API in Components

**Example: Dashboard.jsx**

```javascript
import API from '../api';

export default function Dashboard() {
  const [rooms, setRooms] = useState([]);
  
  useEffect(() => {
    // Make GET request to backend
    API.get('/rooms')
      .then(response => {
        // Backend sends: { data: [...rooms] }
        setRooms(response.data);
      })
      .catch(error => {
        console.error('Failed to load rooms');
      });
  }, []);
  
  return (
    <div>
      {rooms.map(room => (
        <div key={room.Room_No}>
          Room {room.Room_No} - {room.Category}
        </div>
      ))}
    </div>
  );
}
```

**Flow:**
1. Component mounts → `useEffect` runs
2. `API.get('/rooms')` sends request to `http://localhost:5000/api/rooms`
3. Backend receives request
4. Backend queries MySQL: `SELECT * FROM Room`
5. MySQL returns room data
6. Backend sends JSON response
7. Frontend receives response
8. `setRooms(response.data)` updates state
9. React re-renders component with new data

**Example: Creating a Guest**

```javascript
const add = async () => {
  try {
    // POST request with data
    await API.post('/guests', {
      Name: 'John Doe',
      Contact_Info: '1234567890',
      Email: 'john@example.com',
      Nationality: 'India',
      Gender: 'Male'
    });
    
    // Reload guests after adding
    const res = await API.get('/guests');
    setGuests(res.data);
    
    alert('Guest added successfully');
  } catch (err) {
    alert(err.response?.data?.error || 'Failed to add guest');
  }
};
```

**Flow:**
1. User fills form and clicks "Add Guest"
2. `API.post('/guests', data)` sends POST request
3. Backend receives data in `req.body`
4. Backend executes INSERT query
5. MySQL adds guest to database
6. Backend sends success response
7. Frontend reloads guest list
8. UI updates with new guest

---

## 🔄 Complete Request Flow Example

### Scenario: Customer Books a Room

**1. User Action (Frontend)**
```javascript
// CustomerPortal.jsx
const handleBookRoom = async (roomNo) => {
  await API.post('/reservations', {
    guestId: 5,
    roomNo: 101,
    checkIn: '2025-01-15',
    checkOut: '2025-01-20'
  });
};
```

**2. HTTP Request**
```
POST http://localhost:5000/api/reservations
Content-Type: application/json

{
  "guestId": 5,
  "roomNo": 101,
  "checkIn": "2025-01-15",
  "checkOut": "2025-01-20"
}
```

**3. Backend Receives (server.js)**
```javascript
app.use('/api/reservations', reservationsRouter);
```

**4. Route Handler (reservationRoutes.js)**
```javascript
router.post('/', async (req, res) => {
  const { guestId, roomNo, checkIn, checkOut } = req.body;
  const conn = await pool.getConnection();
  
  await conn.query('CALL BookRoom(?, ?, ?, ?)', 
    [guestId, roomNo, checkIn, checkOut]);
  
  res.json({ message: 'Reservation created' });
  conn.release();
});
```

**5. Database Executes (MySQL)**
```sql
CALL BookRoom(5, 101, '2025-01-15', '2025-01-20');

-- Stored procedure does:
-- 1. Validates dates
-- 2. Checks room availability
-- 3. Calculates total amount (5 nights × room rent)
-- 4. Creates reservation
-- 5. Updates room status to 'Occupied'
-- 6. Updates guest check-in status
```

**6. Database Response**
```
Reservation created with ID: 42
```

**7. Backend Response**
```json
{
  "message": "Reservation created"
}
```

**8. Frontend Updates**
```javascript
// Success! Show message and reload bookings
showMessage('success', 'Room booked successfully!');
loadMyBookings();
```

---

## 🔐 Security Features

### 1. Parameterized Queries (Prevents SQL Injection)

**❌ UNSAFE (Don't do this):**
```javascript
const query = `INSERT INTO Guest VALUES ('${name}', '${email}')`;
// If name = "'; DROP TABLE Guest; --" → Database destroyed!
```

**✅ SAFE (What we use):**
```javascript
const query = 'INSERT INTO Guest (Name, Email) VALUES (?, ?)';
await pool.query(query, [name, email]);
// MySQL escapes special characters automatically
```

### 2. CORS (Cross-Origin Resource Sharing)

```javascript
// server.js
const cors = require('cors');
app.use(cors());  // Allows frontend (port 3000) to access backend (port 5000)
```

### 3. Error Handling

```javascript
try {
  // Database operation
} catch (err) {
  // Don't expose internal errors to users
  res.status(500).json({ error: 'Operation failed' });
  // Log detailed error server-side
  console.error(err);
}
```

---

## 📈 Performance Optimizations

### 1. Connection Pooling
- Reuses database connections
- Faster than creating new connections
- Handles concurrent requests

### 2. Indexes in Database
```sql
CREATE INDEX idx_email ON Guest(Email);
CREATE INDEX idx_status ON Room(Status);
```
- Speeds up searches
- Faster queries

### 3. Async/Await
```javascript
// Multiple requests in parallel
const [rooms, guests, reservations] = await Promise.all([
  API.get('/rooms'),
  API.get('/guests'),
  API.get('/reservations')
]);
```
- Loads data simultaneously
- Faster page loads

---

## 🎯 Summary

### Database (MySQL)
- **What**: Relational database storing all hotel data
- **Where**: Runs on port 3306
- **Tables**: Guest, Room, Reservation, Payment, Staff, Services
- **Features**: Stored procedures, triggers, foreign keys

### Backend (Node.js + Express)
- **What**: API server handling business logic
- **Where**: Runs on port 5000
- **Routes**: /api/guests, /api/rooms, etc.
- **Connection**: Uses mysql2 with connection pooling

### Frontend (React)
- **What**: User interface
- **Where**: Runs on port 3000
- **API Client**: axios configured to backend URL
- **Components**: LandingPage, CustomerPortal, AdminDashboard, etc.

### Data Flow
```
User clicks button
  → React component calls API
    → axios sends HTTP request
      → Express routes to handler
        → Handler queries MySQL
          → MySQL returns data
        → Handler sends JSON response
      → axios receives response
    → React updates state
  → UI re-renders with new data
```

This architecture is **scalable**, **maintainable**, and follows **industry best practices**! 🚀
