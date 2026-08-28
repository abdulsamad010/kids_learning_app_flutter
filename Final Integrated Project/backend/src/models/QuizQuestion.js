const mongoose = require("mongoose");

const quizQuestionSchema = new mongoose.Schema(
  {
    lessonId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Lesson",
      required: true,
    },

    question: {
      type: String,
      required: true,
    },

    type: {
      type: String,
      required: true,
      enum: ["multiple_choice", "true_false", "matching"],
    },

    options: {
      type: [mongoose.Schema.Types.Mixed],
      default: [],
    },

    correctAnswer: {
      type: mongoose.Schema.Types.Mixed,
      required: true,
    },

    explanation: {
      type: String,
      default: "",
    },

    order: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

quizQuestionSchema.index({ lessonId: 1 });

module.exports = mongoose.model("QuizQuestion", quizQuestionSchema);
