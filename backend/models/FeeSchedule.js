const mongoose = require('mongoose');

const FeeScheduleSchema = new mongoose.Schema({
  amount: Number,
  installment_no: Number,
  last_date: Date,
  program: { type: mongoose.Schema.Types.ObjectId, ref: 'Program' }
});

module.exports = mongoose.model('FeeSchedule', FeeScheduleSchema);
