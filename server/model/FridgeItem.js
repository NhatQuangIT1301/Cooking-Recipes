const mongoose = require('mongoose');

const fridgeItemSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  masterIngredient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'MasterIngredient',
    required: true // [cite: 52]
  },
  quantity: { type: Number, required: true },
  unit: { type: String },
  expiryDate: { type: Date }
}, { timestamps: true });

module.exports = mongoose.model('FridgeItem', fridgeItemSchema);