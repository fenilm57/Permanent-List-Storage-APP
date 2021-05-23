import 'models/list.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class ListFunction {
  final Future<Database> database;
  ListFunction(this.database);

  void addList(List<ListData> list, String title) async {
    final addList = ListData(
      id: DateTime.now().toString(),
      title: title,
    );

    await insertList(addList);
  }

  Future<void> insertList(ListData list) async {
    final db = await database;
    await db.insert(
      'lists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
