const mongoose = require('mongoose');

const aiFailureLogSchema = new mongoose.Schema({
  submittedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  imageUrl: { type: String, required: true },
  status: {
    type: String,
    enum: ['pending', 'retrained'],
    default: 'pending'
  },
  correctedIngredient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'MasterIngredient' // Nhãn đúng sau khi admin sửa [cite: 64]
  }
}, { timestamps: true });

module.exports = mongoose.model('AIFailureLog', aiFailureLogSchema);