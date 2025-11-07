# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Database Setup (2 minutes)

1. Make sure MySQL is running
2. Open terminal and run:
```bash
mysql -u root -p < schema.sql
```
3. Enter your MySQL password when prompted

### Step 2: Backend Setup (1 minute)

1. Open a new terminal
2. Navigate to backend:
```bash
cd hotel-management-backend
```

3. Create `.env` file:
```bash
# On Linux/Mac
cat > .env << EOF
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=hotel_management
DB_PORT=3306
PORT=5000
EOF

# On Windows, create .env file manually with above content
```

4. Install and start:
```bash
npm install
npm start
```

You should see: `✅ Connected to MySQL` and `Server running on port 5000`

### Step 3: Frontend Setup (2 minutes)

1. Open another terminal
2. Navigate to frontend:
```bash
cd hotel-management-frontend
```

3. Install and start:
```bash
npm install
npm start
```

Browser will automatically open at http://localhost:3000

## 🎉 You're Ready!

### Try the Customer Portal:
1. Click "Book Now" on landing page
2. Enter your name and email
3. Browse and book rooms

### Try the Admin Dashboard:
1. Click "Admin Login" on landing page
2. Use credentials:
   - Email: `admin@hotel.com`
   - Password: `admin123`
3. Explore all management features

## 🐛 Troubleshooting

### Backend won't start?
- Check if MySQL is running: `mysql -u root -p`
- Verify database exists: `SHOW DATABASES;` (should see `hotel_management`)
- Check `.env` file has correct credentials

### Frontend won't start?
- Make sure backend is running first
- Check if port 3000 is available
- Try: `npm install` again

### Can't connect to database?
- Verify MySQL credentials in `.env`
- Check if MySQL is running on port 3306
- Try: `mysql -u root -p -e "SELECT 1"`

### Booking not working?
- Make sure backend is running on port 5000
- Check browser console for errors (F12)
- Verify rooms are available in admin panel

## 📱 What to Test

### Customer Features:
- ✅ Browse rooms with filters
- ✅ Select dates and book rooms
- ✅ View booking history

### Admin Features:
- ✅ Dashboard statistics
- ✅ Add/manage rooms
- ✅ Add guests and staff
- ✅ Create reservations
- ✅ Record payments
- ✅ Manage services

## 🎯 Sample Data

The database comes pre-loaded with:
- 10 rooms (various categories)
- 8 services (Room Service, Spa, etc.)
- 5 staff members
- 4 sample guests

## 💡 Tips

1. **Customer Booking**: Dates must be in the future
2. **Admin Reservations**: Guest must exist before booking
3. **Payments**: Can only pay for confirmed/checked-in reservations
4. **Room Status**: Automatically updates on check-in/check-out

## 🔗 URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000/api
- **Test API**: http://localhost:5000/api/rooms

## 📞 Need Help?

Check the main README.md for detailed documentation!
