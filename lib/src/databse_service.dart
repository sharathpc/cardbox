import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabseService {
  static const _dbName = 'myDatabse.db';
  static const _dbVersion = 1;
  static const _dbGroupTableName = 'groups';
  static const _dbCardTableName = 'cards';

  static const columnGroupId = 'groupid';
  static const columnGroupName = 'groupname';
  static const columnGroupBankCodeId = 'groupbankcodeid';

  static const columnCardId = 'cardid';
  static const columnCardGroupId = 'cardgroupid';
  static const columnCardTypeCodeId = 'cardtypecodeid';
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
        CREATE TABLE $_dbGroupTableName( 
          $columnGroupId INTEGER PRIMARY KEY,
          $columnGroupName TEXT,
          $columnGroupBankCodeId INTEGER,
        )
        CREATE TABLE $_dbCardTableName( 
          $columnCardId INTEGER PRIMARY KEY,
          $columnCardGroupId INTEGER,
          $columnCardTypeCodeId INTEGER,
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

  Future<int> insertGroup(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_dbGroupTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllGroup() async {
    Database db = await instance.database;
    return await db.query(_dbGroupTableName);
  }

  Future<Map<String, dynamic>> queryOneGroup(int groupId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> queryRows = await db.query(
      _dbGroupTableName,
      where: '$columnGroupId = ?',
      whereArgs: [groupId],
    );
    return queryRows[0];
  }

  /* Future<int> update(Map<String, dynamic> row) async {
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
  } */

  Future<int> insertCard(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_dbCardTableName, row);
  }

  Future<Map<String, dynamic>> queryOneCard(int cardId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> queryRows = await db.query(
      _dbCardTableName,
      where: '$columnCardId = ?',
      whereArgs: [cardId],
    );
    return queryRows[0];
  }

  Future<int> updateCard(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int cardId = row[columnCardId];
    return await db.update(
      _dbCardTableName,
      row,
      where: '$columnCardId = ?',
      whereArgs: [cardId],
    );
  }

  Future<int> deleteCard(int cardId) async {
    Database db = await instance.database;
    return await db.delete(
      _dbCardTableName,
      where: '$columnCardId = ?',
      whereArgs: [cardId],
    );
  }
}
