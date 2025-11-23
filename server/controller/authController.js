const User = require('../models/User');
 
//Hàm xử ký đăng nhập bằng Google
exports.googleLogin = async (req, res) => {
    try {
        //1. Nhận dữ liệu từ flutter gửi lên
        const { googleId, email, name, photoUrl } = req.bode;
        
        //2.Kiểm tra email có trong db chưa
        let user = await User.findOne({ email});

        if (user) {
            //Trường hợp: Đã có tài khoản
            //cập nhật lại GoogleId (nếu trước chưa có) và avatar mới
            if(!user.googleId) {
                user.googleId = googleId;
            }
            user.avatar  = photoUrl;
            await user.save();
        } else {
            //Trường hợp chưa có tài khoản -> Tao mới
            user = new User({
                username: name,
                eamil : email,
                googleId : googleId,
                avatar : photoUrl,
                password: null,
                isAdmin: false
            });
            await user.save();
        }

        //3.Trả kết quả về app
        res.status(200).json({
            successs: true,
            message:"Login google thành công",
            data: user
        });
    }catch (error){
        console.error("Lỗi Login:", error);
        res.status(500).json({
            successs: false,
            message:"Lỗi server",
            error: error.message
        });
    }
};