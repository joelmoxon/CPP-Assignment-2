import 'package:flutter/material.dart';
import 'src/database_helper.dart';
import 'src/job.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({Key? key}) : super(key: key);

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String selectedPriority = 'medium';
  bool _isSaving = false;

  Future<void> _saveJob() async {
    // Validate job title box
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a job title')));
      return;
    }

    // Validate description box
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }
    // Trigger save button uploading state
    setState(() {
      _isSaving = true;
    });

    try {
      // Create job
      final job = Job(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: selectedPriority,
        status: 'open',
        syncStatus: 'pending',
        createdAt: DateTime.now().toIso8601String(),
      );

      // Save to database
      final jobId = await DatabaseHelper.instance.insertJob(job.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job $jobId created succesfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error saving job:$e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving job: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title bar
      appBar: AppBar(title: const Text('Create New Job')),

      // Main body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Job title text field
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

            // Description text field
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

            // Priority dropdown button
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
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
            const SizedBox(height: 30),

            // Save button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveJob,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Job'),
            ),
            const SizedBox(height: 15),

            // Cancel button
            OutlinedButton(
              onPressed: _isSaving ? null : () => Navigator.pop(context), // Disabled button when saving
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  // Free memory when screen closes
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
