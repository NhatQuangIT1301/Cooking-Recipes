require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
//Import Route
const userRoute  = require('./api/user');
const { default: mongoose } = require('mongoose');
// const adminRoute = require('./api/admin');

const app = express();
const PORT = process.env.PORT || 3000;

//--1.MiddileWate---
app.use(cors()); //Cho phép người khác gọi vòa
app.use(bodyParser.json({ limit: '10mb'}));
app.use(bodyParser.urlencoded({ extended: true, limit:'10mb'}));

//---2.Kết nối MongoDB---
mongoose.connect(process.env.MONGO_URI || 'mongodb+srv://admin:adminCR72538473029@cookingrecipes.1hsfmmq.mongodb.net/')
.then(()=> console.log("Đã kết nối với MongoDB"))
.catch((err)=> console.error("Lỗi Kết Nối MongoDB", err));

//---3. Routes ---
app.get('./helo', (req,res) =>{
    res.json({ message: "Hello!"});
});

app.use('/api/user', userRoute);
//app.use('/api/admin', adminRoute);

//---4.Khởi chạy SERVER ----
app.listen(PORT, ()=>{
    console.log(`Server đang lằng nghe tại cổng ${PORT}`);
});