const express = require('express');
const router = express.Router();
const pool = require('../config/db');
// GET reservations
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT r.*, g.Name as GuestName, rm.Category as RoomCategory, rm.Rent as RoomRent
       FROM Reservation r
       JOIN Guest g ON r.Guest_ID = g.Guest_ID
       JOIN Room rm ON r.Room_No = rm.Room_No
       ORDER BY r.Booking_Date DESC`
    );
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST create reservation (calls stored procedure BookRoom)
router.post('/', async (req, res) => {
  try {
    const { guestId, roomNo, checkIn, checkOut } = req.body;
    const conn = await pool.getConnection();
    try {
      await conn.query('CALL BookRoom(?, ?, ?, ?)', [guestId, roomNo, checkIn, checkOut]);
      res.json({ message: 'Reservation created' });
    } catch (spErr) {
      res.status(400).json({ error: spErr.message });
    } finally {
      conn.release();
    }
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// PUT update reservation status (e.g., CheckedIn, CheckedOut)
router.put('/:id/status', async (req, res) => {
  try {
    const reservationId = req.params.id;
    const { status } = req.body;
    await pool.query('UPDATE Reservation SET Status = ? WHERE Reservation_ID = ?', [status, reservationId]);
    res.json({ message: 'Status updated' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;

