const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

connectDB();

const app = express();
app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
  res.send('API running');
});

/* ROUTES */
app.use('/api/users', require('./routes/users'));
app.use('/api/students', require('./routes/student'));
app.use('/api/parents', require('./routes/parents'));
app.use('/api/teachers', require('./routes/teachers'));
app.use('/api/advisors', require('./routes/advisors'));
app.use('/api/programs', require('./routes/programs'));
app.use('/api/batches', require('./routes/batches'));
app.use('/api/courses', require('./routes/courses'));
app.use('/api/enrollments', require('./routes/enrollments'));
app.use('/api/attendance', require('./routes/attendance'));
app.use('/api/complaints', require('./routes/complaints'));
app.use('/api/meetings', require('./routes/meetings'));
app.use('/api/results', require('./routes/results'));
app.use('/api/fee-schedules', require('./routes/feeSchedules'));
app.use('/api/fee-submissions', require('./routes/feeSubmissions'));
app.use('/api/sessions', require('./routes/sessions'));

module.exports = app;
