import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/AppColors.dart';
import '../../common/AppRoutes.dart';
import '../../model/Task.dart';
import '../../service/FirebaseMessagingHelper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessagingHelper _firebaseMessagingHelper = FirebaseMessagingHelper();
  String? _firebaseToken;
  late DatabaseReference _databaseReference;
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  String userEmail = 'user@example.com';

  @override
  void initState() {
    super.initState();
    _getFirebaseToken();
    _databaseReference = FirebaseDatabase.instance.ref().child('tasks');
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, navigate to login screen
      Get.offNamed(AppRoutes.login);
    } else if (!user.emailVerified) {
      // User is logged in but not verified, navigate to verification screen
      Get.offNamed(AppRoutes.Verify);
    } else {
      // User is logged in and verified, fetch tasks
      userEmail = user.email ?? 'user@example.com';
      _fetchTasks();
    }
  }
  void _getFirebaseToken() async {
    _firebaseToken = await _firebaseMessagingHelper.getFirebaseToken();
    print("Firebase Token: $_firebaseToken");
  }

  TimeOfDay _parseTime(String timeString) {
    final List<String> timeParts = timeString.split(' ');
    final List<String> hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    if (timeParts[1].toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    } else if (timeParts[1].toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }
    int minute = int.parse(hourMinute[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
  void _fetchTasks() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email ?? 'user@example.com';
      String userUid = user.uid;
      DatabaseReference userTasksRef = _databaseReference.child(userUid);
      userTasksRef.onValue.listen((event) {
        var snapshot = event.snapshot;
        if (snapshot != null && snapshot.value != null) {
          if (snapshot.value is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> tasksMap = snapshot.value as Map<dynamic, dynamic>;
            List<Task> taskList = [];
            tasksMap.forEach((key, value) {
              print('Task ID: $key');
              print('Title: ${value['title']}');
              Task task = Task(
                id: key,
                title: value['title'],
                description: value['description'],
                teamMember: value['teamMember'],
                dueDate: DateTime.parse(value['dueDate']),
                dueTime: _parseTime(value['dueTime']), // Parse the dueTime here
                priority: value['priority'],
                isCompleted: value['isCompleted'] ?? false,
              );
              taskList.add(task);
            });
            setState(() {
              tasks = taskList.where((task) => !task.isCompleted).toList();
              completedTasks = taskList.where((task) => task.isCompleted).toList();
            });
          } else {
            // Handle other data types as needed
            // ...
          }
        } else {
          setState(() {
            tasks = [];
            completedTasks = [];
          });
        }
      });
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }
  void _toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      // Remove task from the tasks list
      tasks.remove(task);
      // Add task to the completedTasks list
      completedTasks.add(task);
      // Update the Firebase node for completed tasks
      _databaseReference.child(task.id).update({'isCompleted': true});
    } else {
      // If the task is marked as incomplete again, move it back to tasks list
      completedTasks.remove(task);
      tasks.add(task);
      // Update the Firebase node for completed tasks
      _databaseReference.child(task.id).update({'isCompleted': false});
    }
    setState(() {});
  }

  // void _toggleTaskCompletion(Task task) {
  //   task.isCompleted = !task.isCompleted;
  //   if (task.isCompleted) {
  //     completedTasks.add(task);
  //   } else {
  //     completedTasks.remove(task);
  //   }
  //   _databaseReference.child(task.id).update({'isCompleted': task.isCompleted});
  //   setState(() {});
  // }

  void _filterTasks(String searchQuery) {
    if (searchQuery.isEmpty) {
      setState(() {
        tasks = tasks;
      });
    } else {
      setState(() {
        tasks = tasks.where((task) {
          return task.title.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day Task',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   userEmail,
                    //   style: const TextStyle(color: Colors.white),
                    // ),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: AppColors.buttonColor,
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.Profile);
                    },
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                              onChanged: _filterTasks,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.buttonColor,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.taskCreation);
                    },
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Completed Tasks
          const SizedBox(height: 32),
          const Text(
            'Completed Task',
            style: TextStyle(
                color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            constraints: const BoxConstraints(maxHeight: 130),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                var task = completedTasks[index];
                return Card(
                  color: const Color(0xFF263238),
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Priority: ${task.priority}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Due Time: ${task.dueTime.format(context)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Ongoing Task',
            style: TextStyle(
                color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          // Tasks List
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Card(
                  color: const Color(0xFF263238),
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) => _toggleTaskCompletion(task),
                            ),
                            Text(
                              task.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Priority: ${task.priority}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Due Time: ${task.dueTime.format(context)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
