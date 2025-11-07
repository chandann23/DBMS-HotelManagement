# Hotel Management System

A full-stack hotel management system with customer booking portal and admin dashboard.

## Features

### Customer Portal
- Browse available rooms with filters (category, price range)
- Book rooms with date selection
- View booking history
- Real-time room availability

### Admin Dashboard
- **Dashboard**: Overview statistics (rooms, guests, reservations, revenue)
- **Room Management**: Add/edit rooms, view status
- **Guest Management**: Manage guest information
- **Staff Management**: Add/manage hotel staff
- **Reservation Management**: Create bookings, check-in/check-out
- **Payment Management**: Record and track payments
- **Services Management**: Manage hotel services

## Tech Stack

### Frontend
- React 19.2.0
- Axios for API calls
- Modern CSS with gradients and animations

### Backend
- Node.js with Express
- MySQL database
- mysql2 for database connection

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- MySQL Server
- npm or yarn

### Database Setup

1. Start MySQL server
2. Run the schema.sql file to create the database:
```bash
mysql -u root -p < schema.sql
```

This will create:
- Database: `hotel_management`
- Tables: Guest, Staff, Room, Reservation, Payment, Services, etc.
- Stored procedures: BookRoom, MakePayment
- Triggers for automatic status updates
- Sample data

### Backend Setup

1. Navigate to backend directory:
```bash
cd hotel-management-backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file with your database credentials:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=hotel_management
DB_PORT=3306
PORT=5000
```

4. Start the backend server:
```bash
npm start
# or for development with auto-reload
npm run dev
```

Backend will run on http://localhost:5000

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd hotel-management-frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

Frontend will run on http://localhost:3000

## Usage

### Landing Page
- Visit http://localhost:3000
- Browse hotel information, rooms, and amenities
- Click "Book Now" for customer portal or "Admin Login" for admin access

### Customer Login
- Enter your name and email
- Browse available rooms
- Select dates and book rooms
- View your bookings

### Admin Login
- Email: `admin@hotel.com`
- Password: `admin123`
- Access full admin dashboard

## API Endpoints

### Guests
- `GET /api/guests` - Get all guests
- `POST /api/guests` - Create new guest

### Rooms
- `GET /api/rooms` - Get all rooms
- `POST /api/rooms` - Add/update room

### Reservations
- `GET /api/reservations` - Get all reservations
- `POST /api/reservations` - Create reservation (calls BookRoom stored procedure)
- `PUT /api/reservations/:id/status` - Update reservation status

### Payments
- `GET /api/payments` - Get all payments
- `POST /api/payments` - Record payment (calls MakePayment stored procedure)

### Staff
- `GET /api/staff` - Get all staff
- `POST /api/staff` - Add staff member

### Services
- `GET /api/services` - Get all services
- `POST /api/services` - Add service

## Database Schema Highlights

### Key Tables
- **Guest**: Customer information with check-in status
- **Room**: Room inventory with status tracking
- **Reservation**: Booking records with dates and amounts
- **Payment**: Payment transactions
- **Staff**: Employee records
- **Services**: Hotel services catalog

### Stored Procedures
- **BookRoom**: Validates availability, calculates total, creates reservation
- **MakePayment**: Validates payment amount, records transaction

### Triggers
- Auto-update room status on check-in/check-out
- Audit logging for critical operations

## Project Structure

```
hotel-management-system/
├── hotel-management-backend/
│   ├── config/
│   │   └── db.js
│   ├── routes/
│   │   ├── guestRoutes.js
│   │   ├── roomRoutes.js
│   │   ├── reservationRoutes.js
│   │   ├── paymentRoutes.js
│   │   ├── staffRoutes.js
│   │   └── serviceRoutes.js
│   ├── .env
│   ├── server.js
│   └── package.json
├── hotel-management-frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   │   ├── LandingPage.jsx
│   │   │   ├── Login.jsx
│   │   │   ├── CustomerPortal.jsx
│   │   │   ├── AdminDashboard.jsx
│   │   │   ├── Dashboard.jsx
│   │   │   ├── Rooms.jsx
│   │   │   ├── Guests.jsx
│   │   │   ├── Staff.jsx
│   │   │   ├── Reservations.jsx
│   │   │   ├── Payments.jsx
│   │   │   └── Services.jsx
│   │   ├── api.js
│   │   ├── App.js
│   │   ├── App.css
│   │   └── index.js
│   └── package.json
└── schema.sql
```

## Features in Detail

### Room Booking Flow
1. Customer selects check-in and check-out dates
2. System filters available rooms
3. Customer selects room and confirms booking
4. System creates guest record (if new)
5. BookRoom stored procedure validates and creates reservation
6. Room status automatically updated to "Occupied"

### Payment Processing
1. Admin selects reservation
2. System shows total amount and amount paid
3. Admin enters payment amount and method
4. MakePayment stored procedure validates and records payment
5. System prevents overpayment

### Status Management
- Reservations: Confirmed → CheckedIn → CheckedOut
- Rooms: Available → Occupied → Available (with triggers)
- Automatic updates via database triggers

## Future Enhancements

- User authentication with JWT
- Email notifications for bookings
- Online payment integration
- Room service ordering
- Review and rating system
- Multi-language support
- Mobile responsive improvements
- Analytics and reporting

## License

MIT License

## Contributors

Hotel Management System - DBMS Project
