import 'package:flutter/material.dart';
import 'src/DatabaseHelper.dart';
import 'src/job.dart';

class EditJobScreen extends StatefulWidget {
  final Job job;

  const EditJobScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String selectedStatus;
  late String selectedPriority;
  bool _isSaving = false;

  // Fill textboxes with exisitng data
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job.title);
    _descriptionController = TextEditingController(
      text: widget.job.description,
    );
    selectedStatus = widget.job.status;
    selectedPriority = widget.job.priority;
  }

  // Validate changes when saving
  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job title cannot be empty')),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty')),
      );
      return;
    }

    // Save changes method
    setState(() {
      _isSaving = true;
    });

    try {
      final updatedJob = Job(
        id: widget.job.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: selectedPriority,
        status: selectedStatus,
        syncStatus: 'pending',
        createdAt: widget.job.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseHelper.instance.updateJob(updatedJob.toMap());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('job updated')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating job: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Delete confirmation functionality
  Future<void> _deleteJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
         ),
      ],
    ),
  );

  if (confirmed == true) {
    try {
      await DatabaseHelper.instance.deleteJob(widget.job.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('job deleted')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting job: $e')),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title bar
      appBar: AppBar(title: const Text('Edit Job')),

  
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Job title box
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.work),
              ),
            ),
            const SizedBox(height: 20),

            // Description box
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            // Task priority dropdown
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: 'priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Job status dropdown
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.assignment),
              ),
              items: const [
                DropdownMenuItem(value: 'open', child: Text('Open')),
                DropdownMenuItem(
                  value: 'in-progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(value: 'closed', child: Text('Closed')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Save changes button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isSaving
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save Changes'),
            ),
            const SizedBox(height: 15),

            // Cancel button
            OutlinedButton(
              onPressed: _isSaving ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 15),  

            // Delete button
            OutlinedButton.icon(
            onPressed: _deleteJob,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              foregroundColor: Colors.red,
            ),
            icon: const Icon(Icons.delete),
            label: const Text('Delete Job'),
            ),
          ],
        ),
      ),
    );
  }

  // Free up memory when closed
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
