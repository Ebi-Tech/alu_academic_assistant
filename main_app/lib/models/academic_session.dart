class AcademicSession {
  final String id;
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String? location;
  String sessionType; // 'Class', 'Mastery Session', 'Study Group', 'PSL Meeting'
  bool isPresent;
  
  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.sessionType,
    this.isPresent = false,
  });
  
  // Check if end time is after start time
  bool get isValidTime => endTime.hour > startTime.hour || 
                         (endTime.hour == startTime.hour && endTime.minute > startTime.minute);
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'location': location,
      'sessionType': sessionType,
      'isPresent': isPresent,
    };
  }
  
  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    return AcademicSession(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(
        hour: json['startTime']['hour'],
        minute: json['startTime']['minute'],
      ),
      endTime: TimeOfDay(
        hour: json['endTime']['hour'],
        minute: json['endTime']['minute'],
      ),
      location: json['location'],
      sessionType: json['sessionType'],
      isPresent: json['isPresent'] ?? false,
    );
  }
}