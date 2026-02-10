import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// The Date and Time Helpers
class DateHelpers {
  // We Calculated academic week assuming semester starts Jan 20
  static int getAcademicWeek(DateTime date) {
    final semesterStart = DateTime(2025, 1, 20);
    final difference = date.difference(semesterStart).inDays;
    return (difference ~/ 7) + 1;
  }
  

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
  

  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime);
  }
  

  static bool isWithinNext7Days(DateTime date) {
    final today = DateTime.now();
    final nextWeek = today.add(const Duration(days: 7));
    return date.isAfter(today) && date.isBefore(nextWeek);
  }
  

  static bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && 
           date.month == today.month && 
           date.day == today.day;
  }
}


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


class IdGenerator {
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}