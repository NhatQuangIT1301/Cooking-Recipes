const express = require('express');
const router = express.Router();

//Import Controller
const authController  = require('../controller/authController');

// --- Định Nghĩa Các Route ---

//Route đăng nhập google
// dường dẫn 
router.post('/goole-login', authController.googleLogin);

//Các route khca1 của user

module.exports = router;
