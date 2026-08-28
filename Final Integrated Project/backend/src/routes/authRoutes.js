const express = require("express");

const {
  register,
  login,
  logout,
  forgotPassword,
  resetPassword,
  changePassword,
} = require("../controllers/authController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();


// Public routes

router.post("/register", register);

router.post("/login", login);

router.post("/logout", logout);

router.post("/forgot-password", forgotPassword);

router.post("/reset-password", resetPassword);


// Protected routes

router.post(
  "/change-password",
  authMiddleware,
  changePassword
);


module.exports = router;