class Assignment {
  final String id;
  String title;
  DateTime dueDate;
  String course;
  String? priority; 
  bool isCompleted;
  
  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.course,
    this.priority,
    this.isCompleted = false,
  });
  
  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'course': course,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
  
  // Create from JSON
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']),
      course: json['course'],
      priority: json['priority'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}