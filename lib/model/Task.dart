import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String teamMember;
  final DateTime dueDate;
  final TimeOfDay dueTime;
  final String priority;
  late bool isCompleted;
  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.teamMember,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
  });

  // Convert Task object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teamMember': teamMember,
      'dueDate': dueDate.toIso8601String(), // Convert DateTime to String
      'dueTime': '${dueTime.hour}:${dueTime.minute}', // Convert TimeOfDay to String
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  // Factory constructor to create a Task object from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      teamMember: map['teamMember'],
      dueDate: DateTime.parse(map['dueDate']), // Parse String to DateTime
      dueTime: TimeOfDay(
        hour: int.parse(map['dueTime'].split(':')[0]), // Parse String to int
        minute: int.parse(map['dueTime'].split(':')[1]), // Parse String to int
      ),
      priority: map['priority'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
