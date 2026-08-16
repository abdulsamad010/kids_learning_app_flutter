import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../models/lesson.dart';
import '../services/content_service.dart';
import '../widgets/lesson_card.dart';
import 'lesson_screen.dart';

class LessonListScreen extends StatefulWidget {
  final Subject subject;

  const LessonListScreen({
    super.key,
    required this.subject,
  });

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  final ContentService contentService = ContentService();

  List<Lesson> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLessons();
  }

  Future<void> loadLessons() async {
    setState(() {
      isLoading = true;
    });

    final data = await contentService.getLessons(
      widget.subject.subjectId,
    );

    final List<Lesson> loadedLessons = [];

    for (final item in data) {
      loadedLessons.add(
        Lesson(
          lessonId: item['lessonId'],
          subjectId: item['subjectId'],
          title: item['title'],
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      lessons = loadedLessons;
      isLoading = false;
    });
  }

  void openLesson(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(
          lesson: lesson,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadLessons,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              size.width * 0.045,
              size.height * 0.025,
              size.width * 0.045,
              size.height * 0.04,
            ),
            children: [
              buildHeader(
                theme,
                colorScheme,
                size,
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              if (isLoading)
                buildLoading(
                  colorScheme,
                )
              else if (lessons.isEmpty)
                buildEmptyState(
                  theme,
                  colorScheme,
                )
              else
                buildLessonsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(
      ThemeData theme,
      ColorScheme colorScheme,
      Size size,
      ) {
    return Container(
      padding: EdgeInsets.all(
        size.width * 0.045,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.secondaryContainer,
            colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: 0.12,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            constraints: const BoxConstraints(
              minWidth: 52,
              minHeight: 52,
              maxWidth: 70,
              maxHeight: 70,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: 0.9,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              size: size.width * 0.075,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(
            width: size.width * 0.04,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.subject.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose a lesson and start learning!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer
                        .withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLessonsList() {
    return Column(
      children: List.generate(
        lessons.length,
            (index) {
          final lesson = lessons[index];

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),
            child: TweenAnimationBuilder<double>(
              duration: Duration(
                milliseconds: 300 + (index * 80),
              ),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(
                begin: 0,
                end: 1,
              ),
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
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => openLesson(lesson),
                child: LessonCard(
                  lesson: lesson,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoading(
      ColorScheme colorScheme,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 80,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: 18),
          Text(
            'Loading lessons...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No Lessons Available',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no lessons available for this subject yet.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: loadLessons,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}