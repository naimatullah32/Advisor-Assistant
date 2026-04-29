const mongoose = require('mongoose');

const ProgramSchema = new mongoose.Schema({
  program_name: String
});

module.exports = mongoose.model('Program', ProgramSchema);
