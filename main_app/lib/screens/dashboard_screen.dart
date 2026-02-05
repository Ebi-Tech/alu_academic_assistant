import 'package:flutter/material.dart';
import '../widgets/attendance_indicator.dart';
import '../widgets/week_summary_card.dart';
import '../services/attendance_calculator.dart';
import '../utils/constants.dart';

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
      backgroundColor: ALUColors.backgroundGray, // Light gray background
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: ALUColors.primaryBlue, // ALU Blue app bar
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
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
              style: TextStyle(color: ALUColors.textLight, fontSize: 14), // Changed to textLight
            ),
            const SizedBox(height: 5),
            Text(
              "Welcome back, Student!",
              style: TextStyle(
                color: ALUColors.textDark, // Changed to textDark
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 2. ATTENDANCE WARNING INDICATOR
            AttendanceIndicator(percentage: attendanceRate),

            const SizedBox(height: 20),

            // 3. SUMMARY CARDS
            Row(
              children: [
                WeekSummaryCard(
                  title: "Academic Week",
                  value: currentWeek,
                  icon: Icons.calendar_month,
                  accentColor: ALUColors.warningYellow, // Use ALU yellow
                ),
                const SizedBox(width: 12),
                WeekSummaryCard(
                  title: "Assignments",
                  value: "$pendingAssignmentsCount Pending",
                  icon: Icons.assignment_outlined,
                  accentColor: ALUColors.secondaryRed, // Use ALU red
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 4. TODAY'S SCHEDULE SECTION
            Text(
              "Today's Academic Sessions",
              style: TextStyle(
                color: ALUColors.textDark, // Changed to textDark
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
        color: Colors.white, // White cards on gray background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ALUColors.primaryBlue.withOpacity(0.1), // ALU blue tint
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school, color: ALUColors.primaryBlue, size: 20), // ALU blue icon
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ALUColors.textDark, // Changed to textDark
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$time | $location",
                  style: TextStyle(color: ALUColors.textLight, fontSize: 13), // Changed to textLight
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ALUColors.primaryBlue.withOpacity(0.1), // ALU blue tint
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: ALUColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: ALUColors.primaryBlue, // ALU blue text
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
