require("dotenv").config();

const dns = require("node:dns");
dns.setServers(["8.8.8.8", "8.8.4.4"]);

const mongoose = require("mongoose");

const Subject = require("./models/Subject");
const Lesson = require("./models/Lesson");
const QuizQuestion = require("./models/QuizQuestion");
const Game = require("./models/Game");

const subjects = [
  {
    name: "English",
    description: "Learn letters, words, and reading skills.",
    icon: "menu_book",
    color: "#2196F3",
    order: 1,
  },
  {
    name: "Math",
    description: "Learn numbers, counting, and basic math.",
    icon: "calculate",
    color: "#FF9800",
    order: 2,
  },
  {
    name: "Science",
    description: "Explore the world around you.",
    icon: "science",
    color: "#4CAF50",
    order: 3,
  },
  {
    name: "Logic",
    description: "Build problem-solving and thinking skills.",
    icon: "psychology",
    color: "#9C27B0",
    order: 4,
  },
];

const lessons = [
  // English lessons
  {
    title: "The Alphabet Adventure",
    description: "Learn the letters A through Z.",
    subjectName: "English",
    order: 1,
    difficulty: "easy",
    starsReward: 3,
    steps: [
      { stepNumber: 1, title: "Welcome!", type: "introduction", content: { text: "Let's learn the alphabet together!" } },
      { stepNumber: 2, title: "Letter Sounds", type: "explanation", content: { text: "Each letter has a special sound. A says 'ah', B says 'buh'." } },
      { stepNumber: 3, title: "See It in Action", type: "example", content: { text: "A is for Apple, B is for Ball, C is for Cat." } },
      { stepNumber: 4, title: "Tap the Letters", type: "interactive_activity", content: { text: "Tap each letter to hear its sound." } },
      { stepNumber: 5, title: "Your Turn", type: "practice", content: { text: "Try to say each letter out loud." } },
      { stepNumber: 6, title: "Quick Quiz", type: "short_assessment", content: { text: "Can you find the letter B?" } },
      { stepNumber: 7, title: "Great Job!", type: "completion", content: { text: "You finished the Alphabet Adventure!" } },
      { stepNumber: 8, title: "Star Reward", type: "reward", content: { text: "You earned 3 stars!" } },
    ],
  },
  {
    title: "Simple Words",
    description: "Read and recognize simple 3-letter words.",
    subjectName: "English",
    order: 2,
    difficulty: "easy",
    starsReward: 3,
    steps: [
      { stepNumber: 1, title: "Let's Read!", type: "introduction", content: { text: "Time to read some simple words!" } },
      { stepNumber: 2, title: "CVC Words", type: "explanation", content: { text: "CVC words are consonant-vowel-consonant: cat, dog, sun." } },
      { stepNumber: 3, title: "Word Examples", type: "example", content: { text: "C-A-T spells cat. D-O-G spells dog." } },
      { stepNumber: 4, title: "Build a Word", type: "interactive_activity", content: { text: "Drag the letters to build the word 'sun'." } },
      { stepNumber: 5, title: "Read Along", type: "practice", content: { text: "Read each word: cat, dog, sun, hat, pen." } },
      { stepNumber: 6, title: "Word Quiz", type: "short_assessment", content: { text: "Which word starts with the letter 'd'?" } },
      { stepNumber: 7, title: "You Did It!", type: "completion", content: { text: "You can read simple words now!" } },
      { stepNumber: 8, title: "Star Reward", type: "reward", content: { text: "You earned 3 stars!" } },
    ],
  },
  // Math lessons
  {
    title: "Counting 1 to 10",
    description: "Learn to count from 1 to 10.",
    subjectName: "Math",
    order: 1,
    difficulty: "easy",
    starsReward: 3,
    steps: [
      { stepNumber: 1, title: "Hello Numbers!", type: "introduction", content: { text: "Let's learn to count!" } },
      { stepNumber: 2, title: "Number Names", type: "explanation", content: { text: "1 is one, 2 is two, 3 is three... up to 10!" } },
      { stepNumber: 3, title: "Count Together", type: "example", content: { text: "1 apple, 2 apples, 3 apples..." } },
      { stepNumber: 4, title: "Tap to Count", type: "interactive_activity", content: { text: "Tap each object to count them." } },
      { stepNumber: 5, title: "Practice Counting", type: "practice", content: { text: "Count the stars on the screen." } },
      { stepNumber: 6, title: "Number Quiz", type: "short_assessment", content: { text: "How many stars do you see? ★ ★ ★" } },
      { stepNumber: 7, title: "Awesome!", type: "completion", content: { text: "You can count to 10!" } },
      { stepNumber: 8, title: "Star Reward", type: "reward", content: { text: "You earned 3 stars!" } },
    ],
  },
  {
    title: "Basic Addition",
    description: "Learn to add numbers up to 10.",
    subjectName: "Math",
    order: 2,
    difficulty: "easy",
    starsReward: 3,
    steps: [
      { stepNumber: 1, title: "Adding Things Up", type: "introduction", content: { text: "Addition means putting numbers together!" } },
      { stepNumber: 2, title: "Plus Sign", type: "explanation", content: { text: "The + sign means add. 2 + 3 means 2 and 3 together." } },
      { stepNumber: 3, title: "Let's Try", type: "example", content: { text: "2 + 1 = 3. We added 2 and 1 to get 3!" } },
      { stepNumber: 4, title: "Add Them Up", type: "interactive_activity", content: { text: "Tap the blocks to add them together." } },
      { stepNumber: 5, title: "Practice Time", type: "practice", content: { text: "Solve: 3 + 2 = ?" } },
      { stepNumber: 6, title: "Quick Quiz", type: "short_assessment", content: { text: "What is 4 + 3?" } },
      { stepNumber: 7, title: "Math Star!", type: "completion", content: { text: "You can add numbers now!" } },
      { stepNumber: 8, title: "Star Reward", type: "reward", content: { text: "You earned 3 stars!" } },
    ],
  },
  // Science lessons
  {
    title: "Colors Around Us",
    description: "Learn about colors in nature.",
    subjectName: "Science",
    order: 1,
    difficulty: "easy",
    starsReward: 3,
    steps: [
      { stepNumber: 1, title: "Rainbow World", type: "introduction", content: { text: "The world is full of colors!" } },
      { stepNumber: 2, title: "Color Names", type: "explanation", content: { text: "Red, blue, yellow, green, orange, purple are all colors." } },
      { stepNumber: 3, title: "Nature Colors", type: "example", content: { text: "The sky is blue. Grass is green. The sun is yellow." } },
      { stepNumber: 4, title: "Color Match", type: "interactive_activity", content: { text: "Match each object to its color." } },
      { stepNumber: 5, title: "Color Hunt", type: "practice", content: { text: "Find all the red objects on the screen." } },
      { stepNumber: 6, title: "Color Quiz", type: "short_assessment", content: { text: "What color is the sky?" } },
      { stepNumber: 7, title: "Color Expert!", type: "completion", content: { text: "You know your colors!" } },
      { stepNumber: 8, title: "Star Reward", type: "reward", content: { text: "You earned 3 stars!" } },
    ],
  },
  // Logic lessons
  {
    title: "Pattern Power",
    description: "Identify and complete simple patterns.",
    subjectName: "Logic",
    order: 1,
    difficulty: "easy",
    starsReward: 3,
    steps: [
      { stepNumber: 1, title: "What is a Pattern?", type: "introduction", content: { text: "A pattern is something that repeats in a special order." } },
      { stepNumber: 2, title: "AB Patterns", type: "explanation", content: { text: "AB pattern: red, blue, red, blue... It repeats AB, AB, AB." } },
      { stepNumber: 3, title: "See the Pattern", type: "example", content: { text: "Circle, square, circle, square... What comes next? Circle!" } },
      { stepNumber: 4, title: "Complete It", type: "interactive_activity", content: { text: "Choose the shape that completes the pattern." } },
      { stepNumber: 5, title: "Practice Patterns", type: "practice", content: { text: "Star, heart, star, heart... What's next?" } },
      { stepNumber: 6, title: "Pattern Quiz", type: "short_assessment", content: { text: "A, B, A, B, A, ___?" } },
      { stepNumber: 7, title: "Pattern Pro!", type: "completion", content: { text: "You can spot patterns!" } },
      { stepNumber: 8, title: "Star Reward", type: "reward", content: { text: "You earned 3 stars!" } },
    ],
  },
];

