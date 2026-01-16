import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

Future<Database> _initDatabase() async{
  String path = join(await getDatabasesPath(),'rempcheck.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: _onCreate,
  );
}

  Future _onCreate(Database db, int version) async {
    print('Database created'); // TODO update with table
  }
}

