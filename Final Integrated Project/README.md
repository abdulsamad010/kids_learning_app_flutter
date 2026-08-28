# 🧒 Kid App MVP — Humaitec Internship Task 1

A **Kids Learning App MVP** developed as part of the **Humaitec Internship**. The project provides a foundation for a child-friendly educational platform where parents can manage child profiles and children can access learning content, lessons, quizzes, educational games, rewards, and progress tracking.

The project follows a **Flutter frontend + Node.js backend + MongoDB** architecture with REST API integration.

---

## 📱 Project Overview

The **Kid App MVP** is designed around two primary user experiences:

### 👨‍👩‍👧 Parent

Parents can:

* Register and log in
* Manage their profile
* Create child profiles
* Edit child profiles
* Delete child profiles
* Select/switch between children
* View children's learning progress
* Access parent settings
* Log out securely

### 🧒 Child

Children can:

* Access their child profile
* Explore subjects
* Open lessons
* Complete learning activities
* Attempt quizzes
* Play educational games
* Earn stars/rewards
* Track learning progress

---

## ✨ Features

### 🔐 Authentication

* Parent Registration
* Parent Login
* Forgot Password
* Reset Password
* JWT Authentication
* Password Hashing
* Authentication State Management
* Logout
* Protected API Requests

### 👨‍👩‍👧 Parent & Child Management

* Parent Profile
* Child Profile Creation
* Child Profile Viewing
* Child Profile Editing
* Child Profile Deletion
* Child Selection
* Child Switching
* Parent Dashboard

### 📚 Learning

* Subject-based learning
* English
* Mathematics
* Science
* Logic
* Lesson lists
* Lesson details
* Lesson completion
* Learning activities

### 📝 Quizzes

* Multiple Choice
* True/False
* Matching
* Question navigation
* Answer feedback
* Quiz results
* Retry functionality
* Quiz progress

### 🎮 Educational Games

* Matching Pairs
* Sort It Out
* Pattern Builder
* Counting Tap

### ⭐ Rewards

* Stars
* Learning rewards
* Quiz rewards
* Game rewards
* Child reward tracking

### 📊 Progress

* Lesson progress
* Quiz progress
* Game progress
* Subject progress
* Child learning summary
* Recent learning activity

---

# 🏗️ Architecture

The project is divided into two independent applications:

```text
                    Kid App MVP
                         │
             ┌───────────┴───────────┐
             │                       │
        Flutter Frontend        Node.js Backend
             │                       │
             │                    Express.js
             │                       │
             └────── REST API ───────┘
                                     │
                                  MongoDB
```

---

# 📁 Project Structure

```text
kid_app_mvp_humaitec_internship/
│
├── frontend/
│   │
│   ├── android/
│   ├── ios/
│   ├── web/
│   │
│   ├── lib/
│   │   │
│   │   ├── core/
│   │   │   ├── theme/
│   │   │   ├── common/
│   │   │   ├── constants/
│   │   │   ├── network/
│   │   │   └── interfaces/
│   │   │
│   │   ├── features/
│   │   │   │
│   │   │   ├── auth/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   ├── parent/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   ├── child/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   ├── content/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   ├── quiz/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   ├── games/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   ├── rewards/
│   │   │   │   ├── models/
│   │   │   │   ├── views/
│   │   │   │   ├── viewmodels/
│   │   │   │   └── repositories/
│   │   │   │
│   │   │   └── progress/
│   │   │       ├── models/
│   │   │       ├── views/
│   │   │       ├── viewmodels/
│   │   │       └── repositories/
│   │   │
│   │   └── main.dart
│   │
│   ├── assets/
│   │   ├── images/
│   │   ├── icons/
│   │   └── animations/
│   │
│   ├── pubspec.yaml
│   └── README.md
│
├── backend/
│   │
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js
│   │   ├── models/
│   │   ├── controllers/
│   │   ├── routes/
│   │   └── middleware/
│   │
│   ├── server.js
│   ├── package.json
│   ├── .env
│   └── .gitignore
│
└── README.md
```

---

# 🧩 Frontend Architecture

The Flutter application uses a feature-based architecture.

### `core/`

Contains functionality shared across the application.

```text
core/
├── theme/
├── common/
├── constants/
├── network/
└── interfaces/
```

### `features/`

Contains application-specific modules.

Each feature can contain:

```text
models/
views/
viewmodels/
repositories/
```

### Models

Represent API/database data.

Examples:

```text
UserModel
ChildModel
SubjectModel
LessonModel
QuizModel
GameModel
ProgressModel
RewardModel
```

### Views

Contain Flutter UI screens.

### ViewModels

Handle UI state and business logic.

### Repositories

Handle communication with APIs and data sources.

---

# 🔧 Backend Architecture

The backend uses:

* Node.js
* Express.js
* MongoDB
* Mongoose
* JWT
* bcryptjs
* REST APIs

Backend structure:

```text
backend/
│
├── src/
│   ├── config/
│   ├── models/
│   ├── controllers/
│   ├── routes/
│   └── middleware/
│
├── server.js
├── package.json
├── .env
└── .gitignore
```

### `config/`

Database configuration and connection.

### `models/`

MongoDB/Mongoose models.

### `controllers/`

Application/business logic.

### `routes/`

API endpoint definitions.

### `middleware/`

Authentication, authorization, and request processing.

---

# 🔄 Application Flow

## Authentication

```text
Splash
   ↓
Authentication Check
   ↓
Not Logged In
   ↓
Login
   ├── Register
   └── Forgot Password
```

After successful authentication:

```text
Login/Register
      ↓
Authentication State
      ↓
Child Selector
      ↓
Child Home
```

---

## 👨‍👩‍👧 Parent Flow

