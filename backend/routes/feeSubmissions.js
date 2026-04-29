const express = require('express');
const FeeSubmission = require('../models/FeeSubmission');
const router = express.Router();

/* CREATE */
router.post('/', async (req, res) => {
  const submission = await FeeSubmission.create(req.body);
  res.status(201).json(submission);
});

/* READ ALL */
router.get('/', async (req, res) => {
  const submissions = await FeeSubmission.find().populate('student');
  res.json(submissions);
});

/* READ ONE */
router.get('/:id', async (req, res) => {
  const submission = await FeeSubmission.findById(req.params.id)
    .populate('student');
  res.json(submission);
});

/* UPDATE */
router.put('/:id', async (req, res) => {
  const submission = await FeeSubmission.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(submission);
});

/* DELETE */
router.delete('/:id', async (req, res) => {
  await FeeSubmission.findByIdAndDelete(req.params.id);
  res.json({ message: 'Fee submission deleted' });
});

module.exports = router;
