const mongoose = require('mongoose');

const ComplaintSchema = new mongoose.Schema({
  title: String,
  description: String,
  status: String,
  submitted_date: Date,
  feedback: String,
  student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  comp_by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});

module.exports = mongoose.model('Complaint', ComplaintSchema);
