import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/assignment_service.dart';
import '../widgets/assignment_card.dart';
import '../widgets/assignment_form.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});


  void _openForm(BuildContext context, {assignment}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AssignmentForm(
        assignment: assignment,
        onSave: (newAssignment) {
          final service =
              Provider.of<AssignmentService>(context, listen: false);

          if (assignment == null) {
            service.addAssignment(newAssignment);
          } else {
            service.updateAssignment(newAssignment);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<AssignmentService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),

      body: service.assignments.isEmpty
          ? const Center(child: Text('No assignments yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: service.assignments.isEmpty
          ? const Center(child: Text('No assignments yet'))
          : ListView.builder(

              itemCount: service.assignments.length,
              itemBuilder: (context, index) {
                final assignment = service.assignments[index];
                return AssignmentCard(
                  assignment: assignment,
                  onToggle: () => service.toggleCompleted(assignment.id),
                  onDelete: () => service.deleteAssignment(assignment.id),
                  onEdit: () async {
                    final updated = await showDialog<Assignment>(
                      context: context,
                      builder: (_) => AssignmentForm(assignment: assignment),
                    );
                    if (updated != null) service.updateAssignment(updated);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newAssignment = await showDialog<Assignment>(
            context: context,
            builder: (_) => const AssignmentForm(),
          );
          if (newAssignment != null) service.addAssignment(
            title: newAssignment.title,
            course: newAssignment.course,
            dueDate: newAssignment.dueDate,
            type: newAssignment.type,
          );
        },
      ),
    );
  }
}
