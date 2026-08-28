import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/answer.dart';

class TrueFalse extends StatefulWidget {
  final Question question;
  final List<Answer> answers;
  final Function(Answer) onAnswerSelected;

  const TrueFalse({
    super.key,
    required this.question,
    required this.answers,
    required this.onAnswerSelected,
  });

  @override
  State<TrueFalse> createState() => _TrueFalseState();
}

class _TrueFalseState extends State<TrueFalse>
    with SingleTickerProviderStateMixin {
  int? selectedAnswerId;

  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Answer? getAnswer(String value) {
    for (final answer in widget.answers) {
      if (answer.answerText.trim().toLowerCase() == value) {
        return answer;
      }
    }

    return null;
  }

  void selectAnswer(Answer answer) {
    setState(() {
      selectedAnswerId = answer.answerId;
    });

    animationController.forward().then((_) {
      if (mounted) {
        animationController.reverse();
      }
    });

    widget.onAnswerSelected(answer);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final trueAnswer = getAnswer('true');
    final falseAnswer = getAnswer('false');

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.rule_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'True or False?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(
                      alpha: 0.06,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(
                      begin: 0.75,
                      end: 1.0,
                    ),
                    curve: Curves.easeOutBack,
                    builder: (
                        context,
                        value,
                        child,
                        ) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_rounded,
                        size: 38,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.question.questionText,
                    textAlign: TextAlign.center,
                    style:
                    theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'What do you think?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (trueAnswer == null && falseAnswer == null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No answers available',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool useVerticalLayout =
                      constraints.maxWidth < 500;

                  if (useVerticalLayout) {
                    return Column(
                      children: [
                        if (trueAnswer != null)
                          buildAnswerButton(
                            answer: trueAnswer,
                            text: 'True',
                            icon: Icons.check_rounded,
                            index: 0,
                          ),
                        if (trueAnswer != null &&
                            falseAnswer != null)
                          const SizedBox(height: 14),
                        if (falseAnswer != null)
                          buildAnswerButton(
                            answer: falseAnswer,
                            text: 'False',
                            icon: Icons.close_rounded,
                            index: 1,
                          ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      if (trueAnswer != null)
                        Expanded(
                          child: buildAnswerButton(
                            answer: trueAnswer,
                            text: 'True',
                            icon: Icons.check_rounded,
                            index: 0,
                          ),
                        ),
                      if (trueAnswer != null &&
                          falseAnswer != null)
                        const SizedBox(width: 14),
                      if (falseAnswer != null)
                        Expanded(
                          child: buildAnswerButton(
                            answer: falseAnswer,
                            text: 'False',
                            icon: Icons.close_rounded,
                            index: 1,
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAnswerButton({
    required Answer answer,
    required String text,
    required IconData icon,
    required int index,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isSelected =
        selectedAnswerId == answer.answerId;

    return TweenAnimationBuilder<double>(
      duration: Duration(
        milliseconds: 300 + (index * 100),
      ),
      tween: Tween(
        begin: 0.85,
        end: 1.0,
      ),
      curve: Curves.easeOutBack,
      builder: (
          context,
          scale,
          child,
          ) {
        return Transform.scale(
          scale: isSelected
              ? scaleAnimation.value
              : scale,
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => selectAnswer(answer),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(
                    alpha: isSelected ? 0.14 : 0.05,
                  ),
                  blurRadius: isSelected ? 10 : 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  text,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? Icon(
                    Icons.check_circle_rounded,
                    key: const ValueKey('selected'),
                    color: colorScheme.primary,
                    size: 25,
                  )
                      : Icon(
                    Icons.touch_app_rounded,
                    key: const ValueKey('unselected'),
                    color: colorScheme.outline,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}