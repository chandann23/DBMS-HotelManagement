// Simple script to test database connection
require('dotenv').config();
const mysql = require('mysql2/promise');

async function testConnection() {
  console.log('🔍 Testing database connection...\n');
  
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: process.env.DB_PORT || 3306
    });

    console.log('✅ Connected to MySQL successfully!\n');

    // Test queries
    const [rooms] = await connection.query('SELECT COUNT(*) as count FROM Room');
    console.log(`📊 Rooms in database: ${rooms[0].count}`);

    const [guests] = await connection.query('SELECT COUNT(*) as count FROM Guest');
    console.log(`👥 Guests in database: ${guests[0].count}`);

    const [reservations] = await connection.query('SELECT COUNT(*) as count FROM Reservation');
    console.log(`📅 Reservations in database: ${reservations[0].count}`);

    const [staff] = await connection.query('SELECT COUNT(*) as count FROM Staff');
    console.log(`👔 Staff members in database: ${staff[0].count}`);

    const [services] = await connection.query('SELECT COUNT(*) as count FROM Services');
    console.log(`🛎️  Services in database: ${services[0].count}`);

    console.log('\n✨ All tests passed! Your database is ready.\n');

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ Connection failed:', error.message);
    console.error('\n💡 Tips:');
    console.error('   - Check if MySQL is running');
    console.error('   - Verify credentials in .env file');
    console.error('   - Make sure database "hotel_management" exists');
    console.error('   - Run: mysql -u root -p < schema.sql\n');
    process.exit(1);
  }
}

testConnection();
