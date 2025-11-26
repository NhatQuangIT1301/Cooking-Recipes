const mongoose = require('mongoose');

const appConfigSchema = new mongoose.Schema({
  key: {
    type: String,
    required: true,
    unique: true // [cite: 67]
  },
  value: {
    type: mongoose.Schema.Types.Mixed, // Lưu được cả số, string, hoặc object
    required: true
  }
}, { timestamps: true });

module.exports = mongoose.model('AppConfig', appConfigSchema);