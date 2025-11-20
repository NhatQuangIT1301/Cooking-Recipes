const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: {
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
  phone: {
    type: String,
    unique: true,
    sparse: true // Cho phép null và tránh lỗi duplicate key 
  },
  password: {
    type: String,
    required: true
  },
  profile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'UserProfile' // Link 1-1 đến Profile 
  },
  isAdmin: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);