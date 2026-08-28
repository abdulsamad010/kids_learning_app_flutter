require("dotenv").config();

const dns = require("node:dns");
// This machine's default DNS (Ethernet adapter, 10.21.32.1) does not resolve
// MongoDB Atlas SRV records, causing "querySrv ECONNREFUSED" in Mongoose.
// Pin Node's resolver to a public DNS so mongodb+srv:// lookups succeed.
dns.setServers(["8.8.8.8", "8.8.4.4"]);

const app = require("./src/app");
const connectDB = require("./src/config/db");

const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    await connectDB();

    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Server startup failed:", error.message);
    process.exit(1);
  }
};

startServer();