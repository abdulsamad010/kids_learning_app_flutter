import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/answer.dart';

class Matching extends StatefulWidget {
  final Question question;
  final List<Answer> answers;
  final Function(Answer) onAnswerSelected;

  const Matching({
    super.key,
    required this.question,
    required this.answers,
    required this.onAnswerSelected,
  });

  @override
  State<Matching> createState() => _MatchingState();
}

class _MatchingState extends State<Matching>
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
                    Icons.compare_arrows_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Match the Answer',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Choose the answer that matches the question.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            if (widget.answers.isEmpty)
              buildEmptyState(
                theme,
                colorScheme,
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool useVerticalLayout =
                      constraints.maxWidth < 650;

                  if (useVerticalLayout) {
                    return buildVerticalLayout(
                      theme,
                      colorScheme,
                    );
                  }

                  return buildHorizontalLayout(
                    theme,
                    colorScheme,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalLayout(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: buildQuestionCard(
                theme,
                colorScheme,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: TweenAnimationBuilder<double>(
                duration:
                const Duration(milliseconds: 700),
                tween: Tween(
                  begin: 0.0,
                  end: 1.0,
                ),
                curve: Curves.easeInOut,
                builder: (
                    context,
                    value,
                    child,
                    ) {
                  return Transform.translate(
                    offset: Offset(
                      5 * value,
                      0,
                    ),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
            ),

            Expanded(
              child: buildAnswersList(
                theme,
                colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildVerticalLayout(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Column(
      children: [
        buildQuestionCard(
          theme,
          colorScheme,
        ),

        const SizedBox(height: 14),

        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(
            begin: 0.0,
            end: 1.0,
          ),
          curve: Curves.easeOut,
          builder: (
              context,
              value,
              child,
              ) {
            return Transform.translate(
              offset: Offset(
                0,
                8 * (1 - value),
              ),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Icon(
            Icons.arrow_downward_rounded,
            size: 30,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(height: 14),

        buildAnswersList(
          theme,
          colorScheme,
        ),
      ],
    );
  }

  Widget buildQuestionCard(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      tween: Tween(
        begin: 0.9,
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
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: 0.10,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_rounded,
                size: 38,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Question',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.question.questionText,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnswersList(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Column(
      children: List.generate(
        widget.answers.length,
            (index) {
          final answer = widget.answers[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom:
              index == widget.answers.length - 1
                  ? 0
                  : 12,
            ),
            child: buildAnswerCard(
              theme,
              colorScheme,
              answer,
              index,
            ),
          );
        },
      ),
    );
  }

  Widget buildAnswerCard(
      ThemeData theme,
      ColorScheme colorScheme,
      Answer answer,
      int index,
      ) {
    final bool isSelected =
        selectedAnswerId == answer.answerId;

    return TweenAnimationBuilder<double>(
      duration: Duration(
        milliseconds: 300 + (index * 80),
      ),
      tween: Tween(
        begin: 0.0,
        end: 1.0,
      ),
      curve: Curves.easeOut,
      builder: (
          context,
          value,
          child,
          ) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              15 * (1 - value),
              0,
            ),
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (
            context,
            child,
            ) {
          return Transform.scale(
            scale: isSelected
                ? scaleAnimation.value
                : 1.0,
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => selectAnswer(answer),
            child: AnimatedContainer(
              duration:
              const Duration(milliseconds: 220),
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(
                      alpha: isSelected
                          ? 0.13
                          : 0.05,
                    ),
                    blurRadius:
                    isSelected ? 9 : 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.primaryContainer,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      answer.answerText,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  AnimatedSwitcher(
                    duration:
                    const Duration(milliseconds: 200),
                    child: isSelected
                        ? Icon(
                      Icons.check_circle_rounded,
                      key: const ValueKey(
                        'selected',
                      ),
                      color: colorScheme.primary,
                      size: 27,
                    )
                        : Icon(
                      Icons.touch_app_rounded,
                      key: const ValueKey(
                        'unselected',
                      ),
                      color: colorScheme.outline,
                      size: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.link_off_rounded,
            size: 50,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'No matching answers available',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}