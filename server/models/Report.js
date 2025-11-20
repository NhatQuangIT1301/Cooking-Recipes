const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
  reportedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  recipe: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Recipe',
    required: true
  },
  reason: { type: String, required: true },
  status: {
    type: String,
    enum: ['pending', 'resolved'],
    default: 'pending'
  }
}, { timestamps: true });

module.exports = mongoose.model('Report', reportSchema);