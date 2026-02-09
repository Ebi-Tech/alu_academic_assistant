import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../utils/constants.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ALUColors.divider),
      ),
      child: Row(
        children: [
          // Checkbox for completion
          Checkbox(
            value: assignment.isCompleted,
            onChanged: (_) => onToggle(),
            activeColor: ALUColors.primaryBlue,
          ),
          
          const SizedBox(width: 12),
          
          // Assignment details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: TextStyle(
                    color: ALUColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: assignment.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  assignment.course,
                  style: TextStyle(
                    color: ALUColors.textGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    color: ALUColors.textLight,
                    fontSize: 12,
                  ),
                ),
                if (assignment.priority != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(assignment.priority!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getPriorityColor(assignment.priority!).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      assignment.priority!,
                      style: TextStyle(
                        color: _getPriorityColor(assignment.priority!),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Action buttons
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: ALUColors.progressBlue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: ALUColors.warningRed),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
