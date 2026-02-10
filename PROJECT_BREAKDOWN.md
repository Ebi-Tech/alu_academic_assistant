# ALU Academic Assistant - Complete Project Breakdown

## Project Overview
This is a Flutter mobile application designed for ALU (African Leadership University) students to manage their academic life. The app helps students track assignments, manage their class schedules, and monitor attendance. It features a dark theme with ALU's official blue color scheme.

---

## 📁 Project Structure

```
alu_academic_assistant/
├── main_app/                    # Main Flutter application
│   ├── lib/                     # Source code
│   ├── test/                    # Test files
│   ├── android/                 # Android platform files
│   ├── ios/                     # iOS platform files
│   ├── web/                     # Web platform files
│   ├── linux/                   # Linux platform files
│   ├── macos/                   # macOS platform files
│   ├── windows/                 # Windows platform files
│   └── pubspec.yaml             # Dependencies configuration
└── README.md                    # Root README
```

---

## 📄 File-by-File Breakdown

### **Configuration Files**

#### 1. `pubspec.yaml`
**Location:** `main_app/pubspec.yaml`  
**Purpose:** Defines project metadata, dependencies, and Flutter configuration.

**Key Dependencies:**
- `provider: ^6.0.5` - State management
- `uuid: 4.5.2` - Unique ID generation
- `intl: ^0.19.0` - Internationalization and date formatting
- `path_provider: ^2.1.3` - File system path access

**Snippet:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  uuid: 4.5.2
  cupertino_icons: ^1.0.8
  intl: ^0.19.0
  path_provider: ^2.1.3
```

---

#### 2. `analysis_options.yaml`
**Location:** `main_app/analysis_options.yaml`  
**Purpose:** Configures Dart analyzer and linting rules for code quality.

**Function:** Enables Flutter's recommended lints to catch common errors and enforce best practices.

---

#### 3. `devtools_options.yaml`
**Location:** `main_app/devtools_options.yaml`  
**Purpose:** Configures Dart & Flutter DevTools extension settings.

---

### **Main Application Files**

#### 4. `lib/main.dart`
**Location:** `main_app/lib/main.dart`  
**Purpose:** Application entry point and root widget configuration.

**Key Functions:**
- Initializes the app with Provider for state management
- Sets up dark theme with ALU color scheme
- Implements bottom navigation (Dashboard, Assignments, Schedule)
- Configures Material Design 3 theme

**Code Snippet:**
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssignmentService()),
        ChangeNotifierProvider(create: (_) => SessionService()),
      ],
      child: const ALUAcademicAssistant(),
    ),
  );
}
```

