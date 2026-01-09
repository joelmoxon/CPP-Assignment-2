import 'package:flutter/material.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);
  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List<Map<String, dynamic>> jobs = [
    {
      'id':1,
      'title': 'Replace hydraulic fluid',
      'priority': 'high',
      'status': 'open',
      'created_at': '09-01-2026',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RampCheck')),
      body: jobs.isEmpty
        ? const Center(
          child: Text(
            'No jobs found.\nTap + to create a new job',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              margin:const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              elevation: 2,
              child: ListTile(
                title: Text(
                  job['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing:const Icon(Icons.chevron_right),
                onTap: () {
                  print("Selected job:${job['title']}");
                },
              )
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Create new job button pressed');
        },
        backgroundColor: Color.fromARGB(255, 0, 153, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
