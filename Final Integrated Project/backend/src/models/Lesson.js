const mongoose = require("mongoose");

const stepSchema = new mongoose.Schema(
  {
    stepNumber: {
      type: Number,
      required: true,
    },

    title: {
      type: String,
      required: true,
    },

    type: {
      type: String,
      required: true,
      enum: [
        "introduction",
        "explanation",
        "example",
        "interactive_activity",
        "practice",
        "short_assessment",
        "completion",
        "reward",
      ],
    },

    content: {
      type: mongoose.Schema.Types.Mixed,
      default: {},
    },
  },
  { _id: false }
);

const lessonSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
    },

    description: {
      type: String,
      default: "",
    },

    subjectId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Subject",
      required: true,
    },

    order: {
      type: Number,
      default: 0,
    },

    difficulty: {
      type: String,
      enum: ["easy", "medium", "hard"],
      default: "easy",
    },

    steps: [stepSchema],

    starsReward: {
      type: Number,
      default: 3,
    },
  },
  {
    timestamps: true,
  }
);

lessonSchema.index({ subjectId: 1 });

module.exports = mongoose.model("Lesson", lessonSchema);
