import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/answer.dart';

class MultipleChoice extends StatefulWidget {
  final Question question;
  final List<Answer> answers;
  final Function(Answer) onAnswerSelected;

  const MultipleChoice({
    super.key,
    required this.question,
    required this.answers,
    required this.onAnswerSelected,
  });

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice>
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
                    Icons.quiz_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Choose the answer',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              widget.question.questionText,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tap one answer below',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            if (widget.answers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
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
              ...List.generate(
                widget.answers.length,
                    (index) {
                  final answer = widget.answers[index];

                  final bool isSelected =
                      selectedAnswerId == answer.answerId;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index ==
                          widget.answers.length - 1
                          ? 0
                          : 12,
                    ),
                    child: TweenAnimationBuilder<double>(
                      duration: Duration(
                        milliseconds: 250 + (index * 70),
                      ),
                      tween: Tween(
                        begin: 0,
                        end: 1,
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
                              20 * (1 - value),
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
                            borderRadius:
                            BorderRadius.circular(18),
                            onTap: () => selectAnswer(answer),
                            child: AnimatedContainer(
                              duration:
                              const Duration(
                                milliseconds: 200,
                              ),
                              padding:
                              const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surface,
                                borderRadius:
                                BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme
                                      .outlineVariant,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.shadow
                                        .withValues(
                                      alpha:
                                      isSelected
                                          ? 0.10
                                          : 0.04,
                                    ),
                                    blurRadius:
                                    isSelected ? 8 : 4,
                                    offset:
                                    const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration:
                                    const Duration(
                                      milliseconds: 200,
                                    ),
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme
                                          .surfaceContainerHighest,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(
                                          65 + index,
                                        ),
                                        style: theme
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontWeight:
                                          FontWeight.bold,
                                          color: isSelected
                                              ? colorScheme
                                              .onPrimary
                                              : colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      answer.answerText,
                                      style: theme
                                          .textTheme
                                          .titleMedium
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
                                    const Duration(
                                      milliseconds: 200,
                                    ),
                                    child: isSelected
                                        ? Icon(
                                      Icons
                                          .check_circle_rounded,
                                      key: const ValueKey(
                                        'selected',
                                      ),
                                      color:
                                      colorScheme.primary,
                                      size: 28,
                                    )
                                        : Icon(
                                      Icons
                                          .radio_button_unchecked_rounded,
                                      key: const ValueKey(
                                        'unselected',
                                      ),
                                      color:
                                      colorScheme.outline,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}