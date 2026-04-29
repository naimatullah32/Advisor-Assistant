const mongoose = require('mongoose');

const SessionSchema = new mongoose.Schema({
  session_name: String,
  start_date: Date,
  end_date: Date
});

module.exports = mongoose.model('Session', SessionSchema);
