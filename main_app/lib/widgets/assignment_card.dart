import 'package:flutter/material.dart';
import '../models/assignment.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: assignment.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            decoration: assignment.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text(
          '${assignment.course} • Due ${assignment.dueDate.toLocal().toString().split(' ')[0]}',
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
