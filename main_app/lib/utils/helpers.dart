import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// Date and Time Helpers
class DateHelpers {
  // Calculate academic week (assuming semester starts Jan 20)
  static int getAcademicWeek(DateTime date) {
    final semesterStart = DateTime(2025, 1, 20);
    final difference = date.difference(semesterStart).inDays;
    return (difference ~/ 7) + 1;
  }
  
  // Format date nicely
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
  
  // Format time nicely
  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime);
  }
  
  // Check if date is within next 7 days
  static bool isWithinNext7Days(DateTime date) {
    final today = DateTime.now();
    final nextWeek = today.add(const Duration(days: 7));
    return date.isAfter(today) && date.isBefore(nextWeek);
  }
  
  // Check if date is today
  static bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && 
           date.month == today.month && 
           date.day == today.day;
  }
}

// Validation Helpers
class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? validateTimeRange(TimeOfDay start, TimeOfDay end) {
    if (end.hour < start.hour || 
        (end.hour == start.hour && end.minute <= start.minute)) {
      return 'End time must be after start time';
    }
    return null;
  }
}

// ID Generator
class IdGenerator {
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}