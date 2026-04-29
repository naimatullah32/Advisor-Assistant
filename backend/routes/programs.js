const express = require('express');
const Program = require('../models/Program');
const router = express.Router();

router.post('/', async (req, res) => {
  const program = await Program.create(req.body);
  res.status(201).json(program);
});

router.get('/', async (req, res) => {
  const programs = await Program.find();
  res.json(programs);
});

router.get('/:id', async (req, res) => {
  const program = await Program.findById(req.params.id);
  res.json(program);
});

router.put('/:id', async (req, res) => {
  const program = await Program.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(program);
});

router.delete('/:id', async (req, res) => {
  await Program.findByIdAndDelete(req.params.id);
  res.json({ message: 'Program deleted' });
});

module.exports = router;