const quizQuestions = [
  // English - Alphabet Adventure quiz
  {
    lessonTitle: "The Alphabet Adventure",
    question: "Which letter says 'buh'?",
    type: "multiple_choice",
    options: ["A", "B", "C", "D"],
    correctAnswer: "B",
    explanation: "The letter B makes the 'buh' sound.",
    order: 1,
  },
  {
    lessonTitle: "The Alphabet Adventure",
    question: "The letter A comes before B.",
    type: "true_false",
    options: ["True", "False"],
    correctAnswer: "True",
    explanation: "A is the first letter and B is the second.",
    order: 2,
  },
  // English - Simple Words quiz
  {
    lessonTitle: "Simple Words",
    question: "Which word starts with the letter 'd'?",
    type: "multiple_choice",
    options: ["cat", "dog", "sun", "hat"],
    correctAnswer: "dog",
    explanation: "Dog starts with the letter D.",
    order: 1,
  },
  {
    lessonTitle: "Simple Words",
    question: "C-A-T spells 'cat'.",
    type: "true_false",
    options: ["True", "False"],
    correctAnswer: "True",
    explanation: "Yes, C-A-T spells cat.",
    order: 2,
  },
  // Math - Counting quiz
  {
    lessonTitle: "Counting 1 to 10",
    question: "How many stars? ★ ★ ★",
    type: "multiple_choice",
    options: ["2", "3", "4", "5"],
    correctAnswer: "3",
    explanation: "There are 3 stars.",
    order: 1,
  },
  {
    lessonTitle: "Counting 1 to 10",
    question: "The number after 5 is 6.",
    type: "true_false",
    options: ["True", "False"],
    correctAnswer: "True",
    explanation: "6 comes after 5.",
    order: 2,
  },
  // Math - Addition quiz
  {
    lessonTitle: "Basic Addition",
    question: "What is 2 + 3?",
    type: "multiple_choice",
    options: ["4", "5", "6", "7"],
    correctAnswer: "5",
    explanation: "2 + 3 = 5.",
    order: 1,
  },
  {
    lessonTitle: "Basic Addition",
    question: "What is 4 + 3?",
    type: "multiple_choice",
    options: ["5", "6", "7", "8"],
    correctAnswer: "7",
    explanation: "4 + 3 = 7.",
    order: 2,
  },
  // Science - Colors quiz
  {
    lessonTitle: "Colors Around Us",
    question: "What color is the sky?",
    type: "multiple_choice",
    options: ["Red", "Blue", "Green", "Yellow"],
    correctAnswer: "Blue",
    explanation: "The sky is typically blue.",
    order: 1,
  },
  {
    lessonTitle: "Colors Around Us",
    question: "Grass is green.",
    type: "true_false",
    options: ["True", "False"],
    correctAnswer: "True",
    explanation: "Yes, grass is green.",
    order: 2,
  },
  // Logic - Pattern quiz
  {
    lessonTitle: "Pattern Power",
    question: "What comes next: A, B, A, B, A, ___?",
    type: "multiple_choice",
    options: ["A", "B", "C", "D"],
    correctAnswer: "B",
    explanation: "The AB pattern repeats: A, B, A, B, A, B.",
    order: 1,
  },
  {
    lessonTitle: "Pattern Power",
    question: "In an AB pattern, the elements alternate.",
    type: "true_false",
    options: ["True", "False"],
    correctAnswer: "True",
    explanation: "AB patterns alternate between two elements.",
    order: 2,
  },
];

