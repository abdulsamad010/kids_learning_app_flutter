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

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    final data = await contentService.getSubjects();

    List<Subject> loadedSubjects = [];

    for (var item in data) {
      loadedSubjects.add(
        Subject(
          subjectId: item['subjectId'],
          name: item['name'],
        ),
      );
    }

    setState(() {
      subjects = loadedSubjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Learning'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: subjects.isEmpty
            ? const Center(
          child: Text('No subjects available'),
        )
            : ListView.builder(
          itemCount: subjects.length,
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
                      builder: (context) => LessonListScreen(
                        subject: subjects[index],
                      ),
                    ),
                  );
                },
                child: SubjectCard(
                  subject: subjects[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}