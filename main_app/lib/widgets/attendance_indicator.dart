import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AttendanceIndicator extends StatelessWidget {
  final double percentage;

  const AttendanceIndicator({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    bool atRisk = percentage < 75;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: atRisk
              ? [ALUColors.warningRed, ALUColors.warningRed.withOpacity(0.8)]
              : [ALUColors.primaryBlue, ALUColors.primaryBlue.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (atRisk ? ALUColors.warningRed : ALUColors.primaryBlue).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            atRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: ALUColors.textWhite,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  atRisk ? "AT RISK WARNING" : "GREAT ATTENDANCE",
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${percentage.toStringAsFixed(1)}% Attendance",
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (atRisk)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "FIX NOW",
                style: TextStyle(
                  color: ALUColors.textWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
