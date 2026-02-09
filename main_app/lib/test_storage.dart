import 'package:flutter/material.dart';
import 'services/assignment_service.dart';
import 'services/session_service.dart';

void testStorage() async {
  print('\n' + '='*50);
  print('🧪 TESTING JSON STORAGE IMPLEMENTATION');
  print('='*50);
  
  // Create services
  final assignmentService = AssignmentService();
  final sessionService = SessionService();
  
  // Wait for initial load (2 seconds)
  print('\n⏳ Waiting for services to load data...');
  await Future.delayed(const Duration(seconds: 2));
  
  // Print storage info
  print('\n📊 STORAGE INFORMATION:');
  print('-'*30);
  
  final assignmentInfo = await assignmentService.getStorageInfo();
  print('Assignments:');
  print('  • File exists: ${assignmentInfo['fileExists']}');
  print('  • Count: ${assignmentInfo['assignmentCount']}');
  
  final sessionInfo = await sessionService.getStorageInfo();
  print('Sessions:');
  print('  • File exists: ${sessionInfo['fileExists']}');
  print('  • Count: ${sessionInfo['sessionCount']}');
  print('  • Attendance: ${(sessionInfo['attendancePercentage'] * 100).toStringAsFixed(1)}%');
  
  // List all files
  print('\n📁 ALL FILES IN STORAGE:');
  print('-'*30);
  if (assignmentInfo['allFiles'] != null) {
    final files = assignmentInfo['allFiles'] as List<String>;
    for (var file in files) {
      print('  • $file');
    }
  }
  
  // Test explanation
  print('\n✅ TEST COMPLETE!');
  print('\n📝 WHAT TO DO NEXT:');
  print('1. Run the app: flutter run');
  print('2. Check console for "Loading assignments/sessions from storage..."');
  print('3. Add an assignment - should see "Saved X items to assignments.json"');
  print('4. Close the app completely');
  print('5. Reopen app - your data should still be there!');
  print('6. For demo video: Show console logs and explain JSON file storage');
  
  print('\n' + '='*50);
}

// Helper to call from main.dart temporarily
void runStorageTest() {
  WidgetsFlutterBinding.ensureInitialized();
  testStorage();
}