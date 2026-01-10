import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen ({Key? key}) : super(key: key);

  @override
    State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Title bar
      appBar: AppBar(
        title: const Text('Create New Job'),
      ),

      // Main content area
      body: Center(
        child: Text('Create job form'),
      ),
    );
  }
}