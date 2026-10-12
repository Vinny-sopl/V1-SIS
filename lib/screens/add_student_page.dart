import 'package:flutter/material.dart';

import '../models/student.dart';

class AddStudentPage extends StatefulWidget {
  final Student? student;

  const AddStudentPage({super.key, this.student});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    if (student != null) {
      nameController.text = student.name;
      courseController.text = student.course;
      yearController.text = student.yearLevel.toString();
      emailController.text = student.email;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    yearController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Year Level',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final course = courseController.text.trim();
                final yearLevel = int.tryParse(yearController.text.trim());
                final email = emailController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter the student name.'),
                    ),
                  );
                  return;
                }
                if (course.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter the course.')),
                  );
                  return;
                }
                if (yearLevel == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid year level.'),
                    ),
                  );
                  return;
                }
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter the email.')),
                  );
                  return;
                }

                final student = Student(
                  id:
                      widget.student?.id ??
                      DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  course: course,
                  yearLevel: yearLevel,
                  email: email,
                );

                Navigator.pop(context, student);
              },
              child: Text(
                widget.student == null ? 'Save Student' : 'Update Student',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
