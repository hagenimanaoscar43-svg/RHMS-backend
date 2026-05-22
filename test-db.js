require("dotenv").config();
const { Pool } = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

pool.query("SELECT NOW()")
  .then(res => {
    console.log("✅ Connected to Neon!");
    console.log(res.rows[0]);
    process.exit();
  })
  .catch(err => {
    console.error("❌ Connection failed:", err.message);
    process.exit();
  });