````markdown
# Kids Learning App – Flutter

A Flutter-based educational application developed as the **first project task** of the **Humaitec 12-Week Software Development Internship**.

This project is a **3-week project assignment** within the overall 12-week internship.

## Project Overview

The Kids Learning App is designed to provide children with an interactive learning experience through subjects, lessons, educational content, quizzes, and learning progress.

## Features

- Subject and lesson navigation
- Structured lesson content
- Multiple Choice quizzes
- True/False quizzes
- Matching quizzes
- One quiz attempt per lesson
- Question and answer handling
- Quiz scoring and percentage calculation
- Pass/fail evaluation
- Level calculation and level progression
- Learning reports
- User learning progress
- Responsive Flutter UI
- Animated and interactive components
- Local dummy data for development and demonstration
- API-ready service structure

## Quiz System

The application supports three quiz types:

- Multiple Choice
- True/False
- Matching

Each quiz type has a dedicated interface and interaction flow.

Only **one quiz can be attempted per lesson** to ensure that the lesson result and progress are based on a single quiz attempt.

## Level System

| Percentage | Level |
|------------|-------|
| 0–39% | Level 1 |
| 40–59% | Level 2 |
| 60–79% | Level 3 |
| 80–100% | Level 4 |

A quiz is considered passed with a score of **50% or higher**.

## Application Flow

```text
Home
  ↓
Subjects
  ↓
Lessons
  ↓
Lesson Content
  ↓
Quiz Selection
  ↓
One Quiz Attempt
  ↓
Quiz Result
  ↓
Learning Report
  ↓
Progress
````

## Project Structure

```text
lib/
├── main.dart
│
└── features/
    ├── content/
    │   ├── data/
    │   │   └── dummy_data.dart
    │   ├── models/
    │   ├── screens/
    │   ├── services/
    │   └── widgets/
    │
    └── quiz/
        ├── data/
        │   └── dummy_data.dart
        ├── models/
        ├── screens/
        ├── services/
        └── widgets/
```

## Data Handling

The application uses service classes for content and quiz data.

The current implementation includes local dummy data for:

* Subjects
* Lessons
* Lesson steps
* Quizzes
* Questions
* Answers
* Quiz progress
* User progress

The service layer is structured to support backend API integration. If the API is unavailable, the application falls back to the local dummy data for development and demonstration.

## Technologies

* Flutter
* Dart
* Material 3
* HTTP
* JSON
* Git
* GitHub
* Android Studio

## Getting Started

### Install Dependencies

```bash
flutter pub get
```

### Run on Android

```bash
flutter run
```

### Run on Chrome

```bash
flutter run -d chrome
```

## Internship Context

**Organization:** Humaitec
**Internship:** 12-Week Software Development Internship
**Project:** First Project Task
**Project Duration:** 3 Weeks
**Technology:** Flutter / Dart

This repository contains the development work for the first three-week project task completed as part of the Humaitec internship.

```
```
