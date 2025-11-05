const express = require('express');
const router = express.Router();

const pool = require('../config/db');

// GET all rooms
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Room ORDER BY Room_No');
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST add/update room
router.post('/', async (req, res) => {
  try {
    const { Room_No, Category, Rent } = req.body;
    const [existing] = await pool.query('SELECT Room_No FROM Room WHERE Room_No = ?', [Room_No]);
    if (existing.length) {
      await pool.query('UPDATE Room SET Category=?, Rent=? WHERE Room_No=?', [Category, Rent, Room_No]);
      return res.json({ message: 'Room updated' });
    } else {
      await pool.query('INSERT INTO Room (Room_No, Category, Rent) VALUES (?, ?, ?)', [Room_No, Category, Rent]);
      return res.json({ message: 'Room created' });
    }
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;

