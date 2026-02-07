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
                  onToggle: () =>
                      service.toggleCompletion(assignment.id),
                  onDelete: () =>
                      service.deleteAssignment(assignment.id),
                  onEdit: () =>
                      _openForm(context, assignment: assignment),
                );
              },
            ),
    );
  }
}
