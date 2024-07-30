import 'package:interview_learn_process/core/service/base_db_service.dart';
import 'package:interview_learn_process/core/service/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NetWorkDBService extends BaseDBService {
  late DataBaseHelper _dataBaseHelper;
  NetWorkDBService() {
    _dataBaseHelper = DataBaseHelper();
  }
  static Database? _database;

  @override
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _dataBaseHelper.setDataBase();
      return _database;
    }
  }

  @override
  Future deleteData(table, itemId) async {
    var connection = await database;
    return await connection!
        .delete(table, where: "id = ?", whereArgs: [itemId]);
  }

  @override
  Future getData(table) async {
    var connection = await database;
    return await connection!.query(table);
  }

  @override
  Future inserData(table, Map<String, dynamic> data) async {
    var connection = await database;
    return connection!.insert(table, data);
  }

  @override
  Future updateData(table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection!
        .update(table, data, where: "id = ?", whereArgs: [data['id']]);
  }

  @override
  Future getDataById(table, itemId) async {
    var connection = await database;
    return await connection!.query(table, where: 'id = ?', whereArgs: [itemId]);
  }

  @override
  Future getStudentDataById(table, itemId) async {
    var connection = await database;
    return await connection!.query(table,where: 'teacher_id = ?',whereArgs: [itemId]);
  }
}
