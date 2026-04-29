const mongoose = require('mongoose');

const AdvisorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  section: { type: String, required: true },
  // Ref ka matlab hai ke ye ID Teacher collection se match honi chahiye
  teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'Teacher' },
  batch: { type: mongoose.Schema.Types.ObjectId, ref: 'Batch' }
});

module.exports = mongoose.model('Advisor', AdvisorSchema);