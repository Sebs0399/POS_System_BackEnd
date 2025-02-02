const sql = require('mssql');

const config = {
  server: 'SEBASPC', 
  database: 'POS_system',
  user: 'pos_user',
  password: 'TuPasswordFuerte',
  options: {
    encrypt: false, 
    trustServerCertificate: true 
  }
};

async function connectDB() {
  try {
    await sql.connect(config);
    console.log('✅ Conexión exitosa');
  } catch (error) {
    console.error('❌ Error en la conexión:', error);
  }
}

module.exports = { sql, connectDB };

