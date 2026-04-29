const express = require('express');
const Enrollment = require('../models/Enrollment');
const router = express.Router();

router.post('/', async (req, res) => {
  const enrollment = await Enrollment.create(req.body);
  res.status(201).json(enrollment);
});

router.get('/', async (req, res) => {
  const enrollments = await Enrollment.find()
    .populate('student')
    .populate('course');
  res.json(enrollments);
});

router.get('/:id', async (req, res) => {
  const enrollment = await Enrollment.findById(req.params.id)
    .populate('student course');
  res.json(enrollment);
});

router.put('/:id', async (req, res) => {
  const enrollment = await Enrollment.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(enrollment);
});

router.delete('/:id', async (req, res) => {
  await Enrollment.findByIdAndDelete(req.params.id);
  res.json({ message: 'Enrollment deleted' });
});

module.exports = router;
