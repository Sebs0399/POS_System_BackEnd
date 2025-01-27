const sql = require('mssql');
//mejora: agregar variables de entorno .ENV
const config = {
  user: 'sa', 
  password: 'sebastian0399', 
  server: 'DDC-CO-SCastro', 
  database: 'POS_system', 
  options: {
    encrypt: true, 
    trustServerCertificate: true 
  }
};

async function connectDB() {
  try {
    await sql.connect(config);
    console.log('Conexión exitosa a la base de datos');

    // Verificación adicional con una consulta simple
    const result = await sql.query('SELECT 1 AS TestConnection');
    console.log('Consulta exitosa:', result.recordset);
  } catch (error) {
    console.error('Error en la conexión a la base de datos:', error);
  }
}

module.exports = { sql, connectDB };
