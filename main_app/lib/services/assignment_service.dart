import 'package:flutter/foundation.dart';
import '../models/assignment.dart';

class AssignmentService extends ChangeNotifier {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments {
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return List.unmodifiable(_assignments);
  }

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  void updateAssignment(Assignment updatedAssignment) {
    final index =
        _assignments.indexWhere((a) => a.id == updatedAssignment.id);
    if (index != -1) {
      _assignments[index] = updatedAssignment;
      notifyListeners();
    }
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleCompletion(String id) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] =
          _assignments[index].copyWith(
            isCompleted: !_assignments[index].isCompleted,
          );
      notifyListeners();
    }
  }
}
