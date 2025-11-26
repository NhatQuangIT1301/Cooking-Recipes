const nodemailer = require('nodemailer');
const transporter = nodemailer.createTransport({
    service: "gmail", // Server của gmail
    port: 587, // Port bảo mật
    secure: false, // Dùng 'false' vì port 587 sử dụng STARTTLS
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

const EmailUtil = {
    send(email, otp) { // Chỉ nhận email và mã OTP
        const htmlContent = `
            <div style="font-family: Arial, sans-serif; padding: 20px;">
                <h2>Xác thực tài khoản Cooking App 🍳</h2>
                <p>Mã xác thực của bạn là:</p>
                <h1 style="color: #4CAF50; letter-spacing: 5px;">${otp}</h1>
                <p>Mã này sẽ hết hạn sau 2 phút.</p>
            </div>
        `;

        return new Promise(function (resolve, reject) {
            const mailOptions = {
                from: '"Cooking App Support" <' + process.env.EMAIL_USER + '>',
                to: email,
                subject: 'Mã OTP xác thực đăng ký',
                html: htmlContent // Gửi dạng HTML cho đẹp
            };

            transporter.sendMail(mailOptions, function (err, result) {
                if (err) {
                    console.log("Lỗi gửi mail: ", err);
                    reject(err);
                } else {
                    resolve(true);
                }
            });
        });
    }
};
module.exports = EmailUtil;
