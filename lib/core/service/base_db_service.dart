import 'package:sqflite/sqflite.dart';

abstract class BaseDBService {
  Future<Database?> get database;

  Future<dynamic> inserData(table, Map<String, dynamic> data);

  Future<dynamic> getData(table);

  Future<dynamic> getDataById(table, itemId);

  Future<dynamic> updateData(table, Map<String, dynamic> data);

  Future<dynamic> deleteData(table, itemId);
}
