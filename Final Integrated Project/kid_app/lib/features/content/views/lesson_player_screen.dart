import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/content/viewmodels/content_viewmodel.dart';
import 'package:kid_app/features/content/models/lesson_model.dart';
import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/common/widgets/loading_widget.dart';
import 'package:kid_app/core/common/widgets/error_display.dart';
import 'package:kid_app/core/common/widgets/empty_state.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';
import 'package:kid_app/features/quiz/viewmodels/quiz_viewmodel.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with TickerProviderStateMixin {
  int _currentStepIndex = 0;
  String? _lessonId;
  int _quizScore = 0;
  bool _quizCompleted = false;
  bool _lessonCompleted = false;
  int _earnedStars = 0;

  late AnimationController _starAnimationController;
  late Animation<double> _starScaleAnimation;

  @override
  void initState() {
    super.initState();
    _starAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _starScaleAnimation = CurvedAnimation(
      parent: _starAnimationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _starAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_lessonId == null) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is String) {
        _lessonId = args;
      } else if (args is LessonModel) {
        _lessonId = args.id;
      } else if (args is Map<String, dynamic>) {
        _lessonId = args['id'] as String?;
      }
      if (_lessonId != null) {
        _loadLesson();
      }
    }
  }

  void _loadLesson() {
    final contentVm = context.read<ContentViewmodel>();
    contentVm.loadLesson(_lessonId!);
  }

  LessonModel? get _lesson => context.read<ContentViewmodel>().currentLesson;

  List<LessonStep> get _steps => _lesson?.steps ?? [];

  int get _totalSteps => _steps.length;

  LessonStep? get _currentStep =>
      _currentStepIndex < _steps.length ? _steps[_currentStepIndex] : null;

  double get _progress =>
      _totalSteps > 0 ? (_currentStepIndex + 1) / _totalSteps : 0;

  void _nextStep() {
    if (_currentStepIndex < _totalSteps - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  int _quizTotalQuestions = 0;

  int _calculateStars() {
    if (!_quizCompleted || _quizTotalQuestions == 0) return 0;
    final percentage = (_quizScore / _quizTotalQuestions) * 100;
    if (percentage >= 90) return 3;
    if (percentage >= 70) return 2;
    if (percentage >= 50) return 1;
    return 0;
  }

  Future<void> _completeLesson() async {
    if (_lessonCompleted) return;
    _lessonCompleted = true;
    _earnedStars = _calculateStars();

    final childVm = context.read<ChildViewModel>();
    final progressVm = context.read<ProgressViewmodel>();
    final childId = childVm.selectedChild?.id;
    if (childId == null || _lessonId == null) return;

    await progressVm.submitLesson(
      childId: childId,
      lessonId: _lessonId!,
      stars: _earnedStars,
    );
  }

  void _finish() {
    Navigator.of(context).pop(true);
  }

  Future<void> _navigateToQuiz() async {
    final childId = context.read<ChildViewModel>().selectedChild?.id;
    if (childId == null || _lessonId == null) return;

    await Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {
        'lessonId': _lessonId,
        'childId': childId,
      },
    );

    if (!mounted) return;

    final quiz = context.read<QuizViewmodel>();
    if (quiz.isCompleted) {
      _quizScore = quiz.score;
      _quizTotalQuestions = quiz.totalQuestions;
      _quizCompleted = true;
      quiz.resetQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentVm = context.watch<ContentViewmodel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _lesson?.title ?? 'Lesson',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Step ${_currentStepIndex + 1} of $_totalSteps',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.primary,
            ),
          ),
        ),
      ),
      body: _buildBody(contentVm),
    );
  }

  Widget _buildBody(ContentViewmodel contentVm) {
    if (contentVm.isLoading) {
      return const LoadingWidget(message: 'Preparing your lesson...');
    }

    if (contentVm.errorMessage != null) {
      return ErrorDisplay(
        message: contentVm.errorMessage!,
        onRetry: _loadLesson,
      );
    }

    if (_lesson == null || _currentStep == null) {
      return const EmptyState(
        icon: Icons.school_rounded,
        title: 'Lesson not found',
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildStepContent(_currentStep!),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildStepContent(LessonStep step) {
    switch (step.type) {
      case 'introduction':
        return _buildIntroductionStep(step);
      case 'explanation':
        return _buildExplanationStep(step);
      case 'example':
        return _buildExampleStep(step);
      case 'interactive_activity':
        return _buildInteractiveStep(step);
      case 'practice':
        return _buildPracticeStep(step);
      case 'short_assessment':
        return _buildAssessmentStep(step);
      case 'completion':
        return _buildCompletionStep(step);
      case 'reward':
        return _buildRewardStep(step);
      default:
        return _buildGenericStep(step);
    }
  }

  Widget _buildIntroductionStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_circle_filled_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          step.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildExampleStep(LessonStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accentColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.zoom_in_rounded,
                color: AppTheme.accentColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          step.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildInteractiveStep(LessonStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.successColor.withValues(alpha:0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.touch_app_rounded,
                color: AppTheme.successColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          step.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildPracticeStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha:0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: colorScheme.secondary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          step.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildAssessmentStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha:0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz_rounded,
              size: 64,
              color: AppTheme.accentColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
          if (_quizCompleted) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
            color: AppTheme.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.successColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Quiz completed! Score: $_quizScore',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletionStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha:0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration_rounded,
              size: 72,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _starAnimationController.forward(from: 0);
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _starScaleAnimation,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentColor.withValues(alpha:0.2),
                    AppTheme.warningColor.withValues(alpha:0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _earnedStars,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(
                          Icons.star_rounded,
                          size: 32,
                          color: AppTheme.warningColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_earnedStars ${_earnedStars == 1 ? 'Star' : 'Stars'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.warningColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGenericStep(LessonStep step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          step.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final step = _currentStep;
    if (step == null) return const SizedBox.shrink();

    final isLastStep = _currentStepIndex == _totalSteps - 1;
    final contentVm = context.read<ContentViewmodel>();
    final isLoading = contentVm.isLoading;

    String buttonText;
    VoidCallback? onPressed;

    switch (step.type) {
      case 'introduction':
        buttonText = 'Start';
        onPressed = _nextStep;
        break;
      case 'explanation':
        buttonText = 'Got it';
        onPressed = _nextStep;
        break;
      case 'example':
        buttonText = 'Understood';
        onPressed = _nextStep;
        break;
      case 'interactive_activity':
        buttonText = 'Done';
        onPressed = _nextStep;
        break;
      case 'practice':
        buttonText = 'Practiced';
        onPressed = _nextStep;
        break;
      case 'short_assessment':
        if (_quizCompleted) {
          buttonText = 'Continue';
          onPressed = _nextStep;
        } else {
          buttonText = 'Start Quiz';
          onPressed = _navigateToQuiz;
        }
        break;
      case 'completion':
        buttonText = 'Continue';
        onPressed = _nextStep;
        break;
      case 'reward':
        buttonText = 'Finish';
        onPressed = () async {
          await _completeLesson();
          _finish();
        };
        break;
      default:
        if (isLastStep) {
          buttonText = 'Finish';
          onPressed = () async {
            await _completeLesson();
            _finish();
          };
        } else {
          buttonText = 'Next';
          onPressed = _nextStep;
        }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          text: buttonText,
          onPressed: onPressed,
          isLoading: isLoading,
          width: double.infinity,
        ),
      ),
    );
  }
}
