import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../utils/constants.dart';

class AssignmentForm extends StatefulWidget {
  final Assignment? assignment;
  final Function(Assignment) onSave;

  const AssignmentForm({
    super.key,
    this.assignment,
    required this.onSave,
  });

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _courseController;
  late DateTime _dueDate;
  String? _priority; // Now optional: High/Medium/Low or null

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment?.title ?? '');
    _courseController = TextEditingController(text: widget.assignment?.course ?? '');
    _dueDate = widget.assignment?.dueDate ?? DateTime.now();
    _priority = widget.assignment?.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final assignment = Assignment(
        id: widget.assignment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        course: _courseController.text.trim(),
        dueDate: _dueDate,
        priority: _priority, // Now optional
        isCompleted: widget.assignment?.isCompleted ?? false,
      );

      widget.onSave(assignment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.assignment == null ? 'Add Assignment' : 'Edit Assignment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ALUColors.textWhite,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Title (Required)
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Assignment Title *',
                    labelStyle: TextStyle(color: ALUColors.textGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: ALUColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.primaryBlue),
                    ),
                  ),
                  style: TextStyle(color: ALUColors.textWhite),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Course (Required)
                TextFormField(
                  controller: _courseController,
                  decoration: InputDecoration(
                    labelText: 'Course Name *',
                    labelStyle: TextStyle(color: ALUColors.textGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: ALUColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.primaryBlue),
                    ),
                  ),
                  style: TextStyle(color: ALUColors.textWhite),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Course is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Due Date (Required)
                GestureDetector(
                  onTap: _pickDueDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: ALUColors.divider),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: ALUColors.textGrey),
                        const SizedBox(width: 12),
                        Text(
                          'Due: ${_dueDate.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(color: ALUColors.textWhite),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Priority (Optional - Dropdown)
                DropdownButtonFormField<String?>(
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: 'Priority (Optional)',
                    labelStyle: TextStyle(color: ALUColors.textGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: ALUColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.primaryBlue),
                    ),
                  ),
                  style: TextStyle(color: ALUColors.textWhite),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('None'),
                    ),
                    const DropdownMenuItem(
                      value: 'High',
                      child: Text('High'),
                    ),
                    const DropdownMenuItem(
                      value: 'Medium',
                      child: Text('Medium'),
                    ),
                    const DropdownMenuItem(
                      value: 'Low',
                      child: Text('Low'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _priority = value),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ALUColors.primaryBlue,
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
