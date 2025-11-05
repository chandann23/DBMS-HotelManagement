const express = require('express');
const router = express.Router();

const pool = require('../config/db');

// GET services
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Services ORDER BY Service_ID DESC');
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST add service
router.post('/', async (req, res) => {
  try {
    const { Service_Name, Description, Charges } = req.body;
    const [result] = await pool.query(
      'INSERT INTO Services (Service_Name, Description, Charges) VALUES (?, ?, ?)',
      [Service_Name, Description, Charges]
    );
    res.json({ insertedId: result.insertId });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;

