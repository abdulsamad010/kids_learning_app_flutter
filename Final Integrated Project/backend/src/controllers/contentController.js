const Subject = require("../models/Subject");
const Lesson = require("../models/Lesson");
const QuizQuestion = require("../models/QuizQuestion");
const Game = require("../models/Game");


// ======================================================
// GET /api/content/subjects
// Get all subjects
// ======================================================

const getSubjects = async (req, res) => {
  try {
    const subjects = await Subject.find().sort({ order: 1 });

    return res.status(200).json({
      success: true,
      data: subjects.map((s) => ({
        id: s._id,
        name: s.name,
        description: s.description,
        icon: s.icon,
        color: s.color,
        order: s.order,
      })),
    });
  } catch (error) {
    console.error("Get subjects error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/content/subjects/:subjectId
// Get a subject with its lessons
// ======================================================

const getSubjectById = async (req, res) => {
  try {
    const subject = await Subject.findById(req.params.subjectId);

    if (!subject) {
      return res.status(404).json({
        success: false,
        message: "Subject not found.",
      });
    }

    const lessons = await Lesson.find({ subjectId: subject._id })
      .sort({ order: 1 })
      .select("title description order difficulty starsReward");

    return res.status(200).json({
      success: true,
      data: {
        id: subject._id,
        name: subject.name,
        description: subject.description,
        icon: subject.icon,
        color: subject.color,
        lessons: lessons.map((l) => ({
          id: l._id,
          subjectId: subject._id.toString(),
          title: l.title,
          description: l.description,
          order: l.order,
          difficulty: l.difficulty,
          starsReward: l.starsReward,
        })),
      },
    });
  } catch (error) {
    console.error("Get subject error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/content/lessons/:lessonId
// Get a full lesson with steps
// ======================================================

const getLessonById = async (req, res) => {
  try {
    const lesson = await Lesson.findById(req.params.lessonId)
      .populate("subjectId", "name icon color");

    if (!lesson) {
      return res.status(404).json({
        success: false,
        message: "Lesson not found.",
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        id: lesson._id,
        title: lesson.title,
        description: lesson.description,
        subject: lesson.subjectId
          ? {
              id: lesson.subjectId._id,
              name: lesson.subjectId.name,
              icon: lesson.subjectId.icon,
              color: lesson.subjectId.color,
            }
          : null,
        order: lesson.order,
        difficulty: lesson.difficulty,
        starsReward: lesson.starsReward,
        steps: lesson.steps,
      },
    });
  } catch (error) {
    console.error("Get lesson error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/content/lessons/:lessonId/quiz
// Get quiz questions for a lesson
// ======================================================

const getQuizForLesson = async (req, res) => {
  try {
    const lesson = await Lesson.findById(req.params.lessonId);

    if (!lesson) {
      return res.status(404).json({
        success: false,
        message: "Lesson not found.",
      });
    }

    const questions = await QuizQuestion.find({ lessonId: lesson._id })
      .sort({ order: 1 });

    return res.status(200).json({
      success: true,
      data: questions.map((q) => ({
        id: q._id,
        lessonId: q.lessonId.toString(),
        question: q.question,
        type: q.type,
        options: q.options,
        correctAnswer: q.correctAnswer,
        explanation: q.explanation || "",
        order: q.order,
      })),
    });
  } catch (error) {
    console.error("Get quiz error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/content/games
// Get all games
// ======================================================

const getGames = async (req, res) => {
  try {
    const games = await Game.find()
      .populate("subjectId", "name")
      .sort({ createdAt: 1 });

    return res.status(200).json({
      success: true,
      data: games.map((g) => ({
        id: g._id,
        name: g.name,
        type: g.type,
        description: g.description,
        subject: g.subjectId
          ? { id: g.subjectId._id, name: g.subjectId.name }
          : null,
        difficulty: g.difficulty,
        starsReward: g.starsReward,
      })),
    });
  } catch (error) {
    console.error("Get games error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/content/games/:gameId
// Get a single game by ID
// ======================================================

const getGameById = async (req, res) => {
  try {
    const game = await Game.findById(req.params.gameId)
      .populate("subjectId", "name icon color");

    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found.",
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        id: game._id,
        name: game.name,
        type: game.type,
        description: game.description,
        subject: game.subjectId
          ? {
              id: game.subjectId._id,
              name: game.subjectId.name,
              icon: game.subjectId.icon,
              color: game.subjectId.color,
            }
          : null,
        configuration: game.configuration,
        difficulty: game.difficulty,
        starsReward: game.starsReward,
      },
    });
  } catch (error) {
    console.error("Get game error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


module.exports = {
  getSubjects,
  getSubjectById,
  getLessonById,
  getQuizForLesson,
  getGames,
  getGameById,
};
