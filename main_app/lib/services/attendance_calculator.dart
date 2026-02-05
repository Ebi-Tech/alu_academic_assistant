class AttendanceCalculator {
  // This is to calculate the percentage of the attendance.
  static double calculatePercentage(int present, int total) {
    if (total == 0) return 100.0; // Avoid division by zero
    return (present / total) * 100;
  }

  // This is to check if the student is at risk if they're below 75%.
  static bool isAtRisk(double percentage) {
    return percentage < 75.0;
  }
}
