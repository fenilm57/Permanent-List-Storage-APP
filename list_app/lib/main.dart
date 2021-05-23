import 'dart:async';
import 'package:flutter/material.dart';
import 'package:list_app/models/list.dart';
import 'package:list_app/screens/aboutus_screen.dart';
import 'package:list_app/screens/homepage_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'lists_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE lists(id TEXT, title TEXT)',
      );
    },
    version: 1,
  );
  final Future<Database> database2 = openDatabase(
    join(await getDatabasesPath(), 'listtext_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE listtext(id TEXT, ind INTEGER,textTitle TEXT, price INTEGER, checked INTEGER)',
      );
    },
    version: 1,
  );
  runApp(MyApp(database, database2));
}

class MyApp extends StatelessWidget {
  final List<ListData> list = [];
  final database;
  final database2;
  MyApp(this.database, this.database2);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: HexColor('#3EB7FE'),
        textTheme: TextTheme(
          // Elavted Button
          headline1: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: HexColor('#414270'),
          ),
        ),
      ),
      home: HomePage(list, database, database2),
      routes: {
        AboutUs.route: (_) => AboutUs(
              database: database,
              database2: database2,
              list: list,
            ),
      },
    );
  }
}
