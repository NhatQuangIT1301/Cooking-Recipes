const express = require('express');
const router = express.Router();
const OtpDAO = require('../controllers/OtpDAO');
const AdminDAO = require('../controllers/AdminDAO');

const JwtUtil = require('../utils/JwtUtils');
const BcryptUtil = require('../utils/BcryptUtils');
const EmailUtil = require('../utils/EmailUtils');
const ImageUtils = require('../utils/UploadPictureUtils');
const uploadPicture = require('../utils/UploadPictureUtils');

//Đăng nhập
router.post('/signin', async function(req, res) {
    const email = req.body.email;
    const password = req.body.password;
    if (email && password) {
        try {
            const admin = await AdminDAO.selectByEmail(email);
            if (admin && await BcryptUtil.compare(password, admin.password)) {
                const token = JwtUtil.genToken(admin._id);
                res.json({
                    success: true,
                    message: 'Authentication successful',
                    user: admin,
                    token: token,
                });
            } else {
                res.json({
                    success: false,
                    message: 'Authentication failed. Invalid email or password.'
                });
            }
        } catch (error) {
            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    } else {
        res.json({
            success: false,
            message: 'Email and password are required.'
        });
    }
});

router.get('/token', JwtUtil.checkToken, function(req, res) {
    const token = req.headers['x-access-token'] || req.headers['authorization'];
    res.json({
        success: true,
        message: 'Token is valid',
        token: token
    });
});


// Quên mật khẩu
router.post('/send-otp', async function(req, res) {
    const email = req.body.email;
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    if (!email) {
        return res.json({success: false, message: "Vui lòng nhập email"});
    }

    try {
        const admin = await AdminDAO.selectByEmail(email);
        if (!admin) {
            return res.json({success: false, message: "Không tìm thấy tài khoản hoặc tài khoản không có quyền truy cập"});
        }

        await OtpDAO.createOtp(email, otpCode);

        const sendResult = await EmailUtil.send(email, otpCode);

        if (sendResult) {
            return res.json({success: true, message: "Mã Otp đã được gửi đến email của bạn", otp: otpCode});
        } else {
            return res.json({success: false, message: "Lỗi khi gửi mail"});
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({success: false, message: "Lỗi server", error: err});
    }
});

router.post('/verify-otp', async function(req, res) {
    const email = req.body.email;
    const otp = req.body.otp;
    
    if (!otp || !email) {
        return res.json({success: false, message: "Vui lòng nhập đầy đủ thông tin."});
    }

    try {
        const validOtp = await OtpDAO.findOtpByEmail(email, otp);
        if (validOtp) {
            await OtpDAO.deleteOtpByEmail(email);

            res.json({success: true, message: "Xác thực Otp thành công."});
        } else {
            res.json({success: false, message: "Mã Otp không đúng hoặc đã hết hạn."});
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({success: false, message: "Lỗi server", error: err});
    }
});

router.put('/reset-password', async function(req, res) {
    const email = req.body.email;
    const newPassword = req.body.password;

    if (!email || !newPassword) {
        return res.json({success: false, message: "Vui lòng điền đầy đủ."})
    }

    try {
        const admin = await AdminDAO.selectByEmail(email);
        const result = await BcryptUtil.compare(newPassword, admin.password)
        if (admin && !result) {
            const newHashedPassword = await BcryptUtil.hash(newPassword);
            await AdminDAO.updatePassByEmail(email, newHashedPassword);

            return res.json({success: true, message: "Mật khẩu đã được cập nhật."})
        } else {
            return res.json({success: false, message: "Mật khẩu này đã tồn tại."})
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({success: false, message: "Lỗi server", error: err});
    }
});


//User-Function
router.get('/auth/me', JwtUtil.checkToken, async function(req, res) {
    try{
        const user = await AdminDAO.selectById(req.decoded._id);
        if (!user) {
            return res.status(401).json({success: false});
        } else {
            return res.json({success: true, user: user});
        }
    } catch (err) {
        return res.status(500).json({success: false, message: err.message});
    }
});

router.put('/update-profile', JwtUtil.checkToken, async function(req, res) {
    const _id = req.decoded._id;
    const username = req.body.username;
    const email = req.body.email;
    const phone = req.body.phone;
    const userData = {_id: _id, username: username, email: email, phone: phone};
    try {
        const user = await AdminDAO.updateProfileById(userData);
        if(!user) {
            return res.json({success: false, message: "Không tìm thấy tài khoản"});
        } else {
            return res.json({success: true, message: "Cập nhật thành công", user: user});
        }
    } catch (err) {
        return res.status(500).json({success: false, message: err.message});
    }
})


//xử lý hình ảnh
router.put('/upload-avatar', JwtUtil.checkToken, uploadPicture.single('image'), async (req, res) => {
    try {
        const _id = req.decoded._id

        if (!req.file) {
            return res.status(400).json({ success: false, message: 'Chưa chọn file'});
        } else {
            const newFileName = req.file.filename;

            const webPath = 'uploads/' + newFileName;

            const user = await AdminDAO.updatePictureById(_id, webPath); //Sửa để lưu lại dữ liệu vào database

            if (!user) {
                return res.json({success: false, message: "Không tìm thấy tài khoản"});
            }
            
            return res.json({
                success: true,
                message: 'Upload thành công',
                user: user,
                filePath: webPath,
            });
        }
    } catch (err) {
        console.error("Lỗi khi upload hình ảnh", err);
    }
});


module.exports = router;