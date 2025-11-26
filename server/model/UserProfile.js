const mongoose = require('mongoose');

const userProfileSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true // Đảm bảo quan hệ 1-1 
  },
  height: { type: Number }, // cm
  weightHistory: [{
    value: Number,
    date: { type: Date, default: Date.now }
  }], // 
  gender: {
    type: String,
    enum: ['male', 'female', 'other']
  },
  birthDate: { type: Date },
  healthConditions: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Tag' // Tag type: 'healthCondition' 
  }],
  nutritionGoal: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Tag' // Tag type: 'dietGoal' 
  },
  diet: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Tag' // Tag type: 'dietType' 
  },
  habits: [{ type: String }]
}, { timestamps: true });

module.exports = mongoose.model('UserProfile', userProfileSchema);