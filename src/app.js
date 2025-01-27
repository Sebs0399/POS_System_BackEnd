const express = require('express');
const { connectDB } = require('./config/db.js'); // Ruta correcta

const app = express();

// Conexión a la base de datos
connectDB();

// Ruta principal
app.get('/', (req, res) => {
  res.send('¡Hola, Mundo!');
});

// Endpoint de prueba para verificar la conexión a la base de datos
app.get('/test-db', async (req, res) => {
  try {
    // Realizamos una consulta de prueba
    const result = await sql.query('SELECT 1 AS TestConnection');
    res.send('Conexión exitosa a la base de datos');
  } catch (error) {
    res.status(500).send('Error en la conexión a la base de datos');
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});
