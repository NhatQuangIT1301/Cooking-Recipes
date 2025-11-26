require('dotenv').config();
const express = require('express');
const cors = require('cors');

// Import DB và Routes
const connectDB = require('./config/db'); 
const userRoute = require('./api/user'); 

// Kết nối Database
connectDB();

const app = express();
const PORT = process.env.PORT || 5000;

// --- KHU VỰC QUAN TRỌNG NHẤT (MIDDLEWARE) ---
// Các dòng này BẮT BUỘC phải nằm TRÊN dòng app.use('/api/auth'...)
app.use(cors());
app.use(express.json()); // <--- Dòng này giúp đọc req.body
app.use(express.urlencoded({ extended: true }));
// ---------------------------------------------

// Route test
app.get('/', (req, res) => {
    res.send("API Cooking Recipes đang chạy 🚀");
});

// Route chính
app.use('/api/auth', userRoute); 

// Chạy Server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server đang lắng nghe tại cổng ${PORT}`);
});