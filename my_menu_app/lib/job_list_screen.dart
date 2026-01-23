import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'create_job_screen.dart';
import 'src/DatabaseHelper.dart';  
import 'src/job.dart';           
import 'edit_job_screen.dart';   

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);
  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
List<Job> jobs = [];
bool isLoading = true; // Track whether app is loading data from datbase

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
void initState() {
  super.initState();
  _loadJobs();
}

// Load jobs from database
Future<void> _loadJobs() async {
  final jobMaps = await DatabaseHelper.instance.getAllJobs();
  setState(() {
    jobs = jobMaps.map((map) => Job.fromMap(map)).toList();
    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Title bar
      appBar: AppBar(
        title: const Text('RampCheck'),

        // Hamburger menu button
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      // Navigation draw within hamburger menu
      drawer: Drawer(
        child:ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 153, 255)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'RampCheck',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Maintenance Manager',
                    style: TextStyle(color:Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Hamburger menu navigation options
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Jobs'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // Main content area where jobs are added
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        :jobs.isEmpty
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
                  job.title,
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
                          color: getPriorityColor(job.priority),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: getPriorityColor(job.priority),
                            width:1,
                          ),
                        ),
                        child: Text(
                          job.priority.toUpperCase(),
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
                          color: getStatusColor(job.status),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: getStatusColor(job.status),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          job.status.toUpperCase(),
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
                        job.createdAt.substring(0, 10),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing:const Icon(Icons.chevron_right),

                // Navigate to edit screen from job selection
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditJobScreen(job: job),
                    ),
                  );
                  if (result == true) {
                    _loadJobs();
                  }
                },
              )
            );
          }
      ),

      // Button to create new job
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateJobScreen()),
          );
          if (result == true) {
            _loadJobs();
          }
        },
        backgroundColor: Color.fromARGB(255, 0, 153, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
