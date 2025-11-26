const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        // 1. In ra xem nó đọc được gì (Debug)
        console.log("🔍 Đang thử kết nối tới:", process.env.MONGO_URI);

        // 2. Kết nối (Thêm chuỗi cứng dự phòng nếu .env lỗi)
        const conn = await mongoose.connect(process.env.MONGO_URI || 'mongodb+srv://admin:adminCR72538473029@cookingrecipes.1hsfmmq.mongodb.net/cookingrecipes?retryWrites=true&w=majority');

        console.log(`✅ Đã kết nối MongoDB: ${conn.connection.host}`);
    } catch (error) {
        console.error(`❌ Lỗi kết nối MongoDB: ${error.message}`);
        process.exit(1);
    }
};

module.exports = connectDB;