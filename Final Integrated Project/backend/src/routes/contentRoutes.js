const express = require("express");

const {
  getSubjects,
  getSubjectById,
  getLessonById,
  getQuizForLesson,
  getGames,
  getGameById,
} = require("../controllers/contentController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

// Content routes require authentication

router.use(authMiddleware);

router.get("/subjects", getSubjects);

router.get("/subjects/:subjectId", getSubjectById);

router.get("/lessons/:lessonId", getLessonById);

router.get("/lessons/:lessonId/quiz", getQuizForLesson);

router.get("/games", getGames);

router.get("/games/:gameId", getGameById);

module.exports = router;
