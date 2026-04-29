const express = require('express');
const Complaint = require('../models/Complaint');
const router = express.Router();

router.post('/', async (req, res) => {
  const complaint = await Complaint.create(req.body);
  res.status(201).json(complaint);
});

router.get('/', async (req, res) => {
  const complaints = await Complaint.find()
    .populate('student')
    .populate('comp_by');
  res.json(complaints);
});

router.get('/:id', async (req, res) => {
  const complaint = await Complaint.findById(req.params.id)
    .populate('student comp_by');
  res.json(complaint);
});

router.put('/:id', async (req, res) => {
  const complaint = await Complaint.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(complaint);
});

router.delete('/:id', async (req, res) => {
  await Complaint.findByIdAndDelete(req.params.id);
  res.json({ message: 'Complaint deleted' });
});

module.exports = router;
