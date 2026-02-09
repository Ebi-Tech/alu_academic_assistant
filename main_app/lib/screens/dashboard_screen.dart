import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/attendance_indicator.dart';
import '../widgets/week_summary_card.dart';
import '../services/assignment_service.dart';
import '../services/session_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ALUColors.primaryDark,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
      body: Consumer2<AssignmentService, SessionService>(
        builder: (context, assignmentService, sessionService, child) {
          // Calculate dynamic data
          final today = DateTime.now();
          final academicWeek = DateHelpers.getAcademicWeek(today);
          final attendanceRate = sessionService.attendancePercentage;
          final todaysSessions = sessionService.todaysSessions;
          final assignmentsDueNext7Days = assignmentService.assignmentsDueNext7Days;
          final pendingAssignments = assignmentService.pendingAssignments.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. DATE & WEEK SECTION - Now dynamic
                Text(
                  DateHelpers.formatDate(today),
                  style: TextStyle(color: ALUColors.textGrey, fontSize: 14),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Welcome back, Student!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. ATTENDANCE WARNING INDICATOR - Now dynamic
                AttendanceIndicator(percentage: attendanceRate * 100),

                const SizedBox(height: 20),

                // 3. SUMMARY CARDS - Now dynamic
                Row(
                  children: [
                    WeekSummaryCard(
                      title: "Academic Week",
                      value: "Week $academicWeek",
                      icon: Icons.calendar_month,
                      accentColor: ALUColors.warningYellow,
                      isDarkMode: true,
                    ),
                    const SizedBox(width: 12),
                    WeekSummaryCard(
                      title: "Assignments",
                      value: "$pendingAssignments Pending",
                      icon: Icons.assignment_outlined,
                      accentColor: Colors.orangeAccent,
                      isDarkMode: true,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 4. ASSIGNMENTS DUE IN NEXT 7 DAYS (New Section)
                if (assignmentsDueNext7Days.isNotEmpty) ...[
                  const Text(
                    "Upcoming Assignments (Next 7 Days)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...assignmentsDueNext7Days.take(3).map((assignment) => 
                    _buildAssignmentTile(
                      assignment.title,
                      assignment.course,
                      assignment.dueDate,
                      assignment.priority,
                    )
                  ).toList(),
                  if (assignmentsDueNext7Days.length > 3) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to assignments screen
                          // We'll implement this later
                        },
                        child: Text(
                          "View all ${assignmentsDueNext7Days.length} assignments",
                          style: TextStyle(color: ALUColors.primaryBlue),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                ],

                // 5. TODAY'S SCHEDULE SECTION - Now dynamic
                const Text(
                  "Today's Academic Sessions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),

                if (todaysSessions.isNotEmpty) ...[
                  ...todaysSessions.map((session) => 
                    _buildSessionTile(
                      session.title,
                      session.startTime,
                      session.endTime,
                      session.location ?? 'No location',
                      session.sessionType,
                      session.isPresent,
                      () => sessionService.toggleAttendance(session.id),
                    )
                  ).toList(),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Center(
                      child: Text(
                        "No sessions scheduled for today",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // 6. ADD SAMPLE DATA BUTTON (For testing - remove in final version)
                if (assignmentService.assignments.isEmpty || sessionService.sessions.isEmpty) ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        assignmentService.addSampleData();
                        sessionService.addSampleSessions();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ALUColors.primaryBlue,
                      ),
                      child: const Text('Load Sample Data'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignmentTile(
    String title,
    String course,
    DateTime dueDate,
    String? priority,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ALUColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment, color: ALUColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$course • Due: ${dueDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          if (priority != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                priority,
                style: TextStyle(color: _getPriorityColor(priority), fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionTile(
    String title,
    TimeOfDay startTime,
    TimeOfDay endTime,
    String location,
    String type,
    bool isPresent,
    VoidCallback onToggleAttendance,
  ) {
    final timeText = '${_formatTime(startTime)} - ${_formatTime(endTime)}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getSessionTypeColor(type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school, color: _getSessionTypeColor(type), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$timeText | $location",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
              const SizedBox(height: 8),
              Switch(
                value: isPresent,
                onChanged: (_) => onToggleAttendance(),
                activeColor: ALUColors.successGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return ALUColors.warningRed;
      case 'Medium':
        return ALUColors.warningYellow;
      case 'Low':
        return ALUColors.successGreen;
      default:
        return ALUColors.textGrey;
    }
  }

  Color _getSessionTypeColor(String type) {
    switch (type) {
      case 'Class':
        return ALUColors.primaryBlue;
      case 'Mastery Session':
        return ALUColors.successGreen;
      case 'Study Group':
        return ALUColors.warningYellow;
      case 'PSL Meeting':
        return ALUColors.progressBlue;
      default:
        return ALUColors.textGrey;
    }
  }
}