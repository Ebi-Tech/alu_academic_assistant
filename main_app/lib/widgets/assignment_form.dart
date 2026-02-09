import 'package:flutter/material.dart';
import '../models/assignment.dart';

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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
                    labelStyle: const TextStyle(color: Color(0xFFA0AEC0)),
                    filled: true,
                    fillColor: const Color(0xFF2D3748).withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A5568)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0033A0), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A5568)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  style: const TextStyle(color: Colors.white),
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
                    labelStyle: const TextStyle(color: Color(0xFFA0AEC0)),
                    filled: true,
                    fillColor: const Color(0xFF2D3748).withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A5568)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0033A0), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A5568)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  style: const TextStyle(color: Colors.white),
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
                      color: const Color(0xFF2D3748).withOpacity(0.3),
                      border: Border.all(color: const Color(0xFF4A5568)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFFA0AEC0)),
                        const SizedBox(width: 12),
                        Text(
                          'Due: ${_dueDate.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white),
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
                    labelStyle: const TextStyle(color: Color(0xFFA0AEC0)),
                    filled: true,
                    fillColor: const Color(0xFF2D3748).withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A5568)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A5568)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0033A0)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: const Color(0xFF2D3748),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFA0AEC0)),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        'None',
                        style: TextStyle(color: Color(0xFFA0AEC0)),
                      ),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'High',
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD32F2F),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'High',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'Medium',
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFC72C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Medium',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'Low',
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF43B02A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Low',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
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
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFA0AEC0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0033A0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
