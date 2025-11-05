// server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const guestsRouter = require('./routes/guestRoutes');
const staffRouter = require('./routes/staffRoutes');
const roomsRouter = require('./routes/roomRoutes');
const reservationsRouter = require('./routes/reservationRoutes');
const paymentsRouter = require('./routes/paymentRoutes');
const servicesRouter = require('./routes/serviceRoutes');
const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/guests', guestsRouter);
app.use('/api/staff', staffRouter);
app.use('/api/rooms', roomsRouter);
app.use('/api/reservations', reservationsRouter);
app.use('/api/payments', paymentsRouter);
app.use('/api/services', servicesRouter);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

