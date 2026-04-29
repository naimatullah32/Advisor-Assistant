const mongoose = require('mongoose');

const ParentSchema = new mongoose.Schema({
  name: String,
  address: String,
  occupation: String,
  contact: String,
  student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' }
});

module.exports = mongoose.model('Parent', ParentSchema);
