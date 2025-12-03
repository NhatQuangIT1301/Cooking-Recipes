const { Type } = require('@google/genai');
const { default: mongoose } = require('mongoose');
const moongoose = require('mongoose');

const userProfileSchema = new moongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref:'User',
    required: true,
    unique:true
  },
  //Dữ liệu người dùng nhập
  gender: {
    type: String,
    enum: ['Male','Female','Other']
  },
  // birthdate: {
  //   type:Date.now
  // },
  age: {
    type: Number
  },
  height: {
    type: Number
  },
  weight: [{
    type: Number,
    date: { type: Date, default: Date.now }
  }],
  target_weight: {
    type: Number
  },

  activity_level: {
    type: String,
    default: 'Moderately Active'
  },
  health_conditions: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Tag'
  }],
  habit: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Tag'
  }], 
  goal: {
    type: String
  },
  diet: {
    type: String
  },

  //Kết quả của AI
  nutrionTargets: {
    bmi: {
      type: Number
    },
    bmi_status: {
      type: String
    },
    tdee: {
      type: Number
    },
    dailyCalories: {
      type: Number
    },
    water_intake: {
      type: String
    },
    macros: {
      protein : {
        type: Number
      },
      carbs: {
        type: Number
      },
      fat : {
        type: Number
      }
    }
  },

  ai_recommendations: [{
    type: String
  }],
  ai_foods_to_avoid: [{
    type: String
  }],
  ai_meal_suggestions: [{
    name: String,
    calories: Number,
    dessciption: String
  }]

}, {timestamps: true});

module.exports = moongoose.model('UserProfile', userProfileSchema);