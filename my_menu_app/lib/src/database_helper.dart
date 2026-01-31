import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  // Create databse instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Initialise databse on first use
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Create SQLite datbase file
  Future<Database> _initDatabase() async {
  String databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'datafile.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create database table and columns
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
        ''');
  }

  // Insert new job into databse
  Future<int> insertJob(Map<String, dynamic> job) async {
    final db = await database;
    return await db.insert('jobs', job);
  }

  // Get all jobs from database
  Future<List<Map<String, dynamic>>> getAllJobs() async {
    final db = await database;
    return await db.query('jobs', orderBy: 'created_at DESC');
  }

  // Update exisitng jobs in database
  Future<int> updateJob(Map<String, dynamic> job) async {
    final db = await database;
    return await db.update(
      'jobs',
      job,
      where: 'id = ?',
      whereArgs: [job['id']],
    );
  }

  // Delete job from database
  Future<int> deleteJob(int id) async {
    final db = await database;
    return await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  // Get all jobs that need synching
  Future<List<Map<String, dynamic>>> getPendingJobs() async {
    final db = await database;
    return await db.query(
      'jobs',
      where: 'sync_status = ?',
      whereArgs: ['pending'],
    );
  }

  // Mark jobs as synced
  Future<int> markJobAsSynced(int id) async {
    final db = await database;
    return await db.update(
      'jobs',
      {'sync_status': 'synced'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
