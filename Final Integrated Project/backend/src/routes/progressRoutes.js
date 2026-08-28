const express = require("express");

const {
  submitLessonProgress,
  submitQuizProgress,
  submitGameProgress,
  syncProgress,
  getChildProgress,
  getChildProgressSummary,
} = require("../controllers/progressController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

// All progress routes require authentication

router.use(authMiddleware);

router.post("/:childId/lesson", submitLessonProgress);

router.post("/:childId/quiz", submitQuizProgress);

router.post("/:childId/game", submitGameProgress);

router.post("/:childId/sync", syncProgress);

router.get("/:childId", getChildProgress);

router.get("/:childId/summary", getChildProgressSummary);

module.exports = router;
