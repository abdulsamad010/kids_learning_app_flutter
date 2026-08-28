const mongoose = require("mongoose");

const progressSchema = new mongoose.Schema(
  {
    childId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Child",
      required: true,
    },

    contentId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
    },

    contentType: {
      type: String,
      required: true,
      enum: ["lesson", "quiz", "game"],
    },

    score: {
      type: Number,
      default: 0,
    },

    stars: {
      type: Number,
      default: 0,
    },

    completed: {
      type: Boolean,
      default: false,
    },

    clientId: {
      type: String,
      default: null,
    },

    completedAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

progressSchema.index({ childId: 1 });
progressSchema.index({ childId: 1, contentType: 1 });
progressSchema.index({ clientId: 1 }, { sparse: true });

module.exports = mongoose.model("Progress", progressSchema);
