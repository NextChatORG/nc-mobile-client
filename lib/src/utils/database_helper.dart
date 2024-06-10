import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static const authInfoTable = 'auth_info';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = "$path/nextchat.db";

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $authInfoTable (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            key_name TEXT UNIQUE NOT NULL,
            value TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();

    return _database!;
  }
}
