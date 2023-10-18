import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../common/AppFonts.dart';
import '../../common/AppRoutes.dart';
import '../../model/Task.dart';
import '../../provider/task_priority_provider.dart';
import '../../provider/task_provider.dart';
import '../../util/task_priority.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _teamMemberController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();


  Future<void> _saveTask(Task task) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userUid = user.uid;
      print('User UID: ${user.uid}');



      DatabaseReference userTasksRef = _databaseReference.child('tasks/$userUid');

      try {
        await userTasksRef.push().set({
          'title': task.title,
          'description': task.description,
          'teamMember': task.teamMember,
          'dueDate': task.dueDate.toIso8601String(),
          'dueTime': task.dueTime.format(context),
          'priority': task.priority.toString().split('.').last, // Convert enum to string
          'isCompleted': task.isCompleted,
        });
        print('Task added successfully.');
      } catch (error) {
        print('Error adding task: $error');
      }
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }




  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    var priorityProvider = Provider.of<TaskPriorityProvider>(context);
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFF212832),
      appBar: AppBar(
        backgroundColor: Color(0xFF212832),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Create New Task', style: AppFonts.firmaBold.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display current user information below app bar
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'User: ${user.email}', // You can use user.displayName, user.phoneNumber, etc. based on your user data
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF455A64),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Task Description',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF455A64),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _teamMemberController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Team Member',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF455A64),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFF455A64),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _selectTime(context);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(text: _selectedTime.format(context)),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Due Time',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFF455A64),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPriorityChips(priorityProvider),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    Future.delayed(const Duration(seconds: 3), () {
                      Task newTask = Task(
                        id: DateTime.now().toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        teamMember: _teamMemberController.text,
                        dueDate: _selectedDate,
                        dueTime: _selectedTime,
                        priority: priorityProvider.selectedPriority.toString().split('.').last,
                      );

                      _saveTask(newTask).then((_) {
                        Navigator.pop(context);
                        Get.offNamed(AppRoutes.home);
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFED36A),
                  ),
                  child: Text('Add Task', style: AppFonts.firmaBold.copyWith(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChips(TaskPriorityProvider priorityProvider) {
    return Wrap(
      children: TaskPriority.values.map((TaskPriority priority) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ChoiceChip(
            label: Text(
              _getPriorityText(priority),
              style: TextStyle(color: Colors.white),
            ),
            selected: priorityProvider.selectedPriority == priority,
            onSelected: (bool selected) {
              priorityProvider.setPriority(selected ? priority : TaskPriority.low);
            },
            selectedColor: Colors.green,
          ),
        );
      }).toList(),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      default:
        return '';
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (selectedTime != null && selectedTime != _selectedTime) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
