import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
export 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import './DBCreation.dart';
import '../../constants/constants.dart';

class SQLiteHelper {
  static final SQLiteHelper _singleton = SQLiteHelper._privateConstructor();

  static final String _databaseName =
      "${Constants.applicationConstants.title}.db";
  static const int _databaseVersion = 1;
  static Database? _database;

  factory SQLiteHelper() {
    return _singleton;
  }

  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(path.join(dbPath, _databaseName),
        version: _databaseVersion, onCreate: (Database db, int version) {
      DBCreation.onCreate(db, version);
    });
  }

  SQLiteHelper._privateConstructor() {
    if (Platform.isWindows || Platform.isLinux) {
      // In release mode, add sqlite3.dll [https://github.com/tekartik/sqflite/raw/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll] in same folder as your executable.
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    }
    _initDatabase();
  }

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  static Future<void> execute(String query) async {
    final db = await (_singleton.database as FutureOr<Database>);
    await db.transaction((action) async => await action.execute(query));
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await (_singleton.database as FutureOr<Database>);
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = await (_singleton.database as FutureOr<Database>);
    return db.query(tableName);
  }

  static Future<int> rawInsert(String query, List<dynamic> data) async {
    final db = await (_singleton.database as FutureOr<Database>);
    return await db.rawInsert(query, data);
  }

  static Future<List> rawSelectAll(String table) async {
    final db = await (_singleton.database as FutureOr<Database>);
    return db.rawQuery('SELECT * FROM $table');
  }

  static Future<int> delete(
      {required int id, String? table, String? whereCondition}) async {
    Database? db = await _singleton.database;
    if (null != whereCondition) {
      return await db!.delete(table!, where: whereCondition, whereArgs: [id]);
    } else {
      return await db!.delete(table!, whereArgs: [id]);
    }
  }

  static Future<int?> queryRowCount(String table) async {
    Database db = await (_singleton.database as FutureOr<Database>);
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  static Future close() async => _singleton.database.then((database) {
        database!.close();
      });
}
