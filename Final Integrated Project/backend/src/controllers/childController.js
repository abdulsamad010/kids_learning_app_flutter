const Child = require("../models/Child");


// ======================================================
// GET /api/children
// Get all children for the authenticated parent
// ======================================================

const getChildren = async (req, res) => {
  try {
    const children = await Child.find({ parentId: req.userId })
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      data: children.map((c) => ({
        id: c._id,
        nickname: c.nickname,
        age: c.age,
        learningLevel: c.learningLevel,
        avatar: c.avatar,
      })),
    });
  } catch (error) {
    console.error("Get children error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// POST /api/children
// Create a new child profile
// ======================================================

const createChild = async (req, res) => {
  try {
    const { nickname, age, learningLevel, avatar } = req.body;

    if (!nickname || age == null) {
      return res.status(400).json({
        success: false,
        message: "Nickname and age are required.",
      });
    }

    if (age < 2 || age > 12) {
      return res.status(400).json({
        success: false,
        message: "Age must be between 2 and 12.",
      });
    }

    const child = await Child.create({
      nickname: nickname.trim(),
      age,
      learningLevel: learningLevel || "beginner",
      avatar: avatar || "default_avatar",
      parentId: req.userId,
    });

    return res.status(201).json({
      success: true,
      message: "Child profile created.",
      data: {
        id: child._id,
        nickname: child.nickname,
        age: child.age,
        learningLevel: child.learningLevel,
        avatar: child.avatar,
      },
    });
  } catch (error) {
    console.error("Create child error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// GET /api/children/:childId
// Get a single child by ID
// ======================================================

const getChildById = async (req, res) => {
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

    return res.status(200).json({
      success: true,
      data: {
        id: child._id,
        nickname: child.nickname,
        age: child.age,
        learningLevel: child.learningLevel,
        avatar: child.avatar,
      },
    });
  } catch (error) {
    console.error("Get child error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// PUT /api/children/:childId
// Update a child profile
// ======================================================

const updateChild = async (req, res) => {
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

    const { nickname, age, learningLevel, avatar } = req.body;

    if (nickname !== undefined) child.nickname = nickname.trim();
    if (age !== undefined) {
      if (age < 2 || age > 12) {
        return res.status(400).json({
          success: false,
          message: "Age must be between 2 and 12.",
        });
      }
      child.age = age;
    }
    if (learningLevel !== undefined) child.learningLevel = learningLevel;
    if (avatar !== undefined) child.avatar = avatar;

    await child.save();

    return res.status(200).json({
      success: true,
      message: "Child profile updated.",
      data: {
        id: child._id,
        nickname: child.nickname,
        age: child.age,
        learningLevel: child.learningLevel,
        avatar: child.avatar,
      },
    });
  } catch (error) {
    console.error("Update child error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


// ======================================================
// DELETE /api/children/:childId
// Delete a child profile
// ======================================================

const deleteChild = async (req, res) => {
  try {
    const child = await Child.findOneAndDelete({
      _id: req.params.childId,
      parentId: req.userId,
    });

    if (!child) {
      return res.status(404).json({
        success: false,
        message: "Child not found.",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Child profile deleted.",
    });
  } catch (error) {
    console.error("Delete child error:", error.message);
    return res.status(500).json({
      success: false,
      message: "Server error.",
    });
  }
};


module.exports = {
  getChildren,
  createChild,
  getChildById,
  updateChild,
  deleteChild,
};
