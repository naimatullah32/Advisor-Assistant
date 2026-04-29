const mongoose = require('mongoose');

const BatchSchema = new mongoose.Schema({
  batch_id: String,
  start_year: Number,
  end_year: Number
});

module.exports = mongoose.model('Batch', BatchSchema);
