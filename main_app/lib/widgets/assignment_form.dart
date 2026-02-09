import 'package:flutter/material.dart';
import '../services/assignment_service.dart';

class AssignmentForm extends StatefulWidget {
  final Assignment? assignment;

  const AssignmentForm({super.key, this.assignment});

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _courseController;
  DateTime _dueDate = DateTime.now();

  late TextEditingController _titleController;
  late TextEditingController _courseController;
  DateTime? _dueDate;
  String _type = 'Formative';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment?.title ?? '');
    _courseController = TextEditingController(text: widget.assignment?.course ?? '');
    _dueDate = widget.assignment?.dueDate ?? DateTime.now();
    _type = widget.assignment?.type ?? 'Formative';
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
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
    _titleController =
        TextEditingController(text: widget.assignment?.title ?? '');
    _courseController =
        TextEditingController(text: widget.assignment?.course ?? '');
    _dueDate = widget.assignment?.dueDate;
    _type = widget.assignment?.type ?? 'Formative';
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      final assignment = Assignment(
        id: widget.assignment?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        course: _courseController.text,
        dueDate: _dueDate!,
        type: _type,
        isCompleted: widget.assignment?.isCompleted ?? false,
      );

      widget.onSave(assignment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.assignment == null ? 'Add Assignment' : 'Edit Assignment'),
      content: Form(
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(labelText: 'Course'),
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            Text(
              widget.assignment == null
                  ? 'Add Assignment'
                  : 'Edit Assignment',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _titleController,
              decoration:
                  const InputDecoration(labelText: 'Assignment Title'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _courseController,
              decoration:
                  const InputDecoration(labelText: 'Course Name'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Due: ${_dueDate.toLocal().toIso8601String().split("T")[0]}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDueDate,
                Text(
                  _dueDate == null
                      ? 'Pick Due Date'
                      : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _type,
              items: ['Formative', 'Summative']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => _type = val!),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                Assignment(
                  id: widget.assignment?.id ?? DateTime.now().toString(),
                  title: _titleController.text,
                  course: _courseController.text,
                  dueDate: _dueDate,
                  type: _type,
                  isCompleted: widget.assignment?.isCompleted ?? false,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
              items: const [
                DropdownMenuItem(
                    value: 'Formative', child: Text('Formative')),
                DropdownMenuItem(
                    value: 'Summative', child: Text('Summative')),
              ],
              onChanged: (v) => setState(() => _type = v!),
              decoration:
                  const InputDecoration(labelText: 'Assignment Type'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
