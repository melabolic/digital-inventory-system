import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/models/item.dart';

class DatabaseHelper {
  static final _dbName = "main.db";

  static final table = "my_table";
  static final colId = "id";
  static final colName = 'name';
  static final colDate = "expiry_date";
  static final colWeight = "weight";

  // creating the singleton class
  static DatabaseHelper instance;
  static Database _db;
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (instance == null) {
      // will only execute this if the function has not been executed
      instance = DatabaseHelper._createInstance();
    }
    return instance;
  }

  // creating the app wide reference to the DB
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    // getting the directory to the database
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbDirectory.path, _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    print("creating the database");
    db.execute("DROP TABLE IF EXISTS $table"); // remove during actual deployment
    return db.execute("CREATE TABLE $table("
        "$colId INTEGER PRIMARY KEY,"
        "$colName TEXT,"
        "$colDate TEXT,"
        "$colWeight TEXT)");
  }

  // HELPER METHODS
  // getting the list of all items
  Future<List<Item>> getItemList() async {
    var itemMapList = await queryAll();
    int count = itemMapList.length;
    print(count);

    List<Item> itemList = List<Item>();
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMapObject(itemMapList[i]));
    }
    return itemList;
  }

  // insert
  Future<int> insert(Item item) async {
    Database dbClient = await db;
    print("inserting ${item.toMap()}");
    return await dbClient.insert(table, item.toMap());
  }

  // query all
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database dbClient = await db;
    print('$db');
    return await dbClient.query(table);
  }

  // delete
  Future<int> delete(int id) async {
    Database dbClient = await db;
    print("deleting $id");
    return await dbClient.delete(table, where: '$colId = ?', whereArgs: [id]);
  }

  // update
  Future<int> update(Item item) async {
    Database dbClient = await db;
    int id = item.toMap()[colId];
    print("updating id : $id == ${item.toMap()[colId]}");
    return await dbClient
        .update(table, item.toMap(), where: '$colId = ?', whereArgs: [id]);
  }

  // getting the count for all the rows
  Future<int> rowCount() async {
    Database dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT (*) FROM $table"));
  }

  void onDispose() async {
    Database dbClient = await db;
    await dbClient.close();
  }
}
