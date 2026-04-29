const mongoose = require('mongoose');

const CourseSchema = new mongoose.Schema({
  course_code: String,
  course_title: String,
  credit_hrs: Number,
  program: { type: mongoose.Schema.Types.ObjectId, ref: 'Program' }
});

module.exports = mongoose.model('Course', CourseSchema);
