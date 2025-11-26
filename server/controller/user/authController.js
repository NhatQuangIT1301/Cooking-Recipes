const mongoose = require('mongoose'); 
const User = require('../../model/User'); 
const Otp = require('../../model/Otp');   
const EmailUtil = require('../../utils/EmailUtils'); 
const admin = require('../../config/firebase'); 
const bcrypt = require('bcryptjs'); 
const jwt = require('jsonwebtoken'); 
const crypto = require('crypto');
const { OAuth2Client } = require('google-auth-library');
// Thay bằng Client ID loại WEB bạn vừa tạo ở Bước 1
const GOOGLE_CLIENT_ID = "579746797348-l9tht58g9c99bu4r05mu8jj47ued03os.apps.googleusercontent.com";
const client = new OAuth2Client(GOOGLE_CLIENT_ID);
// Hàm tạo Token dùng chung
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES || '30d'
    });
};
// ============================================================
// 1. API ĐĂNG NHẬP GOOGLE (BẢO MẬT CAO)
// ============================================================
exports.googleLogin = async (req, res) => {
    try {
        // App Flutter sẽ gửi idToken lên đây
        const { idToken } = req.body; 

        // 1. Xác thực Token với Google Server
        const ticket = await client.verifyIdToken({
            idToken: idToken,
            audience: GOOGLE_CLIENT_ID, 
        });
        
        const payload = ticket.getPayload();
        
        // Lấy thông tin từ Google trả về
        const { email, name, picture, sub } = payload; 
        // sub là Google ID duy nhất của user

        // 2. Kiểm tra xem user đã có trong DB chưa
        let user = await User.findOne({ email });

        if (user) {
            // Nếu có rồi thì cập nhật avatar/tên nếu muốn
            // user.avatar = picture;
            // await user.save();
        } else {
            // 3. Nếu chưa có -> Tạo User mới
            user = new User({
                fullName: name,
                email: email,
                password: null, // Google login ko cần pass
                avatar: picture,
                role: 'user',
                // isSurveyCompleted: false (Mặc định ở model rồi)
            });
            await user.save();
        }

        // 4. Tạo JWT Token của riêng hệ thống mình
        const token = generateToken(user._id);

        // 5. Trả về cho App
        const userData = user.toObject();
        delete userData.password; // Xóa pass (nếu có)

        res.status(200).json({
            success: true,
            message: "Google Login thành công",
            token: token,
            data: userData
        });

    } catch (error) {
        console.error("Lỗi Google Login:", error);
        res.status(401).json({ message: "Token Google không hợp lệ" });
    }
};
// ============================================================
// 2. API ĐĂNG NHẬP EMAIL/PASSWORD
// ============================================================
exports.loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Kiểm tra user
        const user = await User.findOne({ email });
        // Kiểm tra user tồn tại và có password (phòng trường hợp user google ko có pass)
        if (!user || !user.password) {
            return res.status(401).json({ message: "Email hoặc mật khẩu không đúng." });
        }

        // So sánh mật khẩu
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: "Email hoặc mật khẩu không đúng." });
        }

        const token = generateToken(user._id);

        // 🔥 FIX BẢO MẬT: Xóa password trước khi trả về client
        const userData = user.toObject();
        delete userData.password;

        res.status(200).json({
            success: true,
            message: "Đăng nhập thành công!",
            token: token,
            data: userData // ✅ Đã an toàn
        });

    } catch (error) {
        console.error("Lỗi Login:", error);
        res.status(500).json({ message: "Lỗi server" });
    }
};

// ============================================================
// 3. API GỬI OTP (BƯỚC 1 ĐĂNG KÝ)
// ============================================================
exports.sendOtpCode = async (req, res) => {
  try {
    const { email } = req.body;
  
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: "Email này đã được đăng ký!" });
    }

    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    await Otp.findOneAndUpdate(
      { email: email }, 
      { otp: otpCode }, 
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );
    
    // 🔥 FIX ỔN ĐỊNH: Thêm await để đảm bảo mail gửi được mới báo thành công
    try {
        await EmailUtil.send(email, otpCode);
    } catch (mailError) {
        console.error("Lỗi gửi mail:", mailError);
        return res.status(500).json({ message: "Không thể gửi email. Kiểm tra lại địa chỉ!" });
    }

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

    // 🔥 FIX BẢO MẬT: Xóa password
    const userData = newUser.toObject();
    delete userData.password;

    res.status(200).json({ 
        success: true, 
        message: "Đăng ký thành công!",
        token: token,
        data: userData // ✅ Đã an toàn
    });

  } catch (error) {
    console.error("Lỗi đăng ký:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ============================================================
// 4. QUÊN MẬT KHẨU (BƯỚC 1: GỬI OTP)
// ============================================================
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "Email chưa đăng ký tài khoản nào." });
    }

    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    await Otp.findOneAndUpdate(
      { email: email }, 
      { otp: otpCode }, 
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );

    // 🔥 FIX ỔN ĐỊNH: Thêm await
    try {
        await EmailUtil.send(email, otpCode);
    } catch (mailError) {
        console.log("Lỗi gửi mail forgot:", mailError);
        return res.status(500).json({ message: "Lỗi gửi email OTP" });
    }

    res.status(200).json({ success: true, message: "Đã gửi mã OTP khôi phục!" });

  } catch (error) {
    console.error("Lỗi Forgot:", error);
    res.status(500).json({ message: "Lỗi Server" });
  }
};

// ============================================================
// 5. ĐẶT LẠI MẬT KHẨU (BƯỚC 2: DÙNG OTP)
// ============================================================
exports.resetPasswordWithOTP = async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body;

    // 1. Kiểm tra OTP
    const validOtp = await Otp.findOne({ email, otp });
    if (!validOtp) {
      return res.status(400).json({ message: "Mã OTP không đúng hoặc đã hết hạn!" });
    }

    // 2. Mã hóa mật khẩu mới
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    // 3. Cập nhật mật khẩu VÀ lấy thông tin User để tạo Token
    const user = await User.findOneAndUpdate(
        { email: email },
        { password: hashedPassword },
        { new: true } 
    );

    if (!user) {
        return res.status(404).json({ message: "Không tìm thấy User" });
    }

    // 4. Xóa OTP
    await Otp.deleteOne({ email });

    // 5. Tạo Token ngay lập tức
    const token = generateToken(user._id);
    
    // Loại bỏ password trước khi trả về
    const userData = user.toObject();
    delete userData.password;

    // 6. Trả về Token kèm theo
    res.status(200).json({ 
        success: true, 
        message: "Đổi mật khẩu thành công!",
        token: token, 
        data: userData
    });

  } catch (error) {
    console.error("Lỗi Reset Pass:", error);
    res.status(500).json({ message: "Lỗi Server" });
  }
};