const express = require('express');
const Batch = require('../models/Batch');
const router = express.Router();

router.post('/', async (req, res) => {
  const batch = await Batch.create(req.body);
  res.status(201).json(batch);
});

router.get('/', async (req, res) => {
  const batches = await Batch.find();
  res.json(batches);
});

router.get('/:id', async (req, res) => {
  const batch = await Batch.findById(req.params.id);
  res.json(batch);
});

router.put('/:id', async (req, res) => {
  const batch = await Batch.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(batch);
});

router.delete('/:id', async (req, res) => {
  await Batch.findByIdAndDelete(req.params.id);
  res.json({ message: 'Batch deleted' });
});

module.exports = router;
