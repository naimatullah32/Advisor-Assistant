// const express = require('express');
// const Advisor = require('../models/Advisor');
// const router = express.Router();

// router.post('/', async (req, res) => {
//   const advisor = await Advisor.create(req.body);
//   res.status(201).json(advisor);
// });

// router.get('/', async (req, res) => {
//   const advisors = await Advisor.find().populate('teacher');
//   res.json(advisors);
// });

// router.get('/:id', async (req, res) => {
//   const advisor = await Advisor.findById(req.params.id).populate('teacher');
//   res.json(advisor);
// });

// router.put('/:id', async (req, res) => {
//   const advisor = await Advisor.findByIdAndUpdate(
//     req.params.id,
//     req.body,
//     { new: true }
//   );
//   res.json(advisor);
// });

// router.delete('/:id', async (req, res) => {
//   await Advisor.findByIdAndDelete(req.params.id);
//   res.json({ message: 'Advisor deleted' });
// });

// module.exports = router;

const express = require('express');
const router = express.Router();
const multer = require('multer');
const xlsx = require('xlsx');
const Advisor = require('../models/Advisor');

// Multer setup for Excel upload
const upload = multer({ dest: 'uploads/' });

router.post('/upload-excel', upload.single('file'), async (req, res) => {
    try {
        if (!req.file) return res.status(400).json({ message: "No file uploaded" });

        const workbook = xlsx.readFile(req.file.path);
        const sheetName = workbook.SheetNames[0];
        const data = xlsx.utils.sheet_to_json(workbook[sheetName]);

        const validAdvisors = [];
        const errors = [];

        for (let item of data) {
            // Validation: Name aur Section hona zaroori hai
            if (item.name && item.section) {
                validAdvisors.push({
                    name: item.name,
                    section: item.section,
                    // teacher aur batch IDs agar excel mein hain to
                    teacher: item.teacher_id || null, 
                    batch: item.batch_id || null
                });
            } else {
                errors.push(`Missing data in row: ${JSON.stringify(item)}`);
            }
        }

        if (validAdvisors.length > 0) {
            await Advisor.insertMany(validAdvisors);
            res.status(200).json({ 
                message: "Advisors uploaded successfully", 
                count: validAdvisors.length,
                errors: errors 
            });
        } else {
            res.status(400).json({ message: "No valid data found in Excel", errors });
        }
    } catch (error) {
        res.status(500).json({ message: "Server error", error: error.message });
    }
});

// Fetch all advisors
router.get('/all', async (req, res) => {
    const advisors = await Advisor.find().populate('teacher');
    res.json(advisors);
});

module.exports = router;
