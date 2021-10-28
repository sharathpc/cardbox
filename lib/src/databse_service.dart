import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabseService {
  static const _dbName = 'myDatabse.db';
  static const _dbVersion = 1;
  static const _dbTableName = 'cards';

  static const columnId = 'id';
  static const columnBankName = 'bankname';
  static const columnAccountNumber = 'accountnumber';
  static const columnIFSCode = 'ifscode';
  static const columnCardType = 'cardtype';
  static const columnCardNumber = 'cardnumber';
  static const columnCardExpiryDate = 'cardexpirydate';
  static const columnCardHolderName = 'cardholdername';
  static const columnCardCvvCode = 'cardcvvcode';
  static const columnCardPin = 'cardpin';
  static const columnMobileNumber = 'mobilenumber';
  static const columnMobilePin = 'mobilepin';
  static const columnInternetId = 'internetid';
  static const columnInternetPassword = 'internetpassword';
  static const columnInternetProfilePassword = 'internetprofilepassword';

  DatabseService._privateConstructor();
  static final DatabseService instance = DatabseService._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    return _database ?? await _initializeDatabase();
  }

  _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    db.execute(
      '''
        CREATE TABLE $_dbTableName( 
          $columnId INTEGER PRIMARY KEY, 
          $columnBankName TEXT NOT NULL,
          $columnAccountNumber INTEGER,
          $columnIFSCode TEXT,
          $columnCardType TEXT,
          $columnCardNumber INTEGER,
          $columnCardExpiryDate TEXT,
          $columnCardHolderName TEXT,
          $columnCardCvvCode INTEGER,
          $columnCardPin INTEGER,
          $columnMobileNumber INTEGER,
          $columnMobilePin INTEGER,
          $columnInternetId TEXT,
          $columnInternetPassword TEXT,
          $columnInternetProfilePassword TEXT
        )
      ''',
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_dbTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_dbTableName);
  }

  Future<Map<String, dynamic>> queryOne(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> queryRows = await db.query(
      _dbTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return queryRows[0];
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(
      _dbTableName,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _dbTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
