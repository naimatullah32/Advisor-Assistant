const express = require('express');
const Attendance = require('../models/Attendance');
const router = express.Router();

router.post('/', async (req, res) => {
  const attendance = await Attendance.create(req.body);
  res.status(201).json(attendance);
});

router.get('/', async (req, res) => {
  const records = await Attendance.find()
    .populate('student')
    .populate('course');
  res.json(records);
});

router.get('/:id', async (req, res) => {
  const record = await Attendance.findById(req.params.id)
    .populate('student course');
  res.json(record);
});

router.put('/:id', async (req, res) => {
  const record = await Attendance.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(record);
});

router.delete('/:id', async (req, res) => {
  await Attendance.findByIdAndDelete(req.params.id);
  res.json({ message: 'Attendance deleted' });
});

module.exports = router;
