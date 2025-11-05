const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,   // ✅ Must match your .env variable
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306,   // ✅ Add port if needed
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Optional: Check if connection works
pool.getConnection()
  .then(() => console.log("✅ Connected to MySQL"))
  .catch(err => console.error("❌ DB Connection Error:", err.message));

module.exports = pool;

