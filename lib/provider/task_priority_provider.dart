import 'package:flutter/material.dart';

import '../util/task_priority.dart';


class TaskPriorityProvider with ChangeNotifier {
  TaskPriority _selectedPriority = TaskPriority.low;

  TaskPriority get selectedPriority => _selectedPriority;

  void setPriority(TaskPriority priority) {
    _selectedPriority = priority;
    notifyListeners();
  }
}
