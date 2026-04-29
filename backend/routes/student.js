// const express = require('express');
// const Student = require('../models/Student');
// const router = express.Router();

// router.get('/test', (req, res) => {
//   res.send('Students route is working');
// });

// router.post('/', async (req, res) => {
//   const student = await Student.create(req.body);
//   res.status(201).json(student);
// });

// router.get('/', async (req, res) => {
//   const students = await Student.find()
//     .populate('user')
//     .populate('batch')
//     .populate('parents');
//   res.json(students);
// });

// router.get('/:id', async (req, res) => {
//   const student = await Student.findById(req.params.id)
//     .populate('user batch parents');
//   res.json(student);
// });

// router.put('/:id', async (req, res) => {
//   const student = await Student.findByIdAndUpdate(req.params.id, req.body, { new: true });
//   res.json(student);
// });

// router.delete('/:id', async (req, res) => {
//   await Student.findByIdAndDelete(req.params.id);
//   res.json({ message: 'Student deleted' });
// });

// module.exports = router;


// const multer = require('multer');
// const XLSX = require('xlsx');
// const fs = require('fs');
// const path = require('path');

// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, 'uploads/');
//   },
//   filename: function (req, file, cb) {
//     cb(null, Date.now() + path.extname(file.originalname));
//   }
// });

// const upload = multer({ storage: storage });


// // ✅ Upload Excel Route
// router.post('/upload', upload.single('file'), async (req, res) => {

//   try {

//     if (!req.file) {
//       return res.status(400).json({ message: "No file uploaded" });
//     }

//     const workbook = XLSX.readFile(req.file.path);
//     const sheet = workbook.Sheets[workbook.SheetNames[0]];
//     const students = XLSX.utils.sheet_to_json(sheet);

//     let inserted = 0;
//     let duplicates = [];

//     for (let item of students) {

//       // duplicate check by std_id
//       const exists = await Student.findOne({ std_id: item.std_id });

//       if (exists) {
//         duplicates.push(item.std_id);
//         continue;
//       }

//       await Student.create({
//         std_id: item.std_id,
//         std_name: item.std_name,
//         section: item.section,
//         semester_no: item.semester_no,
//         batch: item.batch_id,
//         user: item.user_id,
//       });

//       inserted++;
//     }

//     fs.unlinkSync(req.file.path);

//     res.json({
//       message: "Upload completed",
//       inserted,
//       duplicates
//     });

//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }

// });

// routes/student.js
// routes/student.js
const express = require('express');
const router = express.Router();
const Student = require('../models/Student');
const multer = require('multer');
const xlsx = require('xlsx');

const upload = multer({ storage: multer.memoryStorage() });

router.post('/upload-excel', upload.single('file'), async (req, res) => {
    try {
        if (!req.file) return res.status(400).json({ message: "No file uploaded" });

        // Excel Read
        const workbook = xlsx.read(req.file.buffer, { type: 'buffer' });
        const data = xlsx.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);

        if (data.length === 0) return res.status(400).json({ message: "Excel file is empty" });

        // Data Validation & Formatting
        const formattedData = data.map((item, index) => {
            // Basic Validation: Har row mein ID aur Name hona chahiye
            if (!item.std_id || !item.std_name) {
                throw new Error(`Row ${index + 1}: Student ID and Name are required.`);
            }
            return {
                std_id: item.std_id.toString(),
                std_name: item.std_name,
                section: item.section || "N/A",
                semester_no: Number(item.semester_no) || 0,
                // Objects IDs agar Excel mein nahi hain to null rakhein
                user: item.user || null, 
                batch: item.batch || null,
                program: item.program || null,
                department: item.department || null
            };
        });

        // Save to DB (ordered: false matlab agar ek duplicate ho to baqi save ho jayein)
        const result = await Student.insertMany(formattedData, { ordered: false });
        
        res.status(200).json({ 
            success: true, 
            message: `${result.length} students uploaded successfully!`,
            data: result 
        });

    } catch (err) {
        console.error(err);
        // Duplicate Key Error handling
        if (err.code === 11000) {
            return res.status(400).json({ message: "Some Student IDs already exist in database." });
        }
        res.status(500).json({ message: err.message });
    }
});

// Fetch All Students
router.get('/all', async (req, res) => {
    try {
        const students = await Student.find().sort({ _id: -1 });
        res.json(students);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;