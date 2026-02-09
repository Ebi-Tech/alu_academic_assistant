import 'package:flutter/material.dart';
import '../services/assignment_service.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Checkbox(
          value: assignment.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: assignment.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text(
          '${assignment.course} • Due ${assignment.dueDate.toLocal().toIso8601String().split("T")[0]}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(assignment.type),
              backgroundColor: assignment.type == 'Formative'
                  ? Colors.blue.shade100
                  : Colors.orange.shade100,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
