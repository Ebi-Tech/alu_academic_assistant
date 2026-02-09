import 'package:flutter/material.dart';
import '../models/academic_session.dart';
import '../utils/helpers.dart';
import 'json_storage_service.dart';

class SessionService extends ChangeNotifier {
  List<AcademicSession> _sessions = [];
  final JsonStorageService _storage = JsonStorageService();
  bool _isLoading = false;

  SessionService() {
    _loadFromStorage();
  }

  List<AcademicSession> get sessions => List.unmodifiable(_sessions);

  List<AcademicSession> get todaysSessions {
    return _sessions.where((session) => DateHelpers.isToday(session.date)).toList();
  }

  double get attendancePercentage {
    if (_sessions.isEmpty) return 1.0;
    final presentSessions = _sessions.where((s) => s.isPresent).length;
    return presentSessions / _sessions.length;
  }

  bool get isLoading => _isLoading;

  // Load sessions from JSON file
  Future<void> _loadFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('📂 Loading sessions from storage...');
      final jsonList = await _storage.loadFromFile('sessions.json');
      
      _sessions = jsonList.map((json) => AcademicSession.fromJson(json)).toList();
      print('✅ Loaded ${_sessions.length} sessions from storage');
    } catch (e) {
      print('❌ Error loading sessions: $e');
      _sessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save sessions to JSON file
  Future<void> _saveToStorage() async {
    try {
      final jsonList = _sessions.map((s) => s.toJson()).toList();
      await _storage.saveToFile('sessions.json', jsonList);
    } catch (e) {
      print('❌ Error saving sessions: $e');
    }
  }

  // Add a new session
  Future<void> addSession(AcademicSession session) async {
    _sessions.add(session);
    await _saveToStorage();
    notifyListeners();
  }

  // Update a session
  Future<void> updateSession(AcademicSession updated) async {
    final index = _sessions.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _sessions[index] = updated;
      await _saveToStorage();
      notifyListeners();
    }
  }

  // Delete a session
  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((s) => s.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  // Toggle attendance for a session
  Future<void> toggleAttendance(String sessionId) async {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _sessions[index].isPresent = !_sessions[index].isPresent;
      await _saveToStorage();
      notifyListeners();
    }
  }

  // Clear all sessions (for testing)
  Future<void> clearAll() async {
    _sessions.clear();
    await _storage.deleteFile('sessions.json');
    notifyListeners();
  }

  // For debugging
  Future<Map<String, dynamic>> getStorageInfo() async {
    final exists = await _storage.fileExists('sessions.json');
    return {
      'fileExists': exists,
      'sessionCount': _sessions.length,
      'attendancePercentage': attendancePercentage,
    };
  }

  void addSampleSessions() {}
}
