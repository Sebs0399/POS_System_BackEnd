const express = require('express');
const router = express.Router();
const companiesService = require('../services/companiesService');

// Obtener todas las compañías
router.get('/', async (req, res) => {
  try {
    const companies = await companiesService.getAllCompanies();
    res.status(200).json(companies);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Obtener una compañía por ID
router.get('/:id', async (req, res) => {
  try {
    const company = await companiesService.getCompanyById(req.params.id);
    if (company) {
      res.status(200).json(company);
    } else {
      res.status(404).json({ message: 'Compañía no encontrada' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Crear una nueva compañía
router.post('/', async (req, res) => {
  try {
    const companyData = req.body;
    const companyId = await companiesService.createCompany(companyData);
    res.status(201).json({ message: 'Compañía creada', companyId });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Actualizar una compañía
router.put('/:id', async (req, res) => {
  try {
    const companyData = req.body;
    const updatedCompanyId = await companiesService.updateCompany(req.params.id, companyData);
    res.status(200).json({ message: 'Compañía actualizada', companyId: updatedCompanyId });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Eliminar una compañía
router.delete('/:id', async (req, res) => {
  try {
    await companiesService.deleteCompany(req.params.id);
    res.status(200).json({ message: 'Compañía eliminada' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
