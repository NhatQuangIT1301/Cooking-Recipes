const mongoose = require('mongoose');

const tagSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  type: {
    type: String,
    required: true,
    // Enum định nghĩa chính xác các loại thẻ cho phép [cite: 46]
    enum: [
      'mealTime', 
      'dietType', 
      'healthCondition', 
      'cuisineStyle', 
      'ingredientCategory', 
      'exclusion', 
      'dietGoal'
    ]
  }
}, { timestamps: true });

module.exports = mongoose.model('Tag', tagSchema);