import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/Task.dart';


class TaskProvider with ChangeNotifier {
  final DatabaseReference _databaseReference;

  TaskProvider(this._databaseReference);

  Future<void> addTask(Task task) async {
    await _databaseReference.push().set(task.toMap());
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _databaseReference.child(task.id).update(task.toMap());
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await _databaseReference.child(taskId).remove();
    notifyListeners();
  }
}
