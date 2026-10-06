import 'package:flutter/material.dart';
import 'models/student.dart';
import 'screens/add_student_page.dart';

void main() {
  runApp(const StudentInformationSystem());
}

class StudentInformationSystem extends StatelessWidget {
  const StudentInformationSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Information System',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [
    Student(
      id: 1,
      name: 'Juan Dela Cruz',
      course: 'BS Information Technology',
      yearLevel: 2,
      email: 'juan@example.com',
    ),
    Student(
      id: 2,
      name: 'Maria Santos',
      course: 'BS Information Technology',
      yearLevel: 1,
      email: 'maria@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Information System')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(student.name),
            subtitle: Text(student.course),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final student = await Navigator.push<Student>(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentPage()),
          );
          if (student != null && mounted) {
            setState(() {
              students.add(student);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