**Theme Configuration:**
- Primary color: ALU Blue (#0033A0)
- Dark background: #0A192F
- Card colors: Dark theme variants
- Forces dark mode throughout the app

---

### **Models (Data Structures)**

#### 5. `lib/models/assignment.dart`
**Location:** `main_app/lib/models/assignment.dart`  
**Purpose:** Data model representing a student assignment.

**Properties:**
- `id` (String) - Unique identifier
- `title` (String) - Assignment name
- `dueDate` (DateTime) - Deadline
- `course` (String) - Course name
- `priority` (String?) - Optional: 'High', 'Medium', 'Low'
- `isCompleted` (bool) - Completion status

**Key Methods:**
- `toJson()` - Serializes to JSON for storage
- `fromJson()` - Deserializes from JSON

**Code Snippet:**
```dart
class Assignment {
  final String id;
  String title;
  DateTime dueDate;
  String course;
  String? priority;
  bool isCompleted;
  
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
}
```

---

#### 6. `lib/models/academic_session.dart`
**Location:** `main_app/lib/models/academic_session.dart`  
**Purpose:** Represents a class, mastery session, study group, or PSL meeting.

**Properties:**
- `id` (String) - Unique identifier
- `title` (String) - Session name
- `date` (DateTime) - Session date
- `startTime` (TimeOfDay) - Start time
- `endTime` (TimeOfDay) - End time
- `location` (String?) - Optional location
- `sessionType` (String) - Type of session
- `isPresent` (bool) - Attendance status

**Key Features:**
- Validates that end time is after start time
- Supports JSON serialization/deserialization

**Code Snippet:**
```dart
class AcademicSession {
  final String id;
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String? location;
  String sessionType;
  bool isPresent;
  
  bool get isValidTime => endTime.hour > startTime.hour || 
                         (endTime.hour == startTime.hour && endTime.minute > startTime.minute);
}
```

---

#### 7. `lib/models/attendance_record.dart`
**Location:** `main_app/lib/models/attendance_record.dart`  
**Purpose:** Historical record of attendance for a session.

**Properties:**
- `id` (String) - Unique identifier
- `date` (DateTime) - Date of session
- `sessionId` (String) - Reference to session
- `sessionTitle` (String) - Session name
- `wasPresent` (bool) - Attendance status
- `sessionType` (String) - Type of session

**Static Methods:**
- `calculatePercentage()` - Calculates attendance percentage from records
- `isBelowThreshold()` - Checks if attendance is below 75%

**Code Snippet:**
```dart
static double calculatePercentage(List<AttendanceRecord> records) {
  if (records.isEmpty) return 1.0;
  final presentCount = records.where((record) => record.wasPresent).length;
  return presentCount / records.length;
}
```

---

### **Services (Business Logic)**

#### 8. `lib/services/assignment_service.dart`
**Location:** `main_app/lib/services/assignment_service.dart`  
**Purpose:** Manages assignment CRUD operations and persistence.

**Key Features:**
- Extends `ChangeNotifier` for state management
- Persists data to JSON file using `JsonStorageService`
- Provides computed properties (pending assignments, due next 7 days)

**Methods:**
- `addAssignment()` - Add new assignment
- `updateAssignment()` - Update existing assignment
- `deleteAssignment()` - Remove assignment
- `toggleCompleted()` - Mark as complete/incomplete
- `_loadFromStorage()` - Load from JSON file on startup
- `_saveToStorage()` - Save to JSON file after changes

**Code Snippet:**
```dart
class AssignmentService extends ChangeNotifier {
  List<Assignment> _assignments = [];
  final JsonStorageService _storage = JsonStorageService();
  
  List<Assignment> get assignmentsDueNext7Days {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return _assignments.where((a) => 
      !a.isCompleted && 
      a.dueDate.isAfter(now) && 
      a.dueDate.isBefore(nextWeek)
    ).toList();
  }
}
```

---

#### 9. `lib/services/session_service.dart`
**Location:** `main_app/lib/services/session_service.dart`  
**Purpose:** Manages academic sessions and attendance tracking.

**Key Features:**
- Manages list of academic sessions
- Tracks attendance for each session
- Calculates overall attendance percentage
- Filters today's sessions

**Methods:**
- `addSession()` - Add new session
- `updateSession()` - Update existing session
- `deleteSession()` - Remove session
- `toggleAttendance()` - Toggle presence status
- `_loadFromStorage()` - Load sessions from JSON
- `_saveToStorage()` - Save sessions to JSON

**Code Snippet:**
```dart
class SessionService extends ChangeNotifier {
  List<AcademicSession> _sessions = [];
  
  double get attendancePercentage {
    if (_sessions.isEmpty) return 1.0;
    final presentSessions = _sessions.where((s) => s.isPresent).length;
    return presentSessions / _sessions.length;
  }
  
  List<AcademicSession> get todaysSessions {
    return _sessions.where((session) => DateHelpers.isToday(session.date)).toList();
  }
}
```

---

#### 10. `lib/services/json_storage_service.dart`
**Location:** `main_app/lib/services/json_storage_service.dart`  
**Purpose:** Handles file-based JSON persistence using path_provider.

**Key Features:**
- Singleton pattern for single instance
- Saves/loads data to app's documents directory
- Handles file existence checks
- Provides file listing for debugging

**Methods:**
- `saveToFile()` - Write JSON data to file
- `loadFromFile()` - Read JSON data from file
- `fileExists()` - Check if file exists
- `deleteFile()` - Remove file
- `listFiles()` - List all files in storage directory

**Code Snippet:**
```dart
class JsonStorageService {
  static final JsonStorageService _instance = JsonStorageService._internal();
  factory JsonStorageService() => _instance;
  
  Future<void> saveToFile(String fileName, List<Map<String, dynamic>> data) async {
    final file = await _getLocalFile(fileName);
    final jsonString = jsonEncode(data);
    await file.writeAsString(jsonString);
  }
  
  Future<List<Map<String, dynamic>>> loadFromFile(String fileName) async {
    final file = await _getLocalFile(fileName);
    if (await file.exists()) {
      final contents = await file.readAsString();
      if (contents.trim().isNotEmpty) {
        return jsonDecode(contents).cast<Map<String, dynamic>>();
      }
    }
    return [];
  }
}
```

---

#### 11. `lib/services/attendance_calculator.dart`
**Location:** `main_app/lib/services/attendance_calculator.dart`  
**Purpose:** Utility class for attendance calculations.

**Static Methods:**
- `calculatePercentage()` - Calculates attendance percentage
- `isAtRisk()` - Checks if attendance is below 75% threshold

**Code Snippet:**
```dart
class AttendanceCalculator {
  static double calculatePercentage(int present, int total) {
    if (total == 0) return 100.0;
    return (present / total) * 100;
  }
  
  static bool isAtRisk(double percentage) {
    return percentage < 75.0;
  }
}
```

---

### **Screens (UI Pages)**

#### 12. `lib/screens/dashboard_screen.dart`
**Location:** `main_app/lib/screens/dashboard_screen.dart`  
**Purpose:** Main dashboard showing overview of academic status.

**Key Features:**
- Displays current date and academic week
- Shows attendance warning indicator
- Lists upcoming assignments (next 7 days)
- Shows today's academic sessions
- Displays summary cards (Academic Week, Pending Assignments)

**UI Components:**
- Attendance indicator with warning if below 75%
- Week summary cards
- Assignment tiles with priority badges
- Session tiles with attendance toggles
- Sample data button for testing

**Code Snippet:**
```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AssignmentService, SessionService>(
      builder: (context, assignmentService, sessionService, child) {
        final attendanceRate = sessionService.attendancePercentage;
        final todaysSessions = sessionService.todaysSessions;
        final assignmentsDueNext7Days = assignmentService.assignmentsDueNext7Days;
        
        return SingleChildScrollView(
          child: Column(
            children: [
              AttendanceIndicator(percentage: attendanceRate * 100),
              WeekSummaryCard(...),
              // Assignment list
              // Today's sessions list
            ],
          ),
        );
      },
    );
  }
}
```

---

#### 13. `lib/screens/assignments_screen.dart`
**Location:** `main_app/lib/screens/assignments_screen.dart`  
**Purpose:** Full list view of all assignments with CRUD operations.

**Key Features:**
- Lists all assignments sorted by due date
- Floating action button to add new assignment
- Edit and delete functionality
- Empty state when no assignments
- Pending assignments counter in app bar

**UI Components:**
- `AssignmentCard` widgets for each assignment
- Modal bottom sheet for add/edit forms
- Delete confirmation dialog
- Empty state with helpful message

**Code Snippet:**
```dart
class AssignmentsScreen extends StatelessWidget {
  void _openAddForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AssignmentForm(
        onSave: (assignment) {
          Provider.of<AssignmentService>(context, listen: false)
              .addAssignment(assignment);
        },
      ),
    );
  }
}
```

---

#### 14. `lib/screens/schedule_screen.dart`
**Location:** `main_app/lib/screens/schedule_screen.dart`  
**Purpose:** Weekly schedule view with session timeline.

**Key Features:**
- Horizontal date picker for week navigation
- Week overview statistics cards
- Timeline view of sessions for selected day
- Session type color coding
- "LIVE" indicator for current sessions
- Attendance marking per session

**UI Components:**
- Week overview cards (total sessions, today's sessions)
- Scrollable date selector
- Timeline with time markers
- Session cards with type badges
- Empty state for days with no sessions

**Code Snippet:**
```dart
class ScheduleScreen extends StatefulWidget {
  // Sample sessions data (hardcoded for demo)
  final List<AcademicSession> _allSessions = [
    AcademicSession(
      id: '1',
      title: 'Software Engineering',
      date: _getNextWeekday(DateTime.monday),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      location: 'Kigali Hall A',
      sessionType: 'Class',
    ),
    // ... more sessions
  ];
}
```

**Note:** Currently uses hardcoded sample data. Should be integrated with `SessionService` for persistence.

---

### **Widgets (Reusable UI Components)**

#### 15. `lib/widgets/assignment_card.dart`
**Location:** `main_app/lib/widgets/assignment_card.dart`  
**Purpose:** Reusable card widget for displaying an assignment.

**Features:**
- Checkbox for completion status
- Title, course, and due date display
- Priority badge with color coding
- Edit and delete action buttons
- Strikethrough text when completed

**Code Snippet:**
```dart
class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ALUColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(value: assignment.isCompleted, onChanged: (_) => onToggle()),
          Expanded(child: Column(...)), // Assignment details
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
```

---

#### 16. `lib/widgets/assignment_form.dart`
**Location:** `main_app/lib/widgets/assignment_form.dart`  
**Purpose:** Form widget for adding/editing assignments.

**Features:**
- Text fields for title and course (required)
- Date picker for due date
- Optional priority dropdown (High/Medium/Low/None)
- Form validation
- Save and cancel buttons
- Modal bottom sheet presentation

**Code Snippet:**
```dart
class AssignmentForm extends StatefulWidget {
  final Assignment? assignment; // null for add, populated for edit
  final Function(Assignment) onSave;
  
  // Form includes:
  // - Title field (required)
  // - Course field (required)
  // - Due date picker
  // - Priority dropdown (optional)
}
```

---

#### 17. `lib/widgets/attendance_indicator.dart`
**Location:** `main_app/lib/widgets/attendance_indicator.dart`  
**Purpose:** Visual indicator showing attendance percentage with warning.

**Features:**
- Gradient background (red if at risk, blue if good)
- Warning icon for low attendance
- "FIX NOW" button when below 75%
- Displays percentage prominently

**Code Snippet:**
```dart
class AttendanceIndicator extends StatelessWidget {
  final double percentage;
  
  @override
  Widget build(BuildContext context) {
    bool atRisk = percentage < 75;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: atRisk
              ? [ALUColors.warningRed, ALUColors.warningRed.withOpacity(0.8)]
              : [ALUColors.primaryBlue, ALUColors.primaryBlue.withOpacity(0.8)],
        ),
      ),
      child: Row(
        children: [
          Icon(atRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline),
          Text("${percentage.toStringAsFixed(1)}% Attendance"),
        ],
      ),
    );
  }
}
```

---

#### 18. `lib/widgets/week_summary_card.dart`
**Location:** `main_app/lib/widgets/week_summary_card.dart`  
**Purpose:** Reusable summary card for displaying key metrics.

**Features:**
- Icon, title, and value display
- Customizable accent color
- Dark mode support
- Used for Academic Week and Pending Assignments

**Code Snippet:**
```dart
class WeekSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final bool isDarkMode;
  
  // Displays icon, title, and value in a styled card
}
```

---

### **Utilities**

#### 19. `lib/utils/constants.dart`
**Location:** `main_app/lib/utils/constants.dart`  
**Purpose:** Centralized constants for colors, app settings, and configuration.

**Key Classes:**
- `ALUColors` - Color palette matching ALU branding
- `AppConstants` - App-wide constants (thresholds, session types, priorities)

**Color Palette:**
```dart
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
}
```

**App Constants:**
```dart
class AppConstants {
  static const String appName = 'ALU Academic Assistant';
  static const double attendanceThreshold = 0.75;
  static const int academicWeeks = 15;
  static const List<String> sessionTypes = ['Class', 'Mastery Session', ...];
  static const List<String> priorityLevels = ['High', 'Medium', 'Low'];
}
```

---

#### 20. `lib/utils/helpers.dart`
**Location:** `main_app/lib/utils/helpers.dart`  
**Purpose:** Utility functions for date/time operations and validation.

**Key Classes:**
- `DateHelpers` - Date formatting and calculations
- `Validators` - Form validation helpers
- `IdGenerator` - Unique ID generation

**Date Helpers:**
```dart
class DateHelpers {
  // Calculate academic week (semester starts Jan 20, 2025)
  static int getAcademicWeek(DateTime date) {
    final semesterStart = DateTime(2025, 1, 20);
    final difference = date.difference(semesterStart).inDays;
    return (difference ~/ 7) + 1;
  }
  
  // Format date: "Monday, January 20, 2025"
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
  
  // Check if date is today
  static bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && 
           date.month == today.month && 
           date.day == today.day;
  }
}
```

**Validators:**
```dart
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
```

---

### **Test Files**

#### 21. `lib/test_storage.dart`
**Location:** `main_app/lib/test_storage.dart`  
**Purpose:** Testing utility for JSON storage functionality.

**Function:** Provides debugging output for storage operations, file existence, and data counts. Used during development to verify persistence works correctly.

**Code Snippet:**
```dart
void testStorage() async {
  final assignmentService = AssignmentService();
  final sessionService = SessionService();
  
  await Future.delayed(const Duration(seconds: 2));
  
  final assignmentInfo = await assignmentService.getStorageInfo();
  print('Assignments: ${assignmentInfo['assignmentCount']}');
  
  final sessionInfo = await sessionService.getStorageInfo();
  print('Sessions: ${sessionInfo['sessionCount']}');
}
```

---

#### 22. `test/widget_test.dart`
**Location:** `main_app/test/widget_test.dart`  
**Purpose:** Basic widget test for app smoke testing.

**Test Coverage:**
- Verifies app builds successfully
- Checks Dashboard screen appears
- Validates bottom navigation icons are present

**Code Snippet:**
```dart
testWidgets('ALU Academic Assistant app smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(const ALUAcademicAssistant());
  
  expect(find.text('Dashboard'), findsOneWidget);
  expect(find.byIcon(Icons.dashboard), findsOneWidget);
  expect(find.byIcon(Icons.assignment), findsOneWidget);
  expect(find.byIcon(Icons.calendar_today), findsOneWidget);
});
```

---

## 🔄 Data Flow

1. **App Startup:**
   - `main.dart` initializes `AssignmentService` and `SessionService`
   - Services call `_loadFromStorage()` to read JSON files
   - Data is loaded into memory

2. **User Actions:**
   - User adds/edits/deletes assignment → `AssignmentService` updates list → `_saveToStorage()` writes to JSON
   - User toggles attendance → `SessionService` updates session → `_saveToStorage()` writes to JSON

3. **UI Updates:**
   - Services extend `ChangeNotifier` and call `notifyListeners()`
   - Widgets using `Consumer` rebuild automatically
   - UI reflects latest data

---

## 🎨 Design System

- **Theme:** Dark mode with ALU blue accent
- **Colors:** Consistent palette defined in `ALUColors`
- **Typography:** Material Design 3 with white text on dark backgrounds
- **Components:** Card-based layout with rounded corners (12px radius)

---

## 📱 Platform Support

The app supports:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

Platform-specific files are in respective directories (`android/`, `ios/`, etc.)

---

## 🔧 Key Technologies

- **Flutter:** Cross-platform UI framework
- **Provider:** State management
- **path_provider:** File system access
- **intl:** Date/time formatting
- **JSON:** Data persistence format

---

## 📝 Notes

1. **Storage:** Currently uses JSON file storage via `path_provider`. Data persists in app's documents directory.

2. **Sample Data:** `ScheduleScreen` uses hardcoded sample sessions. Should be migrated to use `SessionService` for consistency.

3. **Empty Methods:** `addSampleData()` and `addSampleSessions()` are stubbed - need implementation.

4. **Attendance:** Currently tracks per-session. Could be enhanced with `AttendanceRecord` model for historical tracking.

---

## 🚀 Future Enhancements

- [ ] Implement sample data generation
- [ ] Integrate ScheduleScreen with SessionService
- [ ] Add historical attendance records
- [ ] Implement notifications for upcoming assignments
- [ ] Add calendar integration
- [ ] Support for recurring sessions
- [ ] Export/import functionality

---

*Generated: Complete project breakdown for ALU Academic Assistant*
