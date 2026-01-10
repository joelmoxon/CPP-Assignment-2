import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen ({Key? key}) : super(key: key);

  @override
    State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final TextEditingController _titleController = TextEditingController();
  
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
                labelText:'job Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.work),
              ),
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
    super.dispose();
  }
}
