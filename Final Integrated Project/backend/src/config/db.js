const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      serverSelectionTimeoutMS: 15000,
    });

    console.log("MongoDB connected successfully");
  } catch (error) {
    const reason = error.cause ? ` (${error.cause.message})` : "";
    console.error(
      `MongoDB connection failed (${error.name || "Error"}): ${error.message}${reason}`
    );
    console.error(
      "Check: DNS resolution, network access, Atlas IP Access List, and database user credentials."
    );
    throw error;
  }
};

module.exports = connectDB;
