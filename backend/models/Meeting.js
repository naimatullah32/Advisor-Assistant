const mongoose = require('mongoose');

const MeetingSchema = new mongoose.Schema({
  title: String,
  meeting_by: String,
  date: Date,
  time: String,
  description: String,
  teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'Teacher' },
  student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' }
});

module.exports = mongoose.model('Meeting', MeetingSchema);
