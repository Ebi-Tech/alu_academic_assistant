import 'package:flutter/material.dart';
import '../utils/constants.dart';

class WeekSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final bool isDarkMode;

  const WeekSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.accentColor = ALUColors.warningYellow,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? ALUColors.cardLight.withOpacity(0.3) 
              : ALUColors.backgroundGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? ALUColors.divider : Colors.grey.shade300,
          ),
          boxShadow: isDarkMode 
              ? [] 
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isDarkMode ? ALUColors.textGrey : ALUColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isDarkMode ? ALUColors.textWhite : ALUColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
