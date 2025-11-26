const express = require('express');
const router = express.Router();
//Import Controller
const authController = require('../controller/user/authController');
// 1. Đăng nhập Google (Social Login)
// router.post('/google-login', authController.googleLogin);

// 2. Bước 1: Nhập email -> Gửi OTP
router.post('/send-otp', authController.sendOtpCode);
 
// 3. Bước 2: Nhập Full thông tin + OTP -> Đăng ký hoàn tất
router.post('/register', authController.verifyAndRegister);

// 3. Đăng nhập Email/Password
// router.post('/login', authController.loginUser);

module.exports = router;