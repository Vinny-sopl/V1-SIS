import 'package:flutter/material.dart';
import 'models/student.dart';
import 'screens/add_student_page.dart';
import 'screens/student_details_page.dart';

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
  final searchController = TextEditingController();

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

  List<Student> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchStudents(String query) {
    setState(() {
      filteredStudents = _matchingStudents(query);
    });
  }

  List<Student> _matchingStudents(String query) {
    final searchQuery = query.toLowerCase();
    return students.where((student) {
      return student.name.toLowerCase().contains(searchQuery) ||
          student.course.toLowerCase().contains(searchQuery);
    }).toList();
  }

  Future<void> _confirmDelete(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        students.remove(student);
        filteredStudents = _matchingStudents(searchController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Information System')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: searchStudents,
              decoration: const InputDecoration(
                labelText: 'Search Student',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Total Students: ${students.length}'),
            ),
          ),
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(student.name),
                        subtitle: Text(student.course),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit student',
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final updatedStudent =
                                    await Navigator.push<Student>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddStudentPage(student: student),
                                      ),
                                    );
                                if (updatedStudent != null && mounted) {
                                  setState(() {
                                    final studentIndex = students.indexWhere(
                                      (item) => item.id == updatedStudent.id,
                                    );
                                    if (studentIndex != -1) {
                                      students[studentIndex] = updatedStudent;
                                      filteredStudents = _matchingStudents(
                                        searchController.text,
                                      );
                                    }
                                  });
                                }
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete student',
                              icon: const Icon(Icons.delete),
                              onPressed: () => _confirmDelete(student),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentDetailsPage(student: student),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
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
              filteredStudents = _matchingStudents(searchController.text);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
