import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen ({Key? key}) : super(key: key);

  @override
    State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String selectedPriority = 'medium';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Title bar
      appBar: AppBar(
        title: const Text('Create New Job'),
      ),

      // Main body
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Job title text field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText:'Job Title',
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
                labelText:'Description',
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
