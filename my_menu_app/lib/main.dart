import 'package:flutter/material.dart';
import 'job_list_screen.dart';
import 'src/DatabaseHelper.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  await DatabaseHelper.instance.database;
  print('Database initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RampCheck',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF0A988B),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 153, 255),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
      ),
      home: const JobListScreen(),
    );
  }
}