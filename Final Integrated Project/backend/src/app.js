const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const childRoutes = require("./routes/childRoutes");
const contentRoutes = require("./routes/contentRoutes");
const progressRoutes = require("./routes/progressRoutes");
const rewardRoutes = require("./routes/rewardRoutes");

const app = express();

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(express.json());

// Health check
app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "Kids Learning API is running.",
  });
});

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/children", childRoutes);
app.use("/api/content", contentRoutes);
app.use("/api/progress", progressRoutes);
app.use("/api/rewards", rewardRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found.",
  });
});

// Global error handler (must have 4 params for Express to treat it as error middleware)
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  console.error("Unhandled error:", err.message);
  if (err.name === "CastError") {
    return res.status(400).json({
      success: false,
      message: "Invalid ID format.",
    });
  }
  if (err.name === "ValidationError") {
    return res.status(400).json({
      success: false,
      message: err.message,
    });
  }
  if (err.name === "JsonWebTokenError") {
    return res.status(401).json({
      success: false,
      message: "Invalid token.",
    });
  }
  if (err.name === "TokenExpiredError") {
    return res.status(401).json({
      success: false,
      message: "Token expired.",
    });
  }
  res.status(500).json({
    success: false,
    message: "Server error.",
  });
});

module.exports = app;
