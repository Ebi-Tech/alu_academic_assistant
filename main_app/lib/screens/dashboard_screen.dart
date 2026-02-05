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
      backgroundColor: ALUColors.primaryDark, // Dark blue from sample
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: ALUColors.textWhite,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent like sample
        elevation: 0,
        iconTheme: const IconThemeData(color: ALUColors.textWhite),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.notifications_outlined, color: ALUColors.textWhite),
          ),
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.person_outline, color: ALUColors.textWhite),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GREETING SECTION - Like sample "Hello Alex At Risk"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ALUColors.cardDark, // Dark card background
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ALUColors.primaryBlue.withOpacity(0.3),
                    ALUColors.secondaryBlue.withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ALUColors.warningRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ALUColors.warningRed),
                        ),
                        child: const Text(
                          "AT RISK",
                          style: TextStyle(
                            color: ALUColors.warningRed,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Student",
                        style: TextStyle(
                          color: ALUColors.textGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Welcome back, Alex!",
                    style: TextStyle(
                      color: ALUColors.textWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Today, February 3rd 2026 • Week 5",
                    style: TextStyle(
                      color: ALUColors.textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. ATTENDANCE WARNING INDICATOR - Like sample "AT RISK WARNING"
            AttendanceIndicator(percentage: attendanceRate),

            const SizedBox(height: 20),

            // 3. QUICK STATS - Creative design inspired by sample
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Academic Week",
                    value: "Week 5",
                    icon: Icons.calendar_month,
                    color: ALUColors.progressBlue,
                    progress: 5/15, // 5 out of 15 weeks
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: "Assignments",
                    value: "$pendingAssignmentsCount Pending",
                    icon: Icons.assignment_outlined,
                    color: ALUColors.warningYellow,
                    progress: pendingAssignmentsCount/10, // Assuming max 10
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 4. ATTENDANCE PROGRESS - Like sample "75% 60% 63%"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ALUColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attendance Progress",
                    style: TextStyle(
                      color: ALUColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAttendanceProgress("Overall", attendanceRate/100, ALUColors.progressBlue),
                  const SizedBox(height: 8),
                  _buildAttendanceProgress("This Month", 0.60, ALUColors.warningYellow),
                  const SizedBox(height: 8),
                  _buildAttendanceProgress("This Week", 0.63, ALUColors.successGreen),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 5. TODAY'S SCHEDULE SECTION - Creative design
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Academic Sessions",
                  style: TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: ALUColors.primaryBlue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildSessionTile(
              "Software Engineering",
              "09:00 AM - 11:00 AM",
              "Kigali Hall A",
              "Class",
              ALUColors.progressBlue,
            ),
            _buildSessionTile(
              "Professional Skills (PSL)",
              "02:00 PM - 03:30 PM",
              "Online (Zoom)",
              "PSL Meeting",
              ALUColors.successGreen,
            ),
            _buildSessionTile(
              "Data Structures",
              "04:00 PM - 05:30 PM",
              "Innovation Lab",
              "Mastery Session",
              ALUColors.warningYellow,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: ALUColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: ALUColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceProgress(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ALUColors.textLight,
                fontSize: 14,
              ),
            ),
            Text(
              "${(percentage * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: ALUColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildSessionTile(
    String title,
    String time,
    String location,
    String type,
    Color typeColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ALUColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$time | $location",
                  style: TextStyle(color: ALUColors.textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: typeColor.withOpacity(0.3)),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: typeColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}