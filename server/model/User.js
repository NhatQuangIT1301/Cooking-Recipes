const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  // Google Login
  googleID: {
    type: String,
    unique: true,
    sparse: true,
  },
  avatar: {
    type: String,
  },
  phone: {
    type: String,
    unique: true,
    sparse: true // Cho phép null và tránh lỗi duplicate key 
  },
  password: {
    type: String,
    required: true
  },
  isVerified: { 
    type: Boolean, 
    default: false
  },
  profile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'UserProfile' // Link 1-1 đến Profile 
  },
  isAdmin: {
    type: Boolean,
    default: false
  },
  resetPasswordToken: String,
  resetPasswordExpire: Date,

  createdAt:{ type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);