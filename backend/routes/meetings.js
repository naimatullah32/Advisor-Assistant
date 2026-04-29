const express = require('express');
const Meeting = require('../models/Meeting');
const router = express.Router();

router.post('/', async (req, res) => {
  const meeting = await Meeting.create(req.body);
  res.status(201).json(meeting);
});

router.get('/', async (req, res) => {
  const meetings = await Meeting.find()
    .populate('teacher')
    .populate('student');
  res.json(meetings);
});

router.get('/:id', async (req, res) => {
  const meeting = await Meeting.findById(req.params.id)
    .populate('teacher student');
  res.json(meeting);
});

router.put('/:id', async (req, res) => {
  const meeting = await Meeting.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(meeting);
});

router.delete('/:id', async (req, res) => {
  await Meeting.findByIdAndDelete(req.params.id);
  res.json({ message: 'Meeting deleted' });
});

module.exports = router;
