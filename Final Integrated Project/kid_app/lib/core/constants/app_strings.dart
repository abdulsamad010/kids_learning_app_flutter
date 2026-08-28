class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'KidLearn';
  static const String appTagline = 'Learn, Play, Grow!';

  // Auth
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String emailHint = 'Enter your email';
  static const String passwordHint = 'Enter your password';
  static const String confirmPasswordHint = 'Confirm your password';
  static const String nameHint = 'Enter your name';
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created successfully';
  static const String logoutConfirm = 'Are you sure you want to logout?';

  // Validation
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String nameRequired = 'Name is required';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String pinRequired = 'PIN is required';
  static const String pinInvalid = 'PIN must be 4 digits';

  // Children
  static const String addChild = 'Add Child';
  static const String editChild = 'Edit Child';
  static const String childName = "Child's Name";
  static const String childAge = "Child's Age";
  static const String selectAvatar = 'Choose an Avatar';
  static const String childAdded = 'Child added successfully';
  static const String childUpdated = 'Child profile updated';
  static const String childDeleted = 'Child profile deleted';
  static const String deleteChildConfirm = 'Are you sure you want to delete this profile?';
  static const String switchProfile = 'Switch Profile';
  static const String noChildren = 'No child profiles yet';
  static const String noChildrenSubtitle = "Add your child's profile to get started";

  // Content
  static const String stories = 'Stories';
  static const String quizzes = 'Quizzes';
  static const String songs = 'Songs';
  static const String videos = 'Videos';
  static const String activities = 'Activities';
  static const String subjects = 'Subjects';
  static const String startQuiz = 'Start Quiz';
  static const String nextQuestion = 'Next';
  static const String submitAnswer = 'Submit';
  static const String quizComplete = 'Quiz Complete!';
  static const String score = 'Score';
  static const String tryAgain = 'Try Again';

  // Progress
  static const String progress = 'Progress';
  static const String overallProgress = 'Overall Progress';
  static const String completed = 'Completed';
  static const String inProgress = 'In Progress';
  static const String notStarted = 'Not Started';
  static const String daysStreak = 'Day Streak';
  static const String totalPoints = 'Total Points';
  static const String timeSpent = 'Time Spent';

  // Rewards
  static const String rewards = 'Rewards';
  static const String rewardStore = 'Reward Store';
  static const String points = 'Points';
  static const String redeem = 'Redeem';
  static const String rewardRedeemed = 'Reward redeemed!';
  static const String insufficientPoints = 'Not enough points';
  static const String noRewards = 'No rewards available yet';
  static const String noRewardsSubtitle = 'Complete activities to earn points and unlock rewards';

  // Common
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String somethingWentWrong = 'Something went wrong';
  static const String networkError = 'No internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String unauthorized = 'Session expired. Please login again';
  static const String notFound = 'Content not found';
  static const String emptyState = 'Nothing here yet';
  static const String pullToRefresh = 'Pull to refresh';
  static const String search = 'Search';
  static const String noResults = 'No results found';

  // Dashboard
  static const String parentDashboard = 'Parent Dashboard';
  static const String weeklyReport = 'Weekly Report';
  static const String learningTime = 'Learning Time';
  static const String subjectsCovered = 'Subjects Covered';
  static const String achievements = 'Achievements';

  // Onboarding
  static const String welcome = 'Welcome!';
  static const String welcomeSubtitle = "Let's start learning together";
  static const String getStarted = 'Get Started';
  static const String skip = 'Skip';

  // Days of week
  static const List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Subject names
  static const String math = 'Math';
  static const String science = 'Science';
  static const String reading = 'Reading';
  static const String art = 'Art';
  static const String music = 'Music';
  static const String general = 'General';
}
