const mongoose = require('mongoose');

const FeeSubmissionSchema = new mongoose.Schema({
  student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  amount: Number,
  paid_date: Date
});

module.exports = mongoose.model('FeeSubmission', FeeSubmissionSchema);
