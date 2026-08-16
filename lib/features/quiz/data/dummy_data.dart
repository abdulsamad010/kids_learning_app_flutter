class DummyData {
  static final List<Map<String, dynamic>> subjects = [
    {
      'subjectId': 1,
      'name': 'English',
    },
    {
      'subjectId': 2,
      'name': 'Mathematics',
    },
    {
      'subjectId': 3,
      'name': 'Science',
    },
    {
      'subjectId': 4,
      'name': 'General Knowledge',
    },
  ];

  static final Map<int, List<Map<String, dynamic>>> lessons = {
    1: [
      {
        'lessonId': 101,
        'subjectId': 1,
        'title': 'Parts of Speech',
        'description':
        'Learn about nouns, verbs, adjectives and other parts of speech.',
      },
      {
        'lessonId': 102,
        'subjectId': 1,
        'title': 'Basic Grammar',
        'description':
        'Learn simple grammar rules and how to build sentences.',
      },
    ],
    2: [
      {
        'lessonId': 201,
        'subjectId': 2,
        'title': 'Addition',
        'description':
        'Learn how to add numbers and solve simple problems.',
      },
      {
        'lessonId': 202,
        'subjectId': 2,
        'title': 'Subtraction',
        'description':
        'Learn how to subtract numbers and solve simple problems.',
      },
    ],
    3: [
      {
        'lessonId': 301,
        'subjectId': 3,
        'title': 'Solar System',
        'description':
        'Explore the Sun, planets and our amazing solar system.',
      },
      {
        'lessonId': 302,
        'subjectId': 3,
        'title': 'Living Things',
        'description':
        'Learn how to identify living and non-living things.',
      },
    ],
    4: [
      {
        'lessonId': 401,
        'subjectId': 4,
        'title': 'Animals',
        'description':
        'Discover interesting facts about different animals.',
      },
      {
        'lessonId': 402,
        'subjectId': 4,
        'title': 'Our World',
        'description':
        'Learn about countries, places and our wonderful world.',
      },
    ],
  };

  static final Map<int, List<Map<String, dynamic>>> lessonSteps = {
    101: _steps(
      101,
      1,
      'Parts of Speech',
      'Learn how words work in sentences.',
    ),
    102: _steps(
      102,
      1,
      'Basic Grammar',
      'Learn simple rules for building sentences.',
    ),
    201: _steps(
      201,
      2,
      'Addition',
      'Learn how to put numbers together.',
    ),
    202: _steps(
      202,
      2,
      'Subtraction',
      'Learn how to take numbers away.',
    ),
    301: _steps(
      301,
      3,
      'Solar System',
      'Explore the Sun and the planets.',
    ),
    302: _steps(
      302,
      3,
      'Living Things',
      'Learn about plants, animals and living things.',
    ),
    401: _steps(
      401,
      4,
      'Animals',
      'Learn about different kinds of animals.',
    ),
    402: _steps(
      402,
      4,
      'Our World',
      'Explore countries, places and our planet.',
    ),
  };

  static List<Map<String, dynamic>> _steps(
      int lessonId,
      int subjectId,
      String title,
      String description,
      ) {
    return [
      {
        'lessonStepId': lessonId * 10 + 1,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'content',
        'title': 'Welcome to $title',
        'content':
        'Welcome! In this lesson you will learn about $description',
      },
      {
        'lessonStepId': lessonId * 10 + 2,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'content',
        'title': 'Learn the Basics',
        'content':
        'Let us explore the important ideas of $title step by step.',
      },
      {
        'lessonStepId': lessonId * 10 + 3,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'content',
        'title': 'Easy Examples',
        'content':
        'Look at these simple examples and think about what you have learned.',
      },
      {
        'lessonStepId': lessonId * 10 + 4,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'content',
        'title': 'Practice Time',
        'content':
        'Take a moment to remember the important points from this lesson.',
      },
      {
        'lessonStepId': lessonId * 10 + 5,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'quiz',
        'title': 'Ready for a Quiz?',
        'content':
        'Great work! Now choose a quiz and test what you have learned.',
      },
      {
        'lessonStepId': lessonId * 10 + 6,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'report',
        'title': 'Your Learning Report',
        'content':
        'Here you can see how well you performed in your quiz.',
      },
      {
        'lessonStepId': lessonId * 10 + 7,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'completion',
        'title': 'Lesson Complete!',
        'content':
        'Fantastic work! Check your result and see your learning progress.',
      },
      {
        'lessonStepId': lessonId * 10 + 8,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'type': 'reward',
        'title': 'Great Job!',
        'content':
        'Keep learning, keep practicing and keep growing!',
      },
    ];
  }

  static final Map<int, List<Map<String, dynamic>>> quizzes = {
    101: _quizzes(101, 1),
    102: _quizzes(102, 1),
    201: _quizzes(201, 2),
    202: _quizzes(202, 2),
    301: _quizzes(301, 3),
    302: _quizzes(302, 3),
    401: _quizzes(401, 4),
    402: _quizzes(402, 4),
  };

  static List<Map<String, dynamic>> _quizzes(
      int lessonId,
      int subjectId,
      ) {
    final multipleChoiceQuizId = lessonId * 10 + 1;
    final trueFalseQuizId = lessonId * 10 + 2;
    final matchingQuizId = lessonId * 10 + 3;

    return [
      {
        'quizId': multipleChoiceQuizId,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'title': 'Multiple Choice Quiz',
        'type': 'multiple_choice',
      },
      {
        'quizId': trueFalseQuizId,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'title': 'True or False Quiz',
        'type': 'true_false',
      },
      {
        'quizId': matchingQuizId,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'title': 'Matching Quiz',
        'type': 'matching',
      },
    ];
  }

  static final Map<int, List<Map<String, dynamic>>> questions = {
    1011: _multipleChoiceQuestions(
      101,
      1,
      [
        'Which word is a noun?',
        'Which word is a verb?',
        'Which word is an adjective?',
        'Which word names a place?',
        'Which word describes something?',
      ],
    ),
    1012: _trueFalseQuestions(
      101,
      1,
      [
        'A noun can name a person, place, animal or thing.',
        'A verb can describe an action.',
        'The word "run" can be a verb.',
        'An adjective can describe a noun.',
        'Every word in a sentence is a noun.',
      ],
    ),
    1013: _matchingQuestions(
      101,
      1,
      [
        'Match "teacher" with its category.',
        'Match "run" with its category.',
        'Match "beautiful" with its category.',
        'Match "school" with its category.',
        'Match "jump" with its category.',
      ],
    ),

    1021: _multipleChoiceQuestions(
      102,
      1,
      [
        'Which sentence is correct?',
        'Which word should start a sentence with a capital letter?',
        'Which punctuation mark ends a question?',
        'Which sentence uses a full stop correctly?',
        'Which word is spelled correctly?',
      ],
    ),
    1022: _trueFalseQuestions(
      102,
      1,
      [
        'A sentence should begin with a capital letter.',
        'A question can end with a question mark.',
        'A full stop can end a normal sentence.',
        'All sentences must contain exactly two words.',
        'Grammar helps us write clearly.',
      ],
    ),
    1023: _matchingQuestions(
      102,
      1,
      [
        'Match "?" with its use.',
        'Match "." with its use.',
        'Match "!" with its use.',
        'Match a capital letter with its use.',
        'Match a sentence with its ending mark.',
      ],
    ),

    2011: _multipleChoiceQuestions(
      201,
      2,
      [
        'What is 2 + 3?',
        'What is 5 + 4?',
        'What is 7 + 2?',
        'What is 6 + 3?',
        'What is 4 + 5?',
      ],
    ),
    2012: _trueFalseQuestions(
      201,
      2,
      [
        '2 + 2 = 4.',
        '3 + 5 = 7.',
        'Adding means putting numbers together.',
        '5 + 1 = 6.',
        '10 + 2 = 15.',
      ],
    ),
    2013: _matchingQuestions(
      201,
      2,
      [
        'Match 2 + 2 with its answer.',
        'Match 3 + 4 with its answer.',
        'Match 5 + 2 with its answer.',
        'Match 6 + 1 with its answer.',
        'Match 4 + 4 with its answer.',
      ],
    ),

    2021: _multipleChoiceQuestions(
      202,
      2,
      [
        'What is 5 - 2?',
        'What is 9 - 4?',
        'What is 8 - 3?',
        'What is 7 - 2?',
        'What is 10 - 6?',
      ],
    ),
    2022: _trueFalseQuestions(
      202,
      2,
      [
        '5 - 2 = 3.',
        '9 - 4 = 6.',
        'Subtraction means taking away.',
        '8 - 3 = 5.',
        '10 - 5 = 5.',
      ],
    ),
    2023: _matchingQuestions(
      202,
      2,
      [
        'Match 5 - 2 with its answer.',
        'Match 8 - 3 with its answer.',
        'Match 7 - 4 with its answer.',
        'Match 9 - 5 with its answer.',
        'Match 6 - 2 with its answer.',
      ],
    ),

    3011: _multipleChoiceQuestions(
      301,
      3,
      [
        'Which planet is closest to the Sun?',
        'Which planet do we live on?',
        'Which object gives Earth light?',
        'Which planet is known for its rings?',
        'What is the Sun?',
      ],
    ),
    3012: _trueFalseQuestions(
      301,
      3,
      [
        'Earth is a planet.',
        'The Sun is a star.',
        'The Moon is bigger than the Sun.',
        'Mars is a planet.',
        'The solar system contains planets.',
      ],
    ),
    3013: _matchingQuestions(
      301,
      3,
      [
        'Match Earth with its category.',
        'Match the Sun with its category.',
        'Match Mars with its category.',
        'Match the Moon with its category.',
        'Match Jupiter with its category.',
      ],
    ),

    3021: _multipleChoiceQuestions(
      302,
      3,
      [
        'Which is a living thing?',
        'Which needs food to live?',
        'Which can grow?',
        'Which can reproduce?',
        'Which is not living?',
      ],
    ),
    3022: _trueFalseQuestions(
      302,
      3,
      [
        'Plants are living things.',
        'Animals are living things.',
        'A rock is a living thing.',
        'Living things can grow.',
        'Living things need nothing to survive.',
      ],
    ),
    3023: _matchingQuestions(
      302,
      3,
      [
        'Match a cat with its category.',
        'Match a tree with its category.',
        'Match a rock with its category.',
        'Match a bird with its category.',
        'Match a flower with its category.',
      ],
    ),

    4011: _multipleChoiceQuestions(
      401,
      4,
      [
        'Which animal says "meow"?',
        'Which animal is known as the king of the jungle?',
        'Which animal can fly?',
        'Which animal lives in water?',
        'Which animal gives us milk?',
      ],
    ),
    4012: _trueFalseQuestions(
      401,
      4,
      [
        'A cat is an animal.',
        'A fish can live in water.',
        'Birds cannot fly.',
        'A cow can give us milk.',
        'An elephant is smaller than a mouse.',
      ],
    ),
    4013: _matchingQuestions(
      401,
      4,
      [
        'Match cat with its sound.',
        'Match cow with its sound.',
        'Match dog with its sound.',
        'Match lion with its sound.',
        'Match duck with its sound.',
      ],
    ),

    4021: _multipleChoiceQuestions(
      402,
      4,
      [
        'Which planet do we live on?',
        'Which is a continent?',
        'Which is an ocean?',
        'Which is a country?',
        'What is Earth?',
      ],
    ),
    4022: _trueFalseQuestions(
      402,
      4,
      [
        'Earth is our home planet.',
        'Pakistan is a country.',
        'Asia is a continent.',
        'The Pacific Ocean is an ocean.',
        'The Moon is a country.',
      ],
    ),
    4023: _matchingQuestions(
      402,
      4,
      [
        'Match Pakistan with its category.',
        'Match Asia with its category.',
        'Match Pacific Ocean with its category.',
        'Match Earth with its category.',
        'Match Islamabad with its category.',
      ],
    ),
  };

  static List<Map<String, dynamic>> _multipleChoiceQuestions(
      int lessonId,
      int subjectId,
      List<String> questionTexts,
      ) {
    final quizId = lessonId * 10 + 1;

    return List.generate(
      questionTexts.length,
          (index) {
        final questionId = quizId * 100 + index + 1;

        return {
          'questionId': questionId,
          'quizId': quizId,
          'lessonId': lessonId,
          'subjectId': subjectId,
          'questionText': questionTexts[index],
          'type': 'multiple_choice',
        };
      },
    );
  }

  static List<Map<String, dynamic>> _trueFalseQuestions(
      int lessonId,
      int subjectId,
      List<String> questionTexts,
      ) {
    final quizId = lessonId * 10 + 2;

    return List.generate(
      questionTexts.length,
          (index) {
        final questionId = quizId * 100 + index + 1;

        return {
          'questionId': questionId,
          'quizId': quizId,
          'lessonId': lessonId,
          'subjectId': subjectId,
          'questionText': questionTexts[index],
          'type': 'true_false',
        };
      },
    );
  }

  static List<Map<String, dynamic>> _matchingQuestions(
      int lessonId,
      int subjectId,
      List<String> questionTexts,
      ) {
    final quizId = lessonId * 10 + 3;

    return List.generate(
      questionTexts.length,
          (index) {
        final questionId = quizId * 100 + index + 1;

        return {
          'questionId': questionId,
          'quizId': quizId,
          'lessonId': lessonId,
          'subjectId': subjectId,
          'questionText': questionTexts[index],
          'type': 'matching',
        };
      },
    );
  }

  static final Map<int, List<Map<String, dynamic>>> answers =
  _buildAllAnswers();

  static Map<int, List<Map<String, dynamic>>> _buildAllAnswers() {
    final result = <int, List<Map<String, dynamic>>>{};

    for (final lessonId in [
      101,
      102,
      201,
      202,
      301,
      302,
      401,
      402,
    ]) {
      final subjectId = _getSubjectId(lessonId);

      final multipleChoiceQuizId = lessonId * 10 + 1;
      final trueFalseQuizId = lessonId * 10 + 2;
      final matchingQuizId = lessonId * 10 + 3;

      final multipleChoiceQuestions =
          questions[multipleChoiceQuizId] ?? [];

      final trueFalseQuestions =
          questions[trueFalseQuizId] ?? [];

      final matchingQuestions =
          questions[matchingQuizId] ?? [];

      for (int i = 0;
      i < multipleChoiceQuestions.length;
      i++) {
        final question =
        multipleChoiceQuestions[i];

        result[question['questionId']] =
            _multipleChoiceAnswers(
              question['questionId'],
              multipleChoiceQuizId,
              lessonId,
              subjectId,
              _getMultipleChoiceOptions(
                lessonId,
                i,
              ),
            );
      }

      for (int i = 0;
      i < trueFalseQuestions.length;
      i++) {
        final question = trueFalseQuestions[i];

        final correctAnswer =
        _getTrueFalseAnswer(
          lessonId,
          i,
        );

        result[question['questionId']] =
            _trueFalseAnswers(
              question['questionId'],
              trueFalseQuizId,
              lessonId,
              subjectId,
              correctAnswer,
            );
      }

      for (int i = 0;
      i < matchingQuestions.length;
      i++) {
        final question = matchingQuestions[i];

        result[question['questionId']] =
            _matchingAnswers(
              question['questionId'],
              matchingQuizId,
              lessonId,
              subjectId,
              _getMatchingOptions(
                lessonId,
                i,
              ),
            );
      }
    }

    return result;
  }

  static List<String> _getMultipleChoiceOptions(
      int lessonId,
      int index,
      ) {
    final options = <int, List<List<String>>>{
      101: [
        ['Teacher', 'Run', 'Quickly', 'Beautiful'],
        ['Run', 'Book', 'School', 'Blue'],
        ['Beautiful', 'Jump', 'Teacher', 'School'],
        ['School', 'Run', 'Happy', 'Quickly'],
        ['Happy', 'Run', 'Book', 'Teacher'],
      ],
      102: [
        ['I like apples.', 'i like apples', 'I like apples', 'i Like Apples.'],
        ['Apple', 'apple', 'APPLE', 'All of these'],
        ['?', '.', ',', ':'],
        ['I am happy.', 'I am happy?', 'I am happy,', 'I am happy!'],
        ['Beautiful', 'Beautifull', 'Beutiful', 'Beautifol'],
      ],
      201: [
        ['5', '4', '6', '3'],
        ['9', '8', '10', '7'],
        ['9', '8', '10', '11'],
        ['9', '8', '7', '10'],
        ['9', '8', '10', '7'],
      ],
      202: [
        ['3', '2', '4', '1'],
        ['5', '4', '6', '3'],
        ['5', '4', '6', '3'],
        ['5', '3', '4', '6'],
        ['4', '3', '5', '6'],
      ],
      301: [
        ['Mercury', 'Earth', 'Mars', 'Jupiter'],
        ['Earth', 'Mars', 'Venus', 'Saturn'],
        ['Sun', 'Moon', 'Earth', 'Mars'],
        ['Saturn', 'Mars', 'Earth', 'Venus'],
        ['Star', 'Planet', 'Moon', 'Comet'],
      ],
      302: [
        ['Cat', 'Rock', 'Chair', 'Ball'],
        ['Plant', 'Rock', 'Table', 'Book'],
        ['Plant', 'Rock', 'Cup', 'Chair'],
        ['Rabbit', 'Rock', 'Ball', 'Book'],
        ['Rock', 'Tree', 'Cat', 'Car'],
      ],
      401: [
        ['Cat', 'Dog', 'Cow', 'Horse'],
        ['Lion', 'Tiger', 'Elephant', 'Horse'],
        ['Eagle', 'Fish', 'Cow', 'Elephant'],
        ['Fish', 'Cat', 'Dog', 'Horse'],
        ['Cow', 'Lion', 'Cat', 'Dog'],
      ],
      402: [
        ['Earth', 'Mars', 'Venus', 'Jupiter'],
        ['Asia', 'Atlantic', 'Pakistan', 'Islamabad'],
        ['Pacific Ocean', 'Asia', 'Pakistan', 'Africa'],
        ['Pakistan', 'Asia', 'Earth', 'Pacific Ocean'],
        ['Planet', 'Country', 'Continent', 'Ocean'],
      ],
    };

    return options[lessonId]![index];
  }

  static List<Map<String, dynamic>> _multipleChoiceAnswers(
      int questionId,
      int quizId,
      int lessonId,
      int subjectId,
      List<String> texts,
      ) {
    return List.generate(
      texts.length,
          (index) {
        return {
          'answerId': questionId * 10 + index + 1,
          'questionId': questionId,
          'quizId': quizId,
          'lessonId': lessonId,
          'subjectId': subjectId,
          'answerText': texts[index],
          'isCorrect': index == 0,
        };
      },
    );
  }

  static String _getTrueFalseAnswer(
      int lessonId,
      int index,
      ) {
    final answers = <int, List<String>>{
      101: [
        'True',
        'True',
        'True',
        'True',
        'False',
      ],
      102: [
        'True',
        'True',
        'True',
        'False',
        'True',
      ],
      201: [
        'True',
        'False',
        'True',
        'True',
        'False',
      ],
      202: [
        'True',
        'False',
        'True',
        'True',
        'True',
      ],
      301: [
        'True',
        'True',
        'False',
        'True',
        'True',
      ],
      302: [
        'True',
        'True',
        'False',
        'True',
        'False',
      ],
      401: [
        'True',
        'True',
        'False',
        'True',
        'False',
      ],
      402: [
        'True',
        'True',
        'True',
        'True',
        'False',
      ],
    };

    return answers[lessonId]![index];
  }

  static List<Map<String, dynamic>> _trueFalseAnswers(
      int questionId,
      int quizId,
      int lessonId,
      int subjectId,
      String correctAnswer,
      ) {
    return [
      {
        'answerId': questionId * 10 + 1,
        'questionId': questionId,
        'quizId': quizId,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'answerText': 'True',
        'isCorrect': correctAnswer == 'True',
      },
      {
        'answerId': questionId * 10 + 2,
        'questionId': questionId,
        'quizId': quizId,
        'lessonId': lessonId,
        'subjectId': subjectId,
        'answerText': 'False',
        'isCorrect': correctAnswer == 'False',
      },
    ];
  }

  static List<String> _getMatchingOptions(
      int lessonId,
      int index,
      ) {
    final options = <int, List<List<String>>>{
      101: [
        ['Person', 'Action', 'Description', 'Place'],
        ['Action', 'Person', 'Place', 'Description'],
        ['Adjective', 'Verb', 'Noun', 'Place'],
        ['Place', 'Person', 'Action', 'Description'],
        ['Action', 'Place', 'Person', 'Adjective'],
      ],
      102: [
        ['Question mark', 'Full stop', 'Comma', 'Colon'],
        ['Full stop', 'Question mark', 'Comma', 'Exclamation mark'],
        ['Exclamation mark', 'Full stop', 'Question mark', 'Comma'],
        ['Sentence beginning', 'Sentence ending', 'Question', 'Comma'],
        ['Full stop', 'Comma', 'Question mark', 'Colon'],
      ],
      201: [
        ['4', '5', '3', '6'],
        ['7', '6', '8', '5'],
        ['7', '6', '8', '9'],
        ['7', '6', '8', '5'],
        ['8', '7', '9', '6'],
      ],
      202: [
        ['3', '2', '4', '5'],
        ['5', '4', '6', '3'],
        ['3', '4', '5', '6'],
        ['4', '3', '5', '6'],
        ['4', '3', '5', '6'],
      ],
      301: [
        ['Planet', 'Star', 'Moon', 'Comet'],
        ['Star', 'Planet', 'Moon', 'Comet'],
        ['Planet', 'Moon', 'Star', 'Comet'],
        ['Moon', 'Planet', 'Star', 'Comet'],
        ['Planet', 'Star', 'Moon', 'Comet'],
      ],
      302: [
        ['Living thing', 'Non-living thing', 'Plant', 'Object'],
        ['Plant', 'Animal', 'Object', 'Non-living thing'],
        ['Non-living thing', 'Plant', 'Animal', 'Object'],
        ['Animal', 'Plant', 'Object', 'Non-living thing'],
        ['Plant', 'Animal', 'Object', 'Non-living thing'],
      ],
      401: [
        ['Meow', 'Woof', 'Moo', 'Roar'],
        ['Moo', 'Woof', 'Meow', 'Quack'],
        ['Woof', 'Meow', 'Moo', 'Roar'],
        ['Roar', 'Moo', 'Woof', 'Meow'],
        ['Quack', 'Moo', 'Woof', 'Roar'],
      ],
      402: [
        ['Country', 'Continent', 'Ocean', 'Planet'],
        ['Continent', 'Country', 'Ocean', 'Planet'],
        ['Ocean', 'Country', 'Continent', 'Planet'],
        ['Planet', 'Country', 'Continent', 'Ocean'],
        ['City', 'Country', 'Continent', 'Planet'],
      ],
    };

    return options[lessonId]![index];
  }

  static List<Map<String, dynamic>> _matchingAnswers(
      int questionId,
      int quizId,
      int lessonId,
      int subjectId,
      List<String> texts,
      ) {
    return List.generate(
      texts.length,
          (index) {
        return {
          'answerId': questionId * 10 + index + 1,
          'questionId': questionId,
          'quizId': quizId,
          'lessonId': lessonId,
          'subjectId': subjectId,
          'answerText': texts[index],
          'isCorrect': index == 0,
        };
      },
    );
  }

  static int _getSubjectId(int lessonId) {
    if (lessonId >= 100 && lessonId < 200) {
      return 1;
    }

    if (lessonId >= 200 && lessonId < 300) {
      return 2;
    }

    if (lessonId >= 300 && lessonId < 400) {
      return 3;
    }

    return 4;
  }

  static final Map<String, dynamic> quizProgress = {
    'completedQuizTypes': <String>[],
    'completedQuizzes': 0,
    'totalQuizzes': 3,
    'score': 0,
    'completedQuizId': null,
    'completedQuizType': null,
    'completedLessonId': null,
    'completedLessons': <String, dynamic>{},
  };

  static final Map<String, dynamic> userProgress = {
    'currentLevel': 1,
    'score': 0,
    'completedQuizzes': 0,
    'totalQuizzes': 0,
    'progressPercentage': 0,
    'status': 'Start Learning',
    'lastQuizResult': <String, dynamic>{},
    'lastLessonProgress': <String, dynamic>{},
  };
}