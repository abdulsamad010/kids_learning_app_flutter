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

  @override
  void initState() {
    super.initState();
    loadLessons();
  }

  Future<void> loadLessons() async {
    final data = await contentService.getLessons(
      widget.subject.subjectId,
    );

    List<Lesson> loadedLessons = [];

    for (var item in data) {
      loadedLessons.add(
        Lesson(
          lessonId: item['lessonId'],
          subjectId: item['subjectId'],
          title: item['title'],
        ),
      );
    }

    setState(() {
      lessons = loadedLessons;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: lessons.isEmpty
            ? const Center(
          child: Text('No lessons available'),
        )
            : ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: screenWidth * 0.03,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonScreen(
                        lesson: lessons[index],
                      ),
                    ),
                  );
                },
                child: LessonCard(
                  lesson: lessons[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}