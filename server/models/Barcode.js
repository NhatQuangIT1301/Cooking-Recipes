const mongoose = require('mongoose');

const barcodeSchema = new mongoose.Schema({
  barcode: {
    type: String,
    required: true,
    unique: true,
    trim: true // [cite: 58]
  },
  masterIngredient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'MasterIngredient',
    required: true // [cite: 58]
  }
}, { timestamps: true });

module.exports = mongoose.model('Barcode', barcodeSchema);