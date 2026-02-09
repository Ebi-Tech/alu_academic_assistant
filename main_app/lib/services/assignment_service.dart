import 'package:flutter/material.dart';
import '../models/assignment.dart';
import 'json_storage_service.dart';

class AssignmentService extends ChangeNotifier {
  List<Assignment> _assignments = [];
  final JsonStorageService _storage = JsonStorageService();
  bool _isLoading = false;

  AssignmentService() {
    _loadFromStorage();
  }

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

  bool get isLoading => _isLoading;

  // Load assignments from JSON file
  Future<void> _loadFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('📂 Loading assignments from storage...');
      final jsonList = await _storage.loadFromFile('assignments.json');
      
      _assignments = jsonList.map((json) => Assignment.fromJson(json)).toList();
      print('✅ Loaded ${_assignments.length} assignments from storage');
    } catch (e) {
      print('❌ Error loading assignments: $e');
      _assignments = []; // Start with empty list on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save assignments to JSON file
  Future<void> _saveToStorage() async {
    try {
      final jsonList = _assignments.map((a) => a.toJson()).toList();
      await _storage.saveToFile('assignments.json', jsonList);
    } catch (e) {
      print('❌ Error saving assignments: $e');
    }
  }

  // Add a new assignment
  Future<void> addAssignment(Assignment assignment) async {
    _assignments.add(assignment);
    await _saveToStorage();
    notifyListeners();
  }

  // Update an existing assignment
  Future<void> updateAssignment(Assignment updated) async {
    final index = _assignments.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _assignments[index] = updated;
      await _saveToStorage();
      notifyListeners();
    }
  }

  // Delete an assignment
  Future<void> deleteAssignment(String id) async {
    _assignments.removeWhere((a) => a.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  // Toggle completion status
  Future<void> toggleCompleted(String id) async {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index].isCompleted = !_assignments[index].isCompleted;
      await _saveToStorage();
      notifyListeners();
    }
  }

  // Clear all assignments (for testing)
  Future<void> clearAll() async {
    _assignments.clear();
    await _storage.deleteFile('assignments.json');
    notifyListeners();
  }

  // Get storage info (for debugging)
  Future<Map<String, dynamic>> getStorageInfo() async {
    final exists = await _storage.fileExists('assignments.json');
    final files = await _storage.listFiles();
    
    return {
      'fileExists': exists,
      'allFiles': files,
      'assignmentCount': _assignments.length,
    };
  }

  void addSampleData() {}
}
