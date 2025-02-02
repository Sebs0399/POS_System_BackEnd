const express = require('express');
const { connectDB } = require('./config/db.js'); // Ruta correcta
const companiesRoutes = require('./routes/companiesRoutes');
const bodyParser = require('body-parser');

const app = express();

// Conexión a la base de datos
connectDB();

app.use(bodyParser.json()); // Parsear JSON en las solicitudes

// Ruta principal
app.use('/api/companies', companiesRoutes);


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});



