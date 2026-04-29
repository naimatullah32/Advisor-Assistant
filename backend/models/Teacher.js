const mongoose = require('mongoose');

const TeacherSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  name: String,
  designation: String,
  subject: String
});

module.exports = mongoose.model('Teacher', TeacherSchema);
