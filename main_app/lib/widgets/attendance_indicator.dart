import 'package:flutter/material.dart';

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
        color: atRisk ? const Color(0xFFD32F2F) : const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            atRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(
            atRisk
                ? "AT RISK WARNING: ${percentage.toStringAsFixed(1)}%"
                : "Attendance: ${percentage.toStringAsFixed(1)}%",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
