import 'package:flutter/material.dart';
import '../models/assignment.dart';

class AssignmentService extends ChangeNotifier {
  List<Assignment> _assignments = [];
  
  List<Assignment> get assignments {
    // Sort by due date (closest first)
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return List.unmodifiable(_assignments);
  }
  
  List<Assignment> get pendingAssignments {
    return _assignments.where((a) => !a.isCompleted).toList();
  }
  
  List<Assignment> get assignmentsDueNext7Days {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return _assignments.where((a) => 
      !a.isCompleted && 
      a.dueDate.isAfter(now) && 
      a.dueDate.isBefore(nextWeek)
    ).toList();
  }
  
  // Add assignment
  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }
  
  // Update assignment
  void updateAssignment(Assignment updated) {
    final index = _assignments.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _assignments[index] = updated;
      notifyListeners();
    }
  }
  
  // Delete assignment
  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }
  
  // Toggle completion
  void toggleCompleted(String id) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index].isCompleted = !_assignments[index].isCompleted;
      notifyListeners();
    }
  }
  
  // For testing - add sample data
  void addSampleData() {
    _assignments.addAll([
      Assignment(
        id: '1',
        title: 'Mobile App Project',
        course: 'Software Engineering',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        priority: 'High',
        isCompleted: false,
      ),
      Assignment(
        id: '2',
        title: 'Data Structures Quiz',
        course: 'Computer Science',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: 'Medium',
        isCompleted: false,
      ),
      Assignment(
        id: '3',
        title: 'Professional Skills Reflection',
        course: 'PSL',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: 'High',
        isCompleted: false,
      ),
    ]);
    notifyListeners();
  }
}
