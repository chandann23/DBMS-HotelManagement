const express = require('express');
const router = express.Router();
const pool = require('../config/db');
// GET payments
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.*, r.Guest_ID, g.Name AS GuestName
       FROM Payment p
       JOIN Reservation r ON p.Reservation_ID = r.Reservation_ID
       JOIN Guest g ON r.Guest_ID = g.Guest_ID
       ORDER BY p.Payment_Date DESC`
    );
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST make payment (calls stored procedure)
router.post('/', async (req, res) => {
  try {
    const { reservationId, amount, method } = req.body;
    const conn = await pool.getConnection();
    try {
      await conn.query('CALL MakePayment(?, ?, ?)', [reservationId, amount, method]);
      res.json({ message: 'Payment recorded' });
    } catch (spErr) {
      res.status(400).json({ error: spErr.message });
    } finally {
      conn.release();
    }
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;

