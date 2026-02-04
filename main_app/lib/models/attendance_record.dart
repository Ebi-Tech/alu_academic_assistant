class AttendanceRecord {
  final String id;
  final DateTime date;
  final String sessionId;
  final String sessionTitle;
  final bool wasPresent;
  final String sessionType;
  
  AttendanceRecord({
    required this.id,
    required this.date,
    required this.sessionId,
    required this.sessionTitle,
    required this.wasPresent,
    required this.sessionType,
  });
  
  // Calculate attendance percentage from a list of records
  static double calculatePercentage(List<AttendanceRecord> records) {
    if (records.isEmpty) return 1.0; // 100% if no records
    
    final presentCount = records.where((record) => record.wasPresent).length;
    return presentCount / records.length;
  }
  
  // Check if attendance is below threshold
  static bool isBelowThreshold(double percentage, [double threshold = 0.75]) {
    return percentage < threshold;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'sessionId': sessionId,
      'sessionTitle': sessionTitle,
      'wasPresent': wasPresent,
      'sessionType': sessionType,
    };
  }
  
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      date: DateTime.parse(json['date']),
      sessionId: json['sessionId'],
      sessionTitle: json['sessionTitle'],
      wasPresent: json['wasPresent'],
      sessionType: json['sessionType'],
    );
  }
}