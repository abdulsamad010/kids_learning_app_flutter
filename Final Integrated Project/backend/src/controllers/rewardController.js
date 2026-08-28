const Reward = require("../models/Reward");
const Child = require("../models/Child");


// ======================================================
// GET /api/rewards/:childId
// Get all rewards for a child (only if owned by parent)
// ======================================================

const getChildRewards = async (req, res) => {
  try {
    const child = await Child.findOne({
      _id: req.params.childId,
      parentId: req.userId,
    });

    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const rewards = await Reward.find({ childId: child._id })
      .sort({ earnedAt: -1 });

    const totalStars = rewards.reduce((sum, r) => sum + (r.stars || 0), 0);

    return res.status(200).json({
      success: true,
      data: {
        childId: child._id,
        nickname: child.nickname,
        totalStars,
        rewards: rewards.map((r) => ({
          id: r._id,
          sourceType: r.sourceType,
          sourceId: r.sourceId,
          stars: r.stars,
          earnedAt: r.earnedAt,
        })),
      },
    });
  } catch (error) {
    console.error("Get rewards error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


module.exports = { getChildRewards };
