import 'package:flutter/material.dart';

// ALU Official Color Palette
class ALUColors {
  static const Color primaryBlue = Color(0xFF0033A0);    // ALU Blue
  static const Color secondaryRed = Color(0xFFE31837);   // ALU Red
  static const Color warningYellow = Color(0xFFFFC72C);  // Warning Yellow
  static const Color successGreen = Color(0xFF43B02A);   // Success Green
  static const Color backgroundGray = Color(0xFFF5F5F5); // Background Gray
  static const Color textDark = Color(0xFF333333);       // Dark Text
  static const Color textLight = Color(0xFF666666);      // Light Text
  static const Color cardWhite = Color(0xFFFFFFFF);      // Card White
}

// App Constants
class AppConstants {
  static const String appName = 'ALU Academic Assistant';
  static const double attendanceThreshold = 0.75; // 75%
  static const int academicWeeks = 15; // Typical semester length
  
  // Session Types
  static const List<String> sessionTypes = [
    'Class',
    'Mastery Session', 
    'Study Group',
    'PSL Meeting',
  ];
  
  // Priority Levels
  static const List<String> priorityLevels = [
    'High',
    'Medium', 
    'Low',
  ];
  
  // Date Formats
  static const String dateFormat = 'EEEE, MMMM d, yyyy';
  static const String timeFormat = 'h:mm a';
  static const String shortDateFormat = 'MMM d';
}