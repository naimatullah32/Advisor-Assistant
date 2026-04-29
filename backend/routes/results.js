const express = require('express');
const Result = require('../models/Result');
const router = express.Router();

router.post('/', async (req, res) => {
  const result = await Result.create(req.body);
  res.status(201).json(result);
});

router.get('/', async (req, res) => {
  const results = await Result.find()
    .populate('student')
    .populate('course');
  res.json(results);
});

router.get('/:id', async (req, res) => {
  const result = await Result.findById(req.params.id)
    .populate('student course');
  res.json(result);
});

router.put('/:id', async (req, res) => {
  const result = await Result.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(result);
});

router.delete('/:id', async (req, res) => {
  await Result.findByIdAndDelete(req.params.id);
  res.json({ message: 'Result deleted' });
});

module.exports = router;
