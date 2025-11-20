const nodemailer = require('nodemailer');
const transporter = nodemailer.createTransport({
    host: "smtp.office365.com", // Server của Microsoft (dùng cho cả hotmail, outlook, live)
    port: 587, // Port bảo mật
    secure: false, // Dùng 'false' vì port 587 sử dụng STARTTLS
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

const EmailUtil = {
    send(email, id, token) {
        const text = 'Thanks for signing up , please input these informations to activate your account :\n\t .id: ' + id + '\n\t . token : ' + token;
        return new Promise(function (resolve, reject) {
            const mailOptions = {
                from: process.env.EMAIL_USER,
                to: email,
                subject: 'Signup | Verification',
                text: text
            };
            transporter.sendMail(mailOptions, function (err, result) {
                if (err) reject(err);
                resolve(true);
            });
        });
    }
};
module.exports = EmailUtil;



// const EmailUtil = {
//     /**
//      * Gửi email kích hoạt với một đường link
//      * @param {string} email - Email của người nhận
//      * @param {string} id - ID của người dùng
//      * @param {string} token - Token kích hoạt
//      */
//     async send(email, id, token) {
//         // 1. Tạo đường link kích hoạt
//         // BẠN PHẢI THAY 'your-app-domain.com' BẰNG TÊN MIỀN THẬT CỦA BẠN
//         // Đây là đường link API mà backend của bạn sẽ lắng nghe
//         const activationLink = `https://your-app-domain.com/api/v1/user/activate?id=${id}&token=${token}`;

//         // 2. Tạo nội dung HTML cho email
//         const htmlBody = `
//             <h3>Cảm ơn bạn đã đăng ký!</h3>
//             <p>Vui lòng click vào đường link bên dưới để kích hoạt tài khoản của bạn:</p>
//             <p>
//                 <a href="${activationLink}" target="_blank" style="background-color: #007bff; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px;">
//                     Kích hoạt tài khoản
//                 </a>
//             </p>
//             <p>Nếu bạn không đăng ký, vui lòng bỏ qua email này.</p>
//         `;

//         // 3. Cấu hình mail
//         const mailOptions = {
//             from: process.env.EMAIL_USER,
//             to: email,
//             subject: 'Kích hoạt tài khoản của bạn', // Tiêu đề rõ ràng hơn
//             text: `Vui lòng truy cập link sau để kích hoạt: ${activationLink}`, // Dành cho client không hỗ trợ HTML
//             html: htmlBody // Nội dung HTML
//         };

//         // 4. Gửi mail bằng async/await
//         try {
//             const result = await transporter.sendMail(mailOptions);
//             return result; // Trả về kết quả gửi mail
//         } catch (err) {
//             console.error('Lỗi khi gửi email:', err);
//             throw err; // Ném lỗi ra để code bên ngoài bắt
//         }
//     }
// };