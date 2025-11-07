# Deployment Checklist

## ✅ Pre-Deployment Checklist

### Database
- [ ] MySQL server is installed and running
- [ ] Database `hotel_management` is created
- [ ] All tables are created from schema.sql
- [ ] Sample data is loaded
- [ ] Database user has proper permissions
- [ ] Connection credentials are secure

### Backend
- [ ] Node.js is installed (v14+)
- [ ] All npm packages are installed
- [ ] .env file is configured correctly
- [ ] Database connection is tested (`npm test`)
- [ ] Server starts without errors
- [ ] All API endpoints are accessible
- [ ] CORS is configured properly

### Frontend
- [ ] Node.js is installed (v14+)
- [ ] All npm packages are installed
- [ ] API baseURL points to correct backend
- [ ] Application builds without errors
- [ ] All pages load correctly
- [ ] Forms submit successfully
- [ ] Navigation works properly

## 🧪 Testing Checklist

### Customer Portal
- [ ] Landing page loads
- [ ] Navigation links work
- [ ] Login with customer credentials
- [ ] Browse rooms page displays rooms
- [ ] Filter by category works
- [ ] Filter by price works
- [ ] Date selection works
- [ ] Room booking succeeds
- [ ] Booking appears in "My Bookings"
- [ ] Logout works

### Admin Dashboard
- [ ] Login with admin credentials (admin@hotel.com / admin123)
- [ ] Dashboard shows statistics
- [ ] All navigation tabs work

#### Rooms Module
- [ ] View all rooms
- [ ] Add new room
- [ ] Room appears in list
- [ ] Status badges display correctly

#### Guests Module
- [ ] View all guests
- [ ] Add new guest
- [ ] All fields save correctly
- [ ] Check-in status displays

#### Staff Module
- [ ] View all staff
- [ ] Add new staff member
- [ ] Department dropdown works
- [ ] Join date is set

#### Reservations Module
- [ ] View all reservations
- [ ] Create new reservation
- [ ] Guest dropdown populates
- [ ] Room dropdown shows available rooms
- [ ] Date validation works
- [ ] Check-in button works
- [ ] Check-out button works
- [ ] Cancel button works
- [ ] Status updates correctly

#### Payments Module
- [ ] View all payments
- [ ] Reservation dropdown populates
- [ ] Amount due calculation is correct
- [ ] Record payment succeeds
- [ ] Payment appears in list
- [ ] Overpayment is prevented

#### Services Module
- [ ] View all services
- [ ] Add new service
- [ ] Service cards display correctly

## 🔍 Verification Steps

### 1. Database Verification
```bash
mysql -u root -p
USE hotel_management;
SHOW TABLES;
SELECT COUNT(*) FROM Room;
SELECT COUNT(*) FROM Guest;
SELECT COUNT(*) FROM Services;
```

### 2. Backend Verification
```bash
cd hotel-management-backend
npm test
# Should show: ✅ Connected to MySQL successfully!
```

### 3. API Verification
Open browser and test:
- http://localhost:5000/api/rooms
- http://localhost:5000/api/guests
- http://localhost:5000/api/services

Should return JSON data.

### 4. Frontend Verification
- Open http://localhost:3000
- Check browser console for errors (F12)
- Verify no 404 or 500 errors

## 🐛 Common Issues & Solutions

### Issue: Backend won't start
**Solution:**
```bash
# Check if port 5000 is in use
lsof -i :5000  # Mac/Linux
netstat -ano | findstr :5000  # Windows

# Kill process if needed
kill -9 <PID>  # Mac/Linux
taskkill /PID <PID> /F  # Windows
```

### Issue: Database connection fails
**Solution:**
1. Check MySQL is running: `mysql -u root -p`
2. Verify credentials in .env
3. Check database exists: `SHOW DATABASES;`
4. Verify user permissions

### Issue: Frontend can't connect to backend
**Solution:**
1. Verify backend is running on port 5000
2. Check api.js has correct baseURL
3. Check CORS is enabled in backend
4. Clear browser cache

### Issue: Booking fails
**Solution:**
1. Check room is available
2. Verify dates are valid (future dates)
3. Check guest exists
4. Look at browser console for errors
5. Check backend logs

### Issue: Payment fails
**Solution:**
1. Verify reservation exists
2. Check reservation status (must be Confirmed or CheckedIn)
3. Verify amount doesn't exceed total
4. Check backend logs for SQL errors

## 📦 Production Deployment

### Environment Variables
Update for production:
```env
# Backend .env
DB_HOST=your-production-db-host
DB_USER=your-production-db-user
DB_PASSWORD=your-secure-password
DB_NAME=hotel_management
DB_PORT=3306
PORT=5000
NODE_ENV=production
```

### Frontend Build
```bash
cd hotel-management-frontend
npm run build
# Deploy 'build' folder to web server
```

### Backend Deployment
```bash
cd hotel-management-backend
# Use PM2 or similar for process management
npm install -g pm2
pm2 start server.js --name hotel-backend
pm2 save
pm2 startup
```

### Security Checklist
- [ ] Change default admin password
- [ ] Use environment variables for secrets
- [ ] Enable HTTPS
- [ ] Set up firewall rules
- [ ] Regular database backups
- [ ] Update dependencies regularly
- [ ] Implement rate limiting
- [ ] Add request logging
- [ ] Set up monitoring

## 📊 Performance Checklist
- [ ] Database indexes are in place
- [ ] Connection pooling is configured
- [ ] Static assets are compressed
- [ ] Images are optimized
- [ ] Caching headers are set
- [ ] API responses are paginated (if needed)

## 🔐 Security Checklist
- [ ] SQL injection prevention (using parameterized queries)
- [ ] XSS prevention (React handles this)
- [ ] CSRF protection (if using sessions)
- [ ] Input validation on both client and server
- [ ] Secure password storage (if implementing auth)
- [ ] HTTPS enabled
- [ ] Security headers configured
- [ ] Rate limiting implemented

## 📱 Browser Compatibility
Test on:
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile browsers

## 🎯 Final Checks
- [ ] All features work as expected
- [ ] No console errors
- [ ] No broken links
- [ ] Forms validate properly
- [ ] Error messages are user-friendly
- [ ] Loading states display
- [ ] Success messages appear
- [ ] Data persists correctly
- [ ] Logout works properly
- [ ] Back button works

## 📝 Documentation
- [ ] README.md is complete
- [ ] API documentation is available
- [ ] Database schema is documented
- [ ] Setup instructions are clear
- [ ] Troubleshooting guide is provided

## 🎉 Ready for Demo!

Once all items are checked, your hotel management system is ready for:
- ✅ Demonstration
- ✅ User testing
- ✅ Production deployment
- ✅ Further development

---

**Good luck with your project! 🚀**
