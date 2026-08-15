import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../models/lesson_step.dart';
import '../services/content_service.dart';
import '../widgets/lesson_step_widget.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final ContentService contentService = ContentService();

  List<LessonStep> lessonSteps = [];
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    loadLessonSteps();
  }

  Future<void> loadLessonSteps() async {
    final data = await contentService.getLessonSteps(
      widget.lesson.subjectId,
      widget.lesson.lessonId,
    );

    List<LessonStep> loadedSteps = [];

    for (var item in data) {
      loadedSteps.add(
        LessonStep(
          lessonStepId: item['lessonStepId'],
          lessonId: item['lessonId'],
          subjectId: item['subjectId'],
          type: item['type'],
          title: item['title'],
          content: item['content'],
        ),
      );
    }

    setState(() {
      lessonSteps = loadedSteps;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              child: lessonSteps.isEmpty
                  ? const Center(
                child: Text('No lesson content available'),
              )
                  : LessonStepWidget(
                lessonStep: lessonSteps[currentStep],
              ),
            ),

            SizedBox(height: screenWidth * 0.04),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: currentStep > 0
                        ? () {
                      setState(() {
                        currentStep--;
                      });
                    }
                        : null,
                    child: const Text('Back'),
                  ),
                ),

                SizedBox(width: screenWidth * 0.04),

                Expanded(
                  child: ElevatedButton(
                    onPressed: lessonSteps.isNotEmpty &&
                        currentStep < lessonSteps.length - 1
                        ? () {
                      setState(() {
                        currentStep++;
                      });
                    }
                        : null,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}