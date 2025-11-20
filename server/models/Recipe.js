const mongoose = require('mongoose');

const recipeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  image: { type: String, required: true },
  servings: { type: String },
  prepTimeMinutes: { type: Number },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending' // [cite: 49]
  },
  // Embedded Object cho danh sách nguyên liệu
  ingredients: [{
    userInput: String, // Text gốc user nhập [cite: 49]
    quantity: Number,
    unit: String,
    masterIngredient: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'MasterIngredient' // Link đến CSDL chuẩn để tính calo [cite: 49]
    }
  }],
  steps: [{ description: String }], // Embedded steps [cite: 49]
  
  // Dinh dưỡng tổng hợp (tự động tính toán) [cite: 49]
  nutritionAnalysis: {
    calories: Number,
    protein: Number,
    carbs: Number,
    fat: Number
  },

  // Phân loại Tags chi tiết để lọc hiệu quả [cite: 49]
  mealTimeTags: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Tag' }],
  dietTags: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Tag' }],
  healthTags: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Tag' }], // Admin gán
  exclusionTags: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Tag' }],
  cuisineStyleTags: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Tag' }]

}, { timestamps: true });

module.exports = mongoose.model('Recipe', recipeSchema);