const express = require("express");

const {
  getChildren,
  createChild,
  getChildById,
  updateChild,
  deleteChild,
} = require("../controllers/childController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

// All child routes require authentication

router.use(authMiddleware);

router.get("/", getChildren);

router.post("/", createChild);

router.get("/:childId", getChildById);

router.put("/:childId", updateChild);

router.delete("/:childId", deleteChild);

module.exports = router;
