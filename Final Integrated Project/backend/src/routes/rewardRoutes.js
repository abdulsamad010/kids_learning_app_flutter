const express = require("express");

const { getChildRewards } = require("../controllers/rewardController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

// Rewards routes require authentication

router.use(authMiddleware);

router.get("/:childId", getChildRewards);

module.exports = router;
