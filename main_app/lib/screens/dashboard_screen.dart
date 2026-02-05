import 'package:flutter/material.dart';
import '../widgets/attendance_indicator.dart';
import '../widgets/week_summary_card.dart';
import '../services/attendance_calculator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int totalSessions = 20;
    const int sessionsPresent = 13;
    const int pendingAssignmentsCount = 5;
    const String currentWeek = "Week 5";

    double attendanceRate = AttendanceCalculator.calculatePercentage(
      sessionsPresent,
      totalSessions,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF000D1D),
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DATE & WEEK SECTION
            const Text(
              "Today, February 3rd 2026",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              "Welcome back, Student!",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 2. ATTENDANCE WARNING INDICATOR
            // When the attendance is less than 75, it'll turn to red.
            AttendanceIndicator(percentage: attendanceRate),

            const SizedBox(height: 20),

            // 3. SUMMARY CARDS
            Row(
              children: [
                WeekSummaryCard(
                  title: "Academic Week",
                  value: currentWeek,
                  icon: Icons.calendar_month,
                  accentColor: const Color(0xFFFFCC00),
                ),
                const SizedBox(width: 12),
                WeekSummaryCard(
                  title: "Assignments",
                  value: "$pendingAssignmentsCount Pending",
                  icon: Icons.assignment_outlined,
                  accentColor: Colors.orangeAccent,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 4. TODAY'S SCHEDULE SECTION
            const Text(
              "Today's Academic Sessions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),

            _buildSessionTile(
              "Software Engineering",
              "09:00 AM - 11:00 AM",
              "Kigali Hall A",
              "Class",
            ),
            _buildSessionTile(
              "Professional Skills (PSL)",
              "02:00 PM - 03:30 PM",
              "Online (Zoom)",
              "PSL Meeting",
            ),
            _buildSessionTile(
              "Data Structures",
              "04:00 PM - 05:30 PM",
              "Innovation Lab",
              "Mastery Session",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(
    String title,
    String time,
    String location,
    String type,
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
              color: const Color(0xFFFFCC00).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: Color(0xFFFFCC00), size: 20),
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
                  "$time | $location",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}
