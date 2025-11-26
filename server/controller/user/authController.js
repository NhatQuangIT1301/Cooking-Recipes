const mongoose = require('mongoose'); 
const User = require('../../model/User'); 
const Otp = require('../../model/Otp');   
const EmailUtil = require('../../utils/EmailUtils'); 
const admin = require('../../config/firebase'); 
const bcrypt = require('bcryptjs'); 
const jwt = require('jsonwebtoken'); 
// Hàm tạo Token dùng chung
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES || '30d'
    });
};

// --- API: Đăng nhập bằng Google ---
// exports.googleLogin = async (req, res) => {
//     try {
//         const { idToken, email, fullName, photoUrl } = req.body; 
        
//         const ticket = await admin.auth().verifyIdToken(idToken);
//         const uid = ticket.uid;
        
//         let user = await User.findOne({ email });

//         if (user) {
//             if(!user.googleId) {
//                 user.googleId = googleId;
//             }
//             await user.save();
//         } else {
//             user = new User({
//                 fullName: fullName, 
//                 email: email,
//                 googleId: googleId,
//                 avatar: photoUrl,
//                 password: null,
//                 role: 'user'
//             });
//             await user.save();
//         }

//         const token = generateToken(user._id);

//         res.status(200).json({
//             success: true,
//             message: "Login Google thành công",
//             token: token,
//             data: user
//         });

//     } catch (error) {
//         console.error("Lỗi Login Google:", error);
//         res.status(401).json({
//             success: false,
//             message: error.message.includes('token') ? "Token Google không hợp lệ hoặc đã hết hạn." : "Lỗi server.",
//             error: error.message
//         });
//     }
// };
// --- API 3: Đăng nhập bằng Email/Pass ---
// exports.loginUser = async (req, res) => {
//     try {
//         const { email, password } = req.body;

//         // 1. Kiểm tra email tồn tại
//         const user = await User.findOne({ email });
        
//         // 2. Nếu không tìm thấy user hoặc user không có mật khẩu (social login)
//         if (!user || !user.password) {
//             return res.status(401).json({ message: "Email hoặc mật khẩu không đúng." });
//         }

//         // 3. So sánh mật khẩu đã mã hóa
//         const isMatch = await bcrypt.compare(password, user.password);

//         if (!isMatch) {
//             return res.status(401).json({ message: "Email hoặc mật khẩu không đúng." });
//         }

//         // 4. Tạo Token và trả về
//         const token = generateToken(user._id);

//         res.status(200).json({
//             success: true,
//             message: "Đăng nhập thành công!",
//             token: token, // JWT Token cho Flutter
//             data: user,
//         });

//     } catch (error) {
//         console.error("Lỗi Login:", error);
//         res.status(500).json({ message: "Lỗi server", error: error.message });
//     }
// };
// --- API 1: Gửi mã OTP ---
exports.sendOtpCode = async (req, res) => {
  try {
    console.log("👉 1. Đã nhận request từ Postman"); 
    const { email } = req.body;
  
    // Debug log
    if (mongoose.connection.name) {
        console.log("🏠 ĐANG TÌM TRONG DB TÊN LÀ:", mongoose.connection.name);
    }
    const userExists = await User.findOne({ email });
    console.log("🔍 KẾT QUẢ TÌM KIẾM:", userExists); 
    
    if (userExists) {
      return res.status(400).json({ message: "Email này đã được đăng ký!" });
    }

    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    await Otp.findOneAndUpdate(
      { email: email }, 
      { otp: otpCode }, 
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );
    
    EmailUtil.send(email, otpCode).catch(err => console.log("Lỗi gửi mail:", err));

    res.status(200).json({ success: true, message: "Đã gửi OTP" });

  } catch (error) {
    console.error("Lỗi Send OTP:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// --- API 2: Xác thực OTP và Tạo User ---
exports.verifyAndRegister = async (req, res) => {
  try {
    const { email, password, fullName, otp } = req.body;

    const validOtp = await Otp.findOne({ email: email, otp: otp });
    
    if (!validOtp) {
      return res.status(400).json({ message: "Mã OTP sai hoặc đã hết hạn!" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = new User({
      fullName: fullName, 
      email: email,
      password: hashedPassword,
      role: 'user'
    });

    await newUser.save();
    await Otp.deleteOne({ email: email });

    const token = generateToken(newUser._id);

    res.status(200).json({ 
        success: true, 
        message: "Đăng ký thành công!",
        token: token,
        data: newUser
    });

  } catch (error) {
    console.error("Lỗi đăng ký:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};