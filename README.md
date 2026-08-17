# 🎓 Kids Learning App – Flutter

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Material%20Design-UI-757575?logo=materialdesign&logoColor=white" alt="Material Design">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web-34A853?logo=googlechrome&logoColor=white" alt="Platform">
</p>

<p align="center">
  <strong>Interactive Educational Learning Application for Children</strong>
</p>

<p align="center">
  Developed as the <strong>First Project Task</strong> of the <strong>Humaitec 12-Week Internship</strong>
</p>

---

## 📚 Project Overview

**Kids Learning App** is a Flutter-based educational application designed to provide children with a structured and interactive learning experience.

The application organizes educational content into **subjects, lessons, lesson steps, quizzes, results, learning reports, and progress tracking**.

This repository contains the development work for the **first three-week project task** within the overall **12-week Humaitec internship**.

---

## ✨ Key Features

### 📖 Subjects & Lessons

- Subject-based learning structure
- Lesson listing for each subject
- Individual lesson content
- Step-by-step lesson navigation
- Lesson progress tracking
- Responsive lesson interfaces

### 🧠 Interactive Quizzes

The application supports three quiz types:

- 📝 Multiple Choice
- ✅ True or False
- 🔄 Matching

Each quiz type has a dedicated interactive interface.

### 🔒 One Quiz Attempt Per Lesson

For each lesson, the user can select **only one quiz type and attempt it once**.

After completing a quiz:

- The quiz result is saved
- The lesson progress is updated
- Other quiz types are blocked for that lesson
- The user proceeds to the learning report

This keeps the lesson assessment consistent and prevents multiple quiz attempts from affecting the final learning result.

### 📊 Quiz Results

The application tracks and displays:

- ⭐ Score
- 📋 Total questions
- 📈 Percentage
- ✅ Correct answers
- 🎯 Pass/fail status
- ⬅️ Previous level
- ⭐ Current level
- 📊 Level change
- 📝 Quiz type
- ✔️ Selected answers

### 📑 Learning Report

After completing the selected quiz, the application provides a learning report showing the user's:

- Quiz performance
- Score percentage
- Learning status
- Previous level
- Current level
- Progress information

### 📈 Learning Progress

The application maintains progress information including:

- Current level
- Score
- Completed quizzes
- Total quizzes
- Progress percentage
- Learning status
- Last quiz result
- Last lesson progress

---

## 🎯 Learning Flow

```text
🏠 Home
   ↓
📚 Select Subject
   ↓
📖 Select Lesson
   ↓
📘 Lesson Content
   ↓
🧠 Quiz Selection
   ↓
✏️ One Quiz Attempt
   ↓
📊 Quiz Result
   ↓
📑 Learning Report
   ↓
📈 Progress
