const sql = require('mssql');
const dbConfig = require('../config/db');  // Archivo de configuración de conexión

// Obtener todas las compañías
const getAllCompanies = async () => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request().query('SELECT * FROM Companies');
    return result.recordset;
  } catch (error) {
    throw new Error('Error al obtener las compañías: ' + error.message);
  }
};

// Obtener una compañía por ID
const getCompanyById = async (id) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request()
                              .input('CompanyId', sql.Int, id)
                              .query('SELECT * FROM Companies WHERE CompanyId = @CompanyId');
    return result.recordset[0];
  } catch (error) {
    throw new Error('Error al obtener la compañía: ' + error.message);
  }
};

// Crear una nueva compañía
const createCompany = async (companyData) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request()
                              .input('Name', sql.NVarChar, companyData.Name)
                              .input('Address', sql.NVarChar, companyData.Address)
                              .input('Email', sql.NVarChar, companyData.Email)
                              .input('Phone', sql.NVarChar, companyData.Phone)
                              .query('INSERT INTO Companies (Name, Address, Email, Phone) OUTPUT INSERTED.CompanyId VALUES (@Name, @Address, @Email, @Phone)');
    return result.recordset[0].CompanyId;
  } catch (error) {
    throw new Error('Error al crear la compañía: ' + error.message);
  }
};

// Actualizar una compañía
const updateCompany = async (id, companyData) => {
  try {
    const pool = await sql.connect(dbConfig);
    await pool.request()
              .input('CompanyId', sql.Int, id)
              .input('Name', sql.NVarChar, companyData.Name)
              .input('Address', sql.NVarChar, companyData.Address)
              .input('Email', sql.NVarChar, companyData.Email)
              .input('Phone', sql.NVarChar, companyData.Phone)
              .query('UPDATE Companies SET Name = @Name, Address = @Address, Email = @Email, Phone = @Phone WHERE CompanyId = @CompanyId');
    return id;
  } catch (error) {
    throw new Error('Error al actualizar la compañía: ' + error.message);
  }
};

// Eliminar una compañía
const deleteCompany = async (id) => {
  try {
    const pool = await sql.connect(dbConfig);
    await pool.request()
              .input('CompanyId', sql.Int, id)
              .query('DELETE FROM Companies WHERE CompanyId = @CompanyId');
    return id;
  } catch (error) {
    throw new Error('Error al eliminar la compañía: ' + error.message);
  }
};

module.exports = {
  getAllCompanies,
  getCompanyById,
  createCompany,
  updateCompany,
  deleteCompany
};
