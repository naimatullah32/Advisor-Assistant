const express = require('express');
const FeeSchedule = require('../models/FeeSchedule');
const router = express.Router();

router.get('/test', (req, res) => {
  res.send('Students route is working');
});

/* CREATE */
router.post('/', async (req, res) => {
  const feeSchedule = await FeeSchedule.create(req.body);
  res.status(201).json(feeSchedule);
});

/* READ ALL */
router.get('/', async (req, res) => {
  const schedules = await FeeSchedule.find().populate('program');
  res.json(schedules);
});

/* READ ONE */
router.get('/:id', async (req, res) => {
  const schedule = await FeeSchedule.findById(req.params.id).populate('program');
  res.json(schedule);
});

/* UPDATE */
router.put('/:id', async (req, res) => {
  const schedule = await FeeSchedule.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(schedule);
});

/* DELETE */
router.delete('/:id', async (req, res) => {
  await FeeSchedule.findByIdAndDelete(req.params.id);
  res.json({ message: 'Fee schedule deleted' });
});

module.exports = router;