const games = [
  {
    name: "Matching Pairs",
    type: "matching_pairs",
    description: "Match pairs of items by flipping cards.",
    difficulty: "easy",
    starsReward: 2,
    configuration: {
      gridSize: "4x2",
      pairs: 4,
      categories: ["animals", "fruits", "letters", "numbers"],
    },
  },
  {
    name: "Sort It Out",
    type: "sort_it_out",
    description: "Drag items into the correct category.",
    difficulty: "easy",
    starsReward: 2,
    configuration: {
      categories: ["red", "blue", "green"],
      itemCount: 6,
    },
  },
  {
    name: "Pattern Builder",
    type: "pattern_builder",
    description: "Complete the pattern by choosing the right shape.",
    difficulty: "easy",
    starsReward: 2,
    configuration: {
      patternTypes: ["AB", "ABB", "AAB"],
      maxLength: 6,
    },
  },
  {
    name: "Counting Tap",
    type: "counting_tap",
    description: "Tap objects to count them correctly.",
    difficulty: "easy",
    starsReward: 2,
    configuration: {
      maxNumber: 10,
      rounds: 5,
    },
  },
];

const seed = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      serverSelectionTimeoutMS: 15000,
    });
    console.log("MongoDB connected for seeding.");

    // Clear existing content
    await Subject.deleteMany({});
    await Lesson.deleteMany({});
    await QuizQuestion.deleteMany({});
    await Game.deleteMany({});
    console.log("Cleared existing content data.");

    // Seed subjects
    const createdSubjects = await Subject.insertMany(subjects);
    console.log(`Seeded ${createdSubjects.length} subjects.`);

    const subjectMap = {};
    createdSubjects.forEach((s) => {
      subjectMap[s.name] = s._id;
    });

    // Seed lessons
    const lessonDocs = lessons.map((l) => ({
      title: l.title,
      description: l.description,
      subjectId: subjectMap[l.subjectName],
      order: l.order,
      difficulty: l.difficulty,
      starsReward: l.starsReward,
      steps: l.steps,
    }));
    const createdLessons = await Lesson.insertMany(lessonDocs);
    console.log(`Seeded ${createdLessons.length} lessons.`);

    const lessonMap = {};
    createdLessons.forEach((l) => {
      lessonMap[l.title] = l._id;
    });

    // Seed quiz questions
    const quizDocs = quizQuestions.map((q) => ({
      lessonId: lessonMap[q.lessonTitle],
      question: q.question,
      type: q.type,
      options: q.options,
      correctAnswer: q.correctAnswer,
      explanation: q.explanation,
      order: q.order,
    }));
    const createdQuizzes = await QuizQuestion.insertMany(quizDocs);
    console.log(`Seeded ${createdQuizzes.length} quiz questions.`);

    // Seed games
    const createdGames = await Game.insertMany(games);
    console.log(`Seeded ${createdGames.length} games.`);

    console.log("Seeding complete!");
    process.exit(0);
  } catch (error) {
    console.error("Seeding failed:", error.message);
    process.exit(1);
  }
};

seed();
