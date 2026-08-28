const mongoose = require("mongoose");

const childSchema = new mongoose.Schema(
  {
    nickname: {
      type: String,
      required: true,
      trim: true,
    },

    age: {
      type: Number,
      required: true,
      min: 2,
      max: 12,
    },

    learningLevel: {
      type: String,
      enum: ["beginner", "intermediate", "advanced"],
      default: "beginner",
    },

    avatar: {
      type: String,
      default: "default_avatar",
    },

    parentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

childSchema.index({ parentId: 1 });

module.exports = mongoose.model("Child", childSchema);
