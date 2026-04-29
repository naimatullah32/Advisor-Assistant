const express = require('express');
const Parent = require('../models/Parent');
const router = express.Router();

router.post('/', async (req, res) => {
  const parent = await Parent.create(req.body);
  res.status(201).json(parent);
});

router.get('/', async (req, res) => {
  const parents = await Parent.find().populate('student');
  res.json(parents);
});

router.get('/:id', async (req, res) => {
  const parent = await Parent.findById(req.params.id).populate('student');
  res.json(parent);
});

router.put('/:id', async (req, res) => {
  const parent = await Parent.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(parent);
});

router.delete('/:id', async (req, res) => {
  await Parent.findByIdAndDelete(req.params.id);
  res.json({ message: 'Parent deleted' });
});

module.exports = router;
