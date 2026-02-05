import 'package:flutter/material.dart';

// ALU Official Color Palette - Updated from sample images
class ALUColors {
  // Primary colors from sample (dark blue theme)
  static const Color primaryDark = Color(0xFF0A192F);    // Dark blue background
  static const Color primaryBlue = Color(0xFF0033A0);    // ALU Blue (buttons, accents)
  static const Color secondaryBlue = Color(0xFF1A237E);  // Lighter blue for cards
  
  // Status colors from sample
  static const Color warningRed = Color(0xFFD32F2F);     // AT RISK WARNING red
  static const Color warningYellow = Color(0xFFFFC72C);  // Warning yellow
  static const Color successGreen = Color(0xFF43B02A);   // Green for good status
  static const Color progressBlue = Color(0xFF2196F3);   // Progress bars blue
  
  // UI Colors
  static const Color cardDark = Color(0xFF1E293B);       // Dark cards
  static const Color cardLight = Color(0xFF2D3748);      // Lighter cards
  static const Color textWhite = Color(0xFFFFFFFF);      // White text
  static const Color textGrey = Color(0xFFA0AEC0);       // Grey text
  static const Color textLight = Color(0xFFCBD5E0);      // Light text
  static const Color divider = Color(0xFF4A5568);        // Divider lines
  
  // Button colors from sample
  static const Color buttonPrimary = Color(0xFF0033A0);  // Primary buttons
  static const Color buttonSecondary = Color(0xFF2D3748); // Secondary buttons
}

// App Constants
class AppConstants {
  static const String appName = 'ALU Academic Assistant';
  static const double attendanceThreshold = 0.75; // 75%
  static const int academicWeeks = 15;
  
  // From sample images
  static const List<String> sessionTypes = [
    'Class',
    'Mastery Session', 
    'Study Group',
    'PSL Meeting',
    'Industry Talk',    // Added from sample
    'Workshop',         // Added from sample
  ];
  
  static const List<String> assignmentTypes = [
    'Formative',
    'Summative',
    'Quiz',
    'Project',
    'Group Assignment', // From sample
  ];
  
  static const List<String> priorityLevels = [
    'High',
    'Medium', 
    'Low',
  ];
}
