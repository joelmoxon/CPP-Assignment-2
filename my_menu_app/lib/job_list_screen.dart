import 'package:flutter/material.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);
  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RampCheck')),
      body: const Center(
        child: Text(
          'No jobs found.\nTap + to create a new job',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