```text
Parent Login
      ↓
Child Selector
      ↓
Parent Dashboard
      ├── Parent Profile
      ├── Manage Children
      ├── Child Progress
      └── Settings
```

---

## 🧒 Child Flow

```text
Child Selector
      ↓
Child Home
      ├── Subjects
      │     ↓
      │   Lessons
      │     ↓
      │   Quiz
      │     ↓
      │   Rewards
      │
      ├── Games
      │     ↓
      │   Game Result
      │     ↓
      │   Rewards
      │
      └── Progress
```

---

# 🌐 API Structure

The Flutter frontend communicates with the Node.js backend through REST APIs.

## Authentication

```text
POST /api/auth/register
POST /api/auth/login
POST /api/auth/logout
POST /api/auth/forgot-password
POST /api/auth/reset-password
```

## Children

```text
GET    /api/children
POST   /api/children
GET    /api/children/:childId
PUT    /api/children/:childId
DELETE /api/children/:childId
```

## Learning Content

```text
GET /api/content/subjects
GET /api/content/subjects/:subjectId
GET /api/content/lessons/:lessonId
GET /api/content/lessons/:lessonId/quiz
GET /api/content/games
GET /api/content/games/:gameId
```

## Progress

```text
POST /api/progress/:childId/lesson
POST /api/progress/:childId/quiz
POST /api/progress/:childId/game
POST /api/progress/:childId/sync

GET /api/progress/:childId
GET /api/progress/:childId/summary
```

## Rewards

```text
GET /api/rewards/:childId
```

## Health Check

```text
GET /api/health
```

---

# 🔐 Authentication & Security

The backend uses JWT-based authentication.

Protected requests use:

```text
Authorization: Bearer <token>
```

Passwords are hashed using **bcryptjs** before being stored in MongoDB.

Sensitive configuration is stored in environment variables.

Example:

```env
PORT=3000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key
```

> Never commit `.env` or real database credentials to GitHub.

---

# 🗄️ Database

The application uses **MongoDB** through **Mongoose**.

The database stores application data such as:

* Parents/users
* Children
* Subjects
* Lessons
* Quizzes
* Games
* Progress
* Rewards

---

# ⚙️ Installation & Setup

## Prerequisites

Install:

* Flutter SDK
* Dart SDK
* Node.js
* npm
* MongoDB / MongoDB Atlas
* Android Studio or VS Code
* Git

---

## 1. Clone Repository

```bash
git clone <repository-url>
```

Then:

```bash
cd kid_app_mvp_humaitec_internship
```

---

# 2. Backend Setup

Move into the backend:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Create:

```text
.env
```

Add your environment variables:

```env
PORT=3000
MONGO_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
```

Start development server:

```bash
npm run dev
```

Or:

```bash
npm start
```

Verify the API:

```text
http://localhost:3000/api/health
```

---

# 3. Flutter Setup

Open another terminal.

Move to frontend:

```bash
cd frontend
```

Install dependencies:

```bash
flutter pub get
```

Check project:

```bash
flutter analyze
```

Run application:

```bash
flutter run
```

---

# 📱 Android Emulator API Configuration

When running the backend locally on:

```text
http://localhost:3000
```

the Android Emulator should normally access the host machine through:

```text
http://10.0.2.2:3000
```

Therefore, configure the Flutter API base URL accordingly.

For a physical Android device, use the development machine's local network IP instead.

---

# 🧪 Testing

Before considering the MVP complete, test the main flow:

### Authentication

```text
Register
↓
Login
↓
Authentication State
↓
Logout
↓
Login Again
```

### Parent & Child

```text
Create Child
↓
View Child
↓
Select Child
↓
Edit Child
↓
Delete Child
```

### Learning

```text
Select Child
↓
Subjects
↓
Lessons
↓
Quiz
↓
Result
↓
Rewards
```

### Games

```text
Games
↓
Select Game
↓
Play
↓
Result
↓
Reward
```

### Progress

```text
Lesson / Quiz / Game
↓
Save Progress
↓
View Child Progress
```

---

# 🛠️ Development Commands

### Flutter

```bash
flutter pub get
flutter analyze
flutter clean
flutter run
```

### Backend

```bash
npm install
npm run dev
npm start
```

---

# 📦 Tech Stack

| Layer             | Technology               |
| ----------------- | ------------------------ |
| Frontend          | Flutter                  |
| Language          | Dart                     |
| State Management  | Provider                 |
| API               | REST API                 |
| Backend           | Node.js                  |
| Framework         | Express.js               |
| Database          | MongoDB                  |
| ODM               | Mongoose                 |
| Authentication    | JWT                      |
| Password Security | bcryptjs                 |
| Development       | VS Code / Android Studio |
| Version Control   | Git & GitHub             |

---

# 🎯 MVP Scope

The MVP focuses on the essential functionality required for the initial version of the Kids Learning App:

* Authentication
* Parent management
* Child management
* Learning content
* Lessons
* Quizzes
* Educational games
* Rewards
* Progress tracking
* Basic settings

Advanced features outside the MVP scope can be implemented in future iterations.

---

# 🚧 Project Status

**Humaitec Internship — Task 1**

The project is being developed incrementally according to the project requirements and SRS.

Current development priorities:

```text
Authentication
      ↓
Parent & Child Management
      ↓
Learning Content
      ↓
Lessons
      ↓
Quizzes
      ↓
Games
      ↓
Rewards
      ↓
Progress
      ↓
Settings / Offline Sync
```

---

# 👨‍💻 Developer

**Saud Masood**

BS Computer Science Graduate
National Skills University Islamabad

**Role:** Flutter Development Intern
**Organization:** Humaitec
**Project:** Kids Learning App MVP
**Task:** Internship Task 1

---

# 📄 License

This project was developed for **educational and internship purposes** as part of the Humaitec internship program.
