import 'package:flutter/material.dart';
import 'package:main_app/models/assignment.dart';
import 'package:provider/provider.dart';
import '../services/assignment_service.dart';
import '../widgets/assignment_card.dart';
import '../widgets/assignment_form.dart';
import '../utils/constants.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ALUColors.primaryDark,
      appBar: AppBar(
        title: const Text(
          'Assignments',
          style: TextStyle(color: ALUColors.textWhite),
        ),
        backgroundColor: ALUColors.primaryDark,
        elevation: 0,
        actions: [
          Consumer<AssignmentService>(
            builder: (context, service, child) {
              final pendingCount = service.pendingAssignments.length;
              return Chip(
                label: Text('$pendingCount Pending'),
                backgroundColor: ALUColors.primaryBlue.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.white),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<AssignmentService>(
        builder: (context, service, child) {
          if (service.assignments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: ALUColors.textGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No assignments yet',
                    style: TextStyle(
                      color: ALUColors.textGrey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first assignment',
                    style: TextStyle(
                      color: ALUColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _openAddForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ALUColors.primaryBlue,
                    ),
                    child: const Text('Add Sample Data'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: service.assignments.length,
            itemBuilder: (context, index) {
              final assignment = service.assignments[index];
              return AssignmentCard(
                assignment: assignment,
                onToggle: () => service.toggleCompleted(assignment.id),
                onEdit: () => _openEditForm(context, assignment),
                onDelete: () => _showDeleteDialog(context, assignment, service),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddForm(context),
        backgroundColor: ALUColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _openAddForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ALUColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AssignmentForm(
        onSave: (assignment) {
          Provider.of<AssignmentService>(context, listen: false)
              .addAssignment(assignment);
        },
      ),
    );
  }

  void _openEditForm(BuildContext context, Assignment assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ALUColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AssignmentForm(
        assignment: assignment,
        onSave: (updatedAssignment) {
          Provider.of<AssignmentService>(context, listen: false)
              .updateAssignment(updatedAssignment);
        },
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Assignment assignment,
    AssignmentService service,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ALUColors.cardDark,
        title: Text(
          'Delete Assignment',
          style: TextStyle(color: ALUColors.textWhite),
        ),
        content: Text(
          'Are you sure you want to delete "${assignment.title}"?',
          style: TextStyle(color: ALUColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              service.deleteAssignment(assignment.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
