import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  Future<Database> setDataBase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'user_db');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  _createDatabase(Database db, int version) {
    String teacherTable = '''CREATE TABLE teacher_table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      age TEXT NOT NULL,
      gender TEXT NOT NULL,
      password TEXT NOT NULL,
      profile_image BLOB NOT NULL
        )''';
    String studentTable =
        '''CREATE TABLE student_table(id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        age TEXT NOT NULL,
        email TEXT NOT NULL,
        gender TEXT NOT NULL,
        password TEXT NOT NULL,
        profile_image BLOB NOT NULL)''';
    db.execute(teacherTable);
    db.execute(studentTable);
  }
}
