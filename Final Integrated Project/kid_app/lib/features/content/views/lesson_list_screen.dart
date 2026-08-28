import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/content/viewmodels/content_viewmodel.dart';
import 'package:kid_app/features/content/models/subject_model.dart';
import 'package:kid_app/features/content/models/lesson_model.dart';
import 'package:kid_app/core/common/widgets/loading_widget.dart';
import 'package:kid_app/core/common/widgets/error_display.dart';
import 'package:kid_app/core/common/widgets/empty_state.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  String? _subjectId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subjectId == null) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is String) {
        _subjectId = args;
      } else if (args is SubjectModel) {
        _subjectId = args.id;
      } else if (args is Map<String, dynamic>) {
        _subjectId = args['id'] as String?;
      }
      if (_subjectId != null) {
        _loadData();
      }
    }
  }

  void _loadData() {
    final contentVm = context.read<ContentViewmodel>();
    contentVm.loadSubject(_subjectId!);
    final childId = context.read<ChildViewModel>().selectedChild?.id;
    if (childId != null) {
      context.read<ProgressViewmodel>().loadProgress(childId);
    }
  }

  bool _isLessonCompleted(String lessonId, ProgressViewmodel progressVm) {
    final progress = progressVm.progress;
    if (progress == null) return false;
    return progress.lessonsCompleted.contains(lessonId);
  }

  @override
  Widget build(BuildContext context) {
    final contentVm = context.watch<ContentViewmodel>();
    final subject = contentVm.currentSubject;

    return Scaffold(
      appBar: AppBar(
        title: Text(subject?.name ?? 'Lessons'),
      ),
      body: _buildBody(contentVm, subject),
    );
  }

  Widget _buildBody(ContentViewmodel contentVm, SubjectModel? subject) {
    if (contentVm.isLoading) {
      return const LoadingWidget(message: 'Loading lessons...');
    }

    if (contentVm.errorMessage != null) {
      return ErrorDisplay(
        message: contentVm.errorMessage!,
        onRetry: _loadData,
      );
    }

    if (subject == null) {
      return const EmptyState(
        icon: Icons.subject_rounded,
        title: 'Subject not found',
      );
    }

    final lessons = subject.lessons;
    if (lessons.isEmpty) {
      return const EmptyState(
        icon: Icons.school_rounded,
        title: 'No lessons available',
        subtitle: 'Check back later for new lessons.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Text(
            subject.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return _buildLessonCard(lesson, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(LessonModel lesson, int displayOrder) {
    final progressVm = context.watch<ProgressViewmodel>();
    final isCompleted = _isLessonCompleted(lesson.id, progressVm);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, '/lesson', arguments: lesson.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successColor
                      : colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22,
                        )
                      : Text(
                          '$displayOrder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
