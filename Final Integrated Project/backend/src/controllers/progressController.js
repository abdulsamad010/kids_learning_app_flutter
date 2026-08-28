const Progress = require("../models/Progress");
const Reward = require("../models/Reward");
const Child = require("../models/Child");


// Helper: verify the child belongs to the authenticated parent
const verifyChildOwnership = async (childId, parentId) => {
  const child = await Child.findOne({ _id: childId, parentId });
  return child;
};


// ======================================================
// POST /api/progress/:childId/lesson
// Submit lesson progress
// ======================================================

const submitLessonProgress = async (req, res) => {
  try {
    const child = await verifyChildOwnership(req.params.childId, req.userId);
    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const { contentId, score, stars } = req.body;

    if (!contentId) {
      return res.status(400).json({
        success: false,
        message: "Content ID is required.",
      });
    }

    const existing = await Progress.findOne({
      childId: child._id,
      contentId,
      contentType: "lesson",
    });

    let progress;
    if (existing) {
      existing.score = Math.max(existing.score || 0, score || 0);
      existing.stars = Math.max(existing.stars || 0, stars || 0);
      existing.completed = true;
      existing.completedAt = new Date();
      await existing.save();
      progress = existing;
    } else {
      progress = await Progress.create({
        childId: child._id,
        contentId,
        contentType: "lesson",
        score: score || 0,
        stars: stars || 0,
        completed: true,
        completedAt: new Date(),
      });
    }

    if (stars && stars > 0) {
      try {
        await Reward.findOneAndUpdate(
          { childId: child._id, sourceType: "lesson", sourceId: contentId },
          { childId: child._id, sourceType: "lesson", sourceId: contentId, stars },
          { upsert: true, new: true }
        );
      } catch (_) {
        // Reward may already exist with same unique index, ignore
      }
    }

    return res.status(201).json({
      success: true,
      message: "Lesson progress saved.",
      data: {
        id: progress._id,
        childId: progress.childId,
        contentId: progress.contentId,
        contentType: progress.contentType,
        score: progress.score,
        stars: progress.stars,
        completed: progress.completed,
        completedAt: progress.completedAt,
      },
    });
  } catch (error) {
    console.error("Submit lesson progress error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// POST /api/progress/:childId/quiz
// Submit quiz progress
// ======================================================

const submitQuizProgress = async (req, res) => {
  try {
    const child = await verifyChildOwnership(req.params.childId, req.userId);
    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const { contentId, score, stars } = req.body;

    if (!contentId) {
      return res.status(400).json({
        success: false,
        message: "Content ID is required.",
      });
    }

    const existing = await Progress.findOne({
      childId: child._id,
      contentId,
      contentType: "quiz",
    });

    let progress;
    if (existing) {
      existing.score = Math.max(existing.score || 0, score || 0);
      existing.stars = Math.max(existing.stars || 0, stars || 0);
      existing.completed = true;
      existing.completedAt = new Date();
      await existing.save();
      progress = existing;
    } else {
      progress = await Progress.create({
        childId: child._id,
        contentId,
        contentType: "quiz",
        score: score || 0,
        stars: stars || 0,
        completed: true,
        completedAt: new Date(),
      });
    }

    if (stars && stars > 0) {
      try {
        await Reward.findOneAndUpdate(
          { childId: child._id, sourceType: "quiz", sourceId: contentId },
          { childId: child._id, sourceType: "quiz", sourceId: contentId, stars },
          { upsert: true, new: true }
        );
      } catch (_) {
        // Reward may already exist
      }
    }

    return res.status(201).json({
      success: true,
      message: "Quiz progress saved.",
      data: {
        id: progress._id,
        childId: progress.childId,
        contentId: progress.contentId,
        contentType: progress.contentType,
        score: progress.score,
        stars: progress.stars,
        completed: progress.completed,
        completedAt: progress.completedAt,
      },
    });
  } catch (error) {
    console.error("Submit quiz progress error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// POST /api/progress/:childId/game
// Submit game progress
// ======================================================

const submitGameProgress = async (req, res) => {
  try {
    const child = await verifyChildOwnership(req.params.childId, req.userId);
    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const { contentId, score, stars } = req.body;

    if (!contentId) {
      return res.status(400).json({
        success: false,
        message: "Content ID is required.",
      });
    }

    const existing = await Progress.findOne({
      childId: child._id,
      contentId,
      contentType: "game",
    });

    let progress;
    if (existing) {
      existing.score = Math.max(existing.score || 0, score || 0);
      existing.stars = Math.max(existing.stars || 0, stars || 0);
      existing.completed = true;
      existing.completedAt = new Date();
      await existing.save();
      progress = existing;
    } else {
      progress = await Progress.create({
        childId: child._id,
        contentId,
        contentType: "game",
        score: score || 0,
        stars: stars || 0,
        completed: true,
        completedAt: new Date(),
      });
    }

    if (stars && stars > 0) {
      try {
        await Reward.findOneAndUpdate(
          { childId: child._id, sourceType: "game", sourceId: contentId },
          { childId: child._id, sourceType: "game", sourceId: contentId, stars },
          { upsert: true, new: true }
        );
      } catch (_) {
        // Reward may already exist
      }
    }

    return res.status(201).json({
      success: true,
      message: "Game progress saved.",
      data: {
        id: progress._id,
        childId: progress.childId,
        contentId: progress.contentId,
        contentType: progress.contentType,
        score: progress.score,
        stars: progress.stars,
        completed: progress.completed,
        completedAt: progress.completedAt,
      },
    });
  } catch (error) {
    console.error("Submit game progress error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// POST /api/progress/:childId/sync
// Offline sync — idempotent via clientId
// ======================================================

const syncProgress = async (req, res) => {
  try {
    const child = await verifyChildOwnership(req.params.childId, req.userId);
    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const { records } = req.body;

    if (!Array.isArray(records) || records.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Records array is required.",
      });
    }

    const results = [];

    for (const record of records) {
      const { clientId, contentId, contentType, score, stars } = record;

      if (!clientId || !contentId || !contentType) {
        results.push({
          clientId: clientId || null,
          status: "skipped",
          reason: "Missing required fields.",
        });
        continue;
      }

      if (!["lesson", "quiz", "game"].includes(contentType)) {
        results.push({
          clientId,
          status: "skipped",
          reason: "Invalid contentType.",
        });
        continue;
      }

      const existing = await Progress.findOne({ clientId });

      if (existing) {
        results.push({
          clientId,
          status: "duplicate",
          progressId: existing._id,
        });
        continue;
      }

      const progress = await Progress.create({
        childId: child._id,
        contentId,
        contentType,
        score: score || 0,
        stars: stars || 0,
        completed: true,
        clientId,
        completedAt: new Date(),
      });

      if (stars && stars > 0) {
        try {
          await Reward.findOneAndUpdate(
            { childId: child._id, sourceType: contentType, sourceId: contentId },
            { childId: child._id, sourceType: contentType, sourceId: contentId, stars },
            { upsert: true, new: true }
          );
        } catch (_) {
          // Reward may already exist
        }
      }

      results.push({
        clientId,
        status: "created",
        progressId: progress._id,
      });
    }

    return res.status(200).json({
      success: true,
      message: "Sync complete.",
      data: {
        total: records.length,
        created: results.filter((r) => r.status === "created").length,
        duplicates: results.filter((r) => r.status === "duplicate").length,
        skipped: results.filter((r) => r.status === "skipped").length,
        results,
      },
    });
  } catch (error) {
    console.error("Sync progress error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/progress/:childId
// Get all progress for a child
// ======================================================

const getChildProgress = async (req, res) => {
  try {
    const child = await verifyChildOwnership(req.params.childId, req.userId);
    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const progress = await Progress.find({ childId: child._id })
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      data: progress.map((p) => ({
        id: p._id,
        childId: p.childId,
        contentId: p.contentId,
        contentType: p.contentType,
        score: p.score,
        stars: p.stars,
        completed: p.completed,
        completedAt: p.completedAt,
      })),
    });
  } catch (error) {
    console.error("Get child progress error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/progress/:childId/summary
// Get summary of progress for a child
// ======================================================

const getChildProgressSummary = async (req, res) => {
  try {
    const child = await verifyChildOwnership(req.params.childId, req.userId);
    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    const allProgress = await Progress.find({ childId: child._id });

    const totalLessons = allProgress.filter((p) => p.contentType === "lesson").length;
    const totalQuizzes = allProgress.filter((p) => p.contentType === "quiz").length;
    const totalGames = allProgress.filter((p) => p.contentType === "game").length;
    const totalStars = allProgress.reduce((sum, p) => sum + (p.stars || 0), 0);
    const totalScore = allProgress.reduce((sum, p) => sum + (p.score || 0), 0);

    return res.status(200).json({
      success: true,
      data: {
        childId: child._id,
        nickname: child.nickname,
        totalLessons,
        totalQuizzes,
        totalGames,
        totalStars,
        totalScore,
        totalActivities: allProgress.length,
      },
    });
  } catch (error) {
    console.error("Get summary error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


module.exports = {
  submitLessonProgress,
  submitQuizProgress,
  submitGameProgress,
  syncProgress,
  getChildProgress,
  getChildProgressSummary,
};
