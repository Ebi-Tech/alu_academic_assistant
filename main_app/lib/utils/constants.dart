import 'package:flutter/material.dart';

// ALU Official Color Palette
class ALUColors {
 
  static const Color primaryDark = Color(0xFF0A192F);    
  static const Color primaryBlue = Color(0xFF0033A0);    
  

  static const Color warningRed = Color(0xFFD32F2F);     
  static const Color warningYellow = Color(0xFFFFC72C);  
  static const Color successGreen = Color(0xFF43B02A);   
  static const Color progressBlue = Color(0xFF2196F3);  
  

  static const Color cardDark = Color(0xFF1E293B);
  static const Color cardLight = Color(0xFF2D3748);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFA0AEC0);
  static const Color textLight = Color(0xFFCBD5E0);
  static const Color textDark = Color(0xFF333333);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFF4A5568);

  static var secondaryBlue;
  

}

// App Constants
class AppConstants {
  static const String appName = 'ALU Academic Assistant';
  static const double attendanceThreshold = 0.75;
  static const int academicWeeks = 15;
  
  static const List<String> sessionTypes = [
    'Class',
    'Mastery Session', 
    'Study Group',
    'PSL Meeting',
    'Industry Talk',
    'Workshop',
  ];
  
  static const List<String> priorityLevels = [
    'High',
    'Medium', 
    'Low',
  ];
}
