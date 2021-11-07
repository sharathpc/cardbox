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
  static const columnCardColorCodeId = 'cardcolorcodeid';
  static const columnAccountNumber = 'accountnumber';
  static const columnIFSCode = 'ifscode';
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
    await db.execute(
      '''
      CREATE TABLE $_dbGroupTableName( 
        $columnGroupId INTEGER PRIMARY KEY,
        $columnGroupName TEXT,
        $columnGroupBankCodeId INTEGER
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE $_dbCardTableName( 
        $columnCardId INTEGER PRIMARY KEY,
        $columnCardGroupId INTEGER,
        $columnCardTypeCodeId INTEGER,
        $columnCardColorCodeId INTEGER,
        $columnAccountNumber INTEGER,
        $columnIFSCode TEXT,
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

  Future<void> insertGroup(
    Map<String, dynamic> group,
    List<Map<String, dynamic>> cards,
  ) async {
    Database db = await instance.database;
    final groupRow = await db.insert(_dbGroupTableName, group);
    final batch = db.batch();
    for (final card in cards) {
      card[columnCardGroupId] = groupRow;
      batch.insert(_dbCardTableName, card);
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> queryAllGroup() async {
    Database db = await instance.database;
    return await db.rawQuery(
      '''
      SELECT gp.groupid, gp.groupname, gp.groupbankcodeid, crd.cardslist
      FROM groups AS gp
      LEFT JOIN (
          SELECT cards.cardgroupid, JSON_GROUP_ARRAY(
              JSON_OBJECT(
                  'cardid', cardid,
                  'cardtypecodeid', cardtypecodeid,
                  'cardcolorcodeid', cardcolorcodeid,
                  'accountnumber', accountnumber,
                  'ifscode', ifscode,
                  'cardnumber', cardnumber,
                  'cardexpirydate', cardexpirydate,
                  'cardholdername', cardholdername,
                  'cardcvvcode', cardcvvcode,
                  'cardpin', cardpin,
                  'mobilenumber', mobilenumber,
                  'mobilepin', mobilepin,
                  'internetid', internetid,
                  'internetpassword', internetpassword,
                  'internetprofilepassword', internetprofilepassword
              )
          ) AS cardslist
          FROM cards
          GROUP BY cards.cardgroupid
      ) AS crd
      ON gp.groupid=crd.cardgroupid
      ''',
    );
  }

  Future<Map<String, dynamic>> queryOneGroup(int? groupId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> queryRows = await db.query(
      _dbGroupTableName,
      where: '$columnGroupId = ?',
      whereArgs: [groupId],
    );
    return queryRows[0];
  }

  Future<void> updateGroup(
    Map<String, dynamic> group,
    List<Map<String, dynamic>> cards,
  ) async {
    Database db = await instance.database;
    int groupId = group[columnGroupId];
    final batch = db.batch();
    batch.update(
      _dbGroupTableName,
      group,
      where: '$columnGroupId = ?',
      whereArgs: [groupId],
    );
    for (final card in cards) {
      if (card[columnCardId] == null) {
        batch.insert(_dbCardTableName, card);
      }
    }
    await batch.commit();
  }

  Future<int> deleteGroup(int groupId) async {
    Database db = await instance.database;
    return await db.delete(
      _dbGroupTableName,
      where: '$columnGroupId = ?',
      whereArgs: [groupId],
    );
  }

  Future<int> insertCard(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_dbCardTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllCardsInGroup(int? groupId) async {
    Database db = await instance.database;
    return await db.query(
      _dbCardTableName,
      where: '$columnCardGroupId = ?',
      whereArgs: [groupId],
    );
  }

  Future<Map<String, dynamic>> queryOneCard(int? cardId) async {
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
