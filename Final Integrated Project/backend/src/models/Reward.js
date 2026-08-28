const mongoose = require("mongoose");

const rewardSchema = new mongoose.Schema(
  {
    childId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Child",
      required: true,
    },

    sourceType: {
      type: String,
      required: true,
      enum: ["lesson", "quiz", "game"],
    },

    sourceId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
    },

    stars: {
      type: Number,
      default: 0,
    },

    earnedAt: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  }
);

rewardSchema.index({ childId: 1 });
rewardSchema.index({ childId: 1, sourceType: 1, sourceId: 1 }, { unique: true });

module.exports = mongoose.model("Reward", rewardSchema);
