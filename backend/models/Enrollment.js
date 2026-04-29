const mongoose = require('mongoose');

const EnrollmentSchema = new mongoose.Schema({
  student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  course: { type: mongoose.Schema.Types.ObjectId, ref: 'Course' },
  enroll_date: Date,
  status: String,
  section: String
});

module.exports = mongoose.model('Enrollment', EnrollmentSchema);
