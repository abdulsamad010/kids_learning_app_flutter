import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../services/content_service.dart';
import '../widgets/subject_card.dart';
import 'lesson_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContentService contentService = ContentService();

  List<Subject> subjects = [];
  Map<String, dynamic> userProgress = {};

  bool isLoadingSubjects = true;
  bool isLoadingProgress = true;

  @override
  void initState() {
    super.initState();
    loadSubjects();
    loadUserProgress();
  }

  Future<void> loadSubjects() async {
    final data = await contentService.getSubjects();

    final List<Subject> loadedSubjects = [];

    for (final item in data) {
      loadedSubjects.add(
        Subject(
          subjectId: item['subjectId'],
          name: item['name'],
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      subjects = loadedSubjects;
      isLoadingSubjects = false;
    });
  }

  Future<void> loadUserProgress() async {
    final data = await contentService.getUserProgress();

    if (!mounted) return;

    setState(() {
      userProgress = data ?? {};
      isLoadingProgress = false;
    });
  }

  int get currentLevel {
    return userProgress['currentLevel'] ?? 0;
  }

  int get score {
    return userProgress['score'] ?? 0;
  }

  int get completedQuizzes {
    return userProgress['completedQuizzes'] ?? 0;
  }

  int get totalQuizzes {
    return userProgress['totalQuizzes'] ?? 0;
  }

  int get progressPercentage {
    final value = userProgress['progressPercentage'] ?? 0;
    return value.clamp(0, 100);
  }

  String get learningStatus {
    return userProgress['status'] ?? 'Start Learning';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Learning'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            loadSubjects(),
            loadUserProgress(),
          ]);
        },
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            28,
          ),
          children: [
            buildWelcomeHeader(
              theme,
              colorScheme,
            ),
            const SizedBox(height: 18),
            if (isLoadingProgress)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              buildProgressDashboard(
                theme,
                colorScheme,
              ),
            const SizedBox(height: 28),
            buildSubjectsHeader(
              theme,
              colorScheme,
            ),
            const SizedBox(height: 14),
            if (isLoadingSubjects)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (subjects.isEmpty)
              buildEmptySubjects(
                theme,
                colorScheme,
              )
            else
              ...List.generate(
                subjects.length,
                    (index) {
                  final subject = subjects[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: buildSubjectItem(
                      subject,
                      index,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeHeader(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(
        begin: 0.92,
        end: 1,
      ),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: 0.12,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(
                  alpha: 0.85,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 34,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to Learn?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                      colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Explore, learn, and have fun!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme
                          .onPrimaryContainer
                          .withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressDashboard(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(
        begin: 0.94,
        end: 1,
      ),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                      colorScheme.primaryContainer,
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.insights_rounded,
                      color:
                      colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Progress',
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          learningStatus,
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              buildOverallProgress(
                theme,
                colorScheme,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: buildProgressStat(
                      theme,
                      Icons.star_rounded,
                      'Level',
                      '$currentLevel',
                      colorScheme.primaryContainer,
                      colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildProgressStat(
                      theme,
                      Icons.emoji_events_rounded,
                      'Score',
                      '$score',
                      colorScheme.secondaryContainer,
                      colorScheme
                          .onSecondaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildProgressStat(
                      theme,
                      Icons.quiz_rounded,
                      'Quizzes',
                      '$completedQuizzes / $totalQuizzes',
                      colorScheme.tertiaryContainer,
                      colorScheme
                          .onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildProgressStat(
                      theme,
                      Icons.trending_up_rounded,
                      'Status',
                      learningStatus,
                      colorScheme
                          .surfaceContainerHighest,
                      colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOverallProgress(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color:
                colorScheme.primaryContainer,
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                '$progressPercentage%',
                style: theme
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme
                      .onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius:
          BorderRadius.circular(20),
          child: TweenAnimationBuilder<double>(
            duration:
            const Duration(milliseconds: 900),
            tween: Tween(
              begin: 0,
              end: progressPercentage / 100,
            ),
            curve: Curves.easeOut,
            builder: (
                context,
                value,
                child,
                ) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 11,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildProgressStat(
      ThemeData theme,
      IconData icon,
      String title,
      String value,
      Color backgroundColor,
      Color foregroundColor,
      ) {
    return Container(
      constraints:
      const BoxConstraints(minHeight: 105),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: foregroundColor,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubjectsHeader(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color:
            colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Your Subjects',
                style: theme
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Choose something to learn',
                style:
                theme.textTheme.bodySmall?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color:
            colorScheme.surfaceContainerHighest,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Text(
            '${subjects.length}',
            style:
            theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubjectItem(
      Subject subject,
      int index,
      ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(
        milliseconds: 300 + (index * 80),
      ),
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      curve: Curves.easeOut,
      builder: (context, value, child) {
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LessonListScreen(
                    subject: subject,
                  ),
            ),
          );
        },
        child: SubjectCard(
          subject: subject,
        ),
      ),
    );
  }

  Widget buildEmptySubjects(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_outlined,
                size: 38,
                color:
                colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Subjects Yet',
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'There are no subjects available right now.',
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}