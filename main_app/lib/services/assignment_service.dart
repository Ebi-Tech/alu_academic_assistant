import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Assignment {
  final String id;
  final String title;
  final String course;
  final DateTime dueDate;
  final String type; // Formative / Summative
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    required this.type,
    this.isCompleted = false,
  });
}

class AssignmentService extends ChangeNotifier {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => List.unmodifiable(_assignments);

  final _uuid = const Uuid();

  void addAssignment({
    required String title,
    required String course,
    required DateTime dueDate,
    required String type,
  }) {
    final newAssignment = Assignment(
      id: _uuid.v4(),
      title: title,
      course: course,
      dueDate: dueDate,
      type: type,
    );
    _assignments.add(newAssignment);
    notifyListeners();
  }

  void updateAssignment(Assignment updated) {
    final index = _assignments.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _assignments[index] = updated;
      notifyListeners();
    }
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleCompleted(String id) {
    final assignment = _assignments.firstWhere((a) => a.id == id);
    assignment.isCompleted = !assignment.isCompleted;
    notifyListeners();
  }
}
