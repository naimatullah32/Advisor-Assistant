const express = require('express');
const Course = require('../models/Course');
const router = express.Router();

router.post('/', async (req, res) => {
  const course = await Course.create(req.body);
  res.status(201).json(course);
});

router.get('/', async (req, res) => {
  const courses = await Course.find().populate('program');
  res.json(courses);
});

router.get('/:id', async (req, res) => {
  const course = await Course.findById(req.params.id).populate('program');
  res.json(course);
});

router.put('/:id', async (req, res) => {
  const course = await Course.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(course);
});

router.delete('/:id', async (req, res) => {
  await Course.findByIdAndDelete(req.params.id);
  res.json({ message: 'Course deleted' });
});

module.exports = router;
