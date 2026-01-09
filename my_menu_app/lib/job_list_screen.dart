import 'package:flutter/material.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);
  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

// Mock joblist for prototype
class _JobListScreenState extends State<JobListScreen> {
List<Map<String, dynamic>> jobs = [
    {
      'id': 1,
      'title': 'Replace hydraulic fluid',
      'priority': 'high',
      'status': 'open',
      'created_at': '2026-01-08',
    },
    {
      'id': 2,
      'title': 'Inspect landing gear',
      'priority': 'medium',
      'status': 'in-progress',
      'created_at': '2026-01-07',
    },
    {
      'id': 3,
      'title': 'Check tyre pressure',
      'priority': 'low',
      'status': 'closed',
      'created_at': '2026-01-06',
    },
  ];

// Helper method for job priority colour coding
Color getPriorityColor(String priority) {
  switch (priority) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    case 'low':
      return Colors.green;
    default: 
      return Colors.grey;
  }
}

// Helper method for job status colour coding
Color getStatusColor(String status) {
  switch (status) {
    case 'open':
      return Colors.blue;
    case 'in-progress':
      return Colors.purple;
    case 'closed':
      return Colors.grey;
    default: 
      return Colors.grey;
  }
}

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

        // Create scrollable job list 
      : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];

            // Container for an individual job item
            return Card(
              margin:const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8
                ),

                // Job title
                title: Text(
                  job['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                // Job metadata with colour coding and date created
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children:[

                      // Job priority container
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4
                        ),
                        decoration: BoxDecoration(
                          color: getPriorityColor(job['priority']),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: getPriorityColor(job['priority']),
                            width:1,
                          ),
                        ),
                        child: Text(
                          job['priority'].toUpperCase(),
                          style: TextStyle(
                            color:Colors.white,
                            fontSize:11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width:8),

                      // Job status container
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(job['status']),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: getStatusColor(job['status']),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          job['status'].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Job creation date
                      Text(
                        job['created_at'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing:const Icon(Icons.chevron_right),

                // Verify job selection 
                onTap: () {
                  print("Selected job:${job['title']}");
                },
              )
            );
          }
      ),

      // Button to create new job
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
