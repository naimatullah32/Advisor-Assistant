// models/Student.js
const mongoose = require('mongoose');

const StudentSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Required hata dya temporarily
  std_id: { type: String, unique: true },
  std_name: String,
  section: String,
  semester_no: Number,
  batch: { type: mongoose.Schema.Types.ObjectId, ref: 'Batch' },
  program: { type: mongoose.Schema.Types.ObjectId, ref: 'Program' },
  department: { type: mongoose.Schema.Types.ObjectId, ref: 'Department' }
});

module.exports = mongoose.model('Student', StudentSchema);