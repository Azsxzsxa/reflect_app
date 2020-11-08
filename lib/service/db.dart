import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'example';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async => await db.execute(
      'CREATE TABLE todo_items (id INTEGER PRIMARY KEY NOT NULL, task STRING, details STRING,complete BOOLEAN, date STRING)');

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<List<Map<String, dynamic>>> todayList(String table,String date) async {
    List<Map> result = await _db.rawQuery('SELECT * FROM $table WHERE date=?', [date]);
    print('list contains $result');
    return result;
  }


  static Future<int> insert(String table, TodoModel model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, TodoModel model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, TodoModel model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}