class Job {

  // Create fileds to map to databse table
  final int? id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String syncStatus;
  final String createdAt;
  final String? updatedAt;

  // Constructor
  Job({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.syncStatus = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  // Convert job objects to insert into database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'sync_status': syncStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create job objects when reading from database
  static Job fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: map['priority'] as String,
      status: map['status'] as String,
      syncStatus: map['sync_status'] as String? ?? 'pending',
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
    );
  }
}