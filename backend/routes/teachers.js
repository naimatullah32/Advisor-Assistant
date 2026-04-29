const express = require('express');
const Teacher = require('../models/Teacher');
const router = express.Router();

router.post('/', async (req, res) => {
  const teacher = await Teacher.create(req.body);
  res.status(201).json(teacher);
});

router.get('/', async (req, res) => {
  const teachers = await Teacher.find().populate('user');
  res.json(teachers);
});

router.get('/:id', async (req, res) => {
  const teacher = await Teacher.findById(req.params.id).populate('user');
  res.json(teacher);
});

router.put('/:id', async (req, res) => {
  const teacher = await Teacher.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(teacher);
});

router.delete('/:id', async (req, res) => {
  await Teacher.findByIdAndDelete(req.params.id);
  res.json({ message: 'Teacher deleted' });
});

module.exports = router;
