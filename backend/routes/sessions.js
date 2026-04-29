const express = require('express');
const Session = require('../models/Session');
const router = express.Router();

router.post('/', async (req, res) => {
  const session = await Session.create(req.body);
  res.status(201).json(session);
});

router.get('/', async (req, res) => {
  const sessions = await Session.find();
  res.json(sessions);
});

router.get('/:id', async (req, res) => {
  const session = await Session.findById(req.params.id);
  res.json(session);
});

router.put('/:id', async (req, res) => {
  const session = await Session.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  res.json(session);
});

router.delete('/:id', async (req, res) => {
  await Session.findByIdAndDelete(req.params.id);
  res.json({ message: 'Session deleted' });
});

module.exports = router;
