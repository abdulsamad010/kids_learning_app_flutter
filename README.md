# 🎓 Kids Learning App — Flutter

> **Humaitec 12-Week Internship — First Project Task**

A child-friendly educational application developed as the **first project task of the Humaitec 12-week internship**. The project combines a Flutter frontend with a Node.js, Express.js, and MongoDB backend to provide structured learning, quizzes, educational games, rewards, and progress tracking.

This repository also preserves the earlier individual development work separately from the **Final Integrated Project**.

---

## 📌 Project Overview

The Kids Learning App is designed around two main experiences:

### 👨‍👩‍👧 Parent

- Parent registration and login
- Parent profile management
- Child profile creation and management
- Child selection and switching
- Learning progress viewing
- Parent settings
- Logout

### 🧒 Child

- Child profile access
- Subject and lesson exploration
- Step-by-step learning activities
- Interactive quizzes
- Educational games
- Stars and rewards
- Learning progress tracking

---

## ✨ Main Features

### 🔐 Authentication

- Parent registration and login
- Forgot and reset password
- JWT-based authentication
- Password hashing
- Authentication state handling
- Protected API requests
- Logout

### 📚 Learning

- Subject-based learning
- English, Mathematics, Science, and Logic content
- Lesson lists and lesson details
- Step-by-step lesson activities
- Lesson completion and progress tracking

### 🧠 Quizzes

The application supports:

- Multiple Choice
- True/False
- Matching
- Question navigation
- Answer selection and feedback
- Quiz scoring and percentage calculation
- Quiz results
- Progress tracking

For the lesson assessment flow, the learner selects **one quiz type and attempts it once**. After submission, the result and learning progress are recorded and the other quiz types for that lesson are blocked.

### 📝 Step Engine

The project includes a **Step Engine** for the quiz experience, where the learner progresses through **8 steps** to complete the assessment.

### 🎮 Educational Games

- Matching Pairs
- Sort It Out
- Pattern Builder
- Counting Tap

### ⭐ Rewards

- Stars
- Learning rewards
- Quiz rewards
- Game rewards
- Child reward tracking

### 📊 Progress

- Lesson progress
- Quiz progress
- Game progress
- Subject progress
- Child learning summary
- Recent learning activity

---

## 🏗️ Technology Stack

| Area | Technology |
|---|---|
| Frontend | Flutter |
| Language | Dart |
| UI | Material Design |
| State Management | Provider |
| API | REST API |
| Backend | Node.js |
| Framework | Express.js |
| Database | MongoDB |
| ODM | Mongoose |
| Authentication | JWT |
| Password Security | bcryptjs |
| Version Control | Git & GitHub |

---

## 🔄 Application Flow

```text
Authentication
      ↓
Parent / Child Experience
      ↓
Child Selection
      ↓
Child Home
      ↓
Subjects
      ↓
Lessons
      ↓
Learning Activities
      ↓
Quiz / Educational Game
      ↓
Result
      ↓
Rewards
      ↓
Progress
```

### Quiz Flow

```text
Lesson
   ↓
Quiz Selection
   ↓
Select One Quiz Type
   ↓
8-Step Step Engine
   ↓
Submit Quiz
   ↓
Quiz Result
   ↓
Learning Report
   ↓
Progress
```

---

## 🏛️ Architecture

The final integrated application follows a Flutter frontend and Node.js backend architecture:

```text
                Kids Learning App
                       │
          ┌────────────┴────────────┐
          │                         │
   Flutter Frontend          Node.js Backend
          │                         │
          │                    Express.js
          │                         │
          └─────── REST API ────────┘
                                    │
                                 MongoDB
```

The frontend uses a feature-based structure, while the backend separates configuration, models, controllers, routes, and middleware.

---

## 📁 Repository Structure

```text
kids_learning_app_flutter/
│
├── README.md
│
├── My Work/
│   └── Individual Flutter development work
│
└── Final Integrated Project/
    │
    ├── backend/
    │   ├── src/
    │   │   ├── config/
    │   │   ├── models/
    │   │   ├── controllers/
    │   │   ├── routes/
    │   │   └── middleware/
    │   ├── server.js
    │   └── package.json
    │
    └── kid_app/
        ├── android/
        ├── ios/
        ├── web/
        ├── lib/
        ├── assets/
        └── pubspec.yaml
```

### `My Work`

Contains the individual development work completed during the project, including the earlier Flutter implementation and development work.

### `Final Integrated Project`

Contains the completed integrated application developed through the combined project work, including the Flutter frontend and Node.js/Express.js backend with MongoDB integration.

---

## 🌐 Backend

The backend provides REST API support for authentication, children, learning content, quizzes, games, progress, and rewards.

Example API areas include:

```text
/api/auth
/api/children
/api/content
/api/progress
/api/rewards
/api/health
```

The backend uses MongoDB through Mongoose for application data.

Sensitive configuration such as database credentials and JWT secrets should be stored in environment variables and not committed to the repository.

Example:

```text
PORT=3000
MONGO_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
```

---

## ⚙️ Setup

### Prerequisites

- Flutter SDK
- Dart SDK
- Node.js
- npm
- MongoDB or MongoDB Atlas
- Android Studio or VS Code
- Git

### Backend

```bash
cd "Final Integrated Project/backend"
npm install
```

Create a `.env` file and configure the required environment variables.

Start the development server:

```bash
npm run dev
```

or:

```bash
npm start
```

### Flutter

```bash
cd "Final Integrated Project/kid_app"
flutter pub get
flutter analyze
flutter run
```

---

## 📱 Android Emulator

When the backend is running locally on the development machine, an Android Emulator normally accesses the host machine through:

```text
http://10.0.2.2:3000
```

For a physical Android device, use the development machine's local network IP where required.

---

## 🧪 Testing

The integrated application should be tested across the main user flows:

```text
Authentication
      ↓
Parent / Child Management
      ↓
Learning Content
      ↓
Lessons
      ↓
8-Step Quiz
      ↓
Quiz Result
      ↓
Learning Report
      ↓
Games
      ↓
Rewards
      ↓
Progress
```

Testing focuses on frontend behavior, backend communication, database operations, feature integration, UI behavior, and the overall application flow.

---

## 🚧 Project Status

**Humaitec Internship — First Project Task**

The first project task is a **three-week project within the overall 12-week Humaitec internship**.

The project progressed from initial Flutter development and feature implementation to integration with the backend and MongoDB. The repository keeps the earlier individual work and the final integrated project organized separately.

---

## 👥 Project Contributors

The project was developed collaboratively by two co-workers as part of the internship project task:

- **[Abdul Samad](https://github.com/abdulsamad010)** — Co-worker
- **[Saud Masood](https://github.com/SaudMasood)** — Co-worker

Both contributors worked on different parts of the application and collaborated to integrate their work into the final project.

---

## 📌 Project Information

**Internship:** Humaitec 12-Week Internship  
**Project:** Kids Learning App  
**Task:** First Project Task  
**Project Duration:** Three Weeks  
**Primary Technologies:** Flutter, Dart, Node.js, Express.js, MongoDB

The project was developed collaboratively by **Abdul Samad and Saud Masood** and their individual work was integrated into the final application.
