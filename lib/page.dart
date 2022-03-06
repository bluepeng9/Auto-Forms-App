import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'data/util.dart';
import 'package:path/path.dart';

final String storeTable = 'stores';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDate = 'date';
final String columnDone = 'done';

class Store {
  int? id;
  String? title;
  int? date;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDate: date,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Store({this.id, this.date, this.title});

  Store.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    title = map[columnTitle] as String?;
    date = map[columnDate] as int?;
  }
}

class PageProvider {
  Database? _database;
  final String _dbName = 'stores.db';

  Logger logger = Logger();

  static final PageProvider _instance = PageProvider._internal();

  PageProvider._internal() {}

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _dbName);
    var temp = await open(path);
    return temp;
  }

  factory PageProvider() => _instance;

  Future open(String path) async {
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
      create table $storeTable (
      $columnId integer primary key autoincrement,
      $columnDate integer not null,
      $columnTitle String not null
      )
      ''');
      },
    );
    logger.i('db opened : ${_database}');
    return _database;
  }

  Future<Store> insert(Store store) async {
    Database? db = await _instance.database;
    store.id = await db?.insert(storeTable, store.toMap());
    logger.i('insert');
    return store;
  }

  Future<Store?> getStoreById(int id) async {
    if (_database != null) {
      List<Map<String, Object?>> maps = await _database!.query(storeTable,
          columns: [columnId, columnDone, columnTitle],
          where: '$columnId = ?',
          whereArgs: [id]);
      if (maps.isNotEmpty) {
        return Store.fromMap(maps.first);
      }
      return null;
    }
    return null;
  }

  Future<List<Store>> getStoreByDate(int date) async {
    List<Store> stores = [];
    Database? db = await _instance.database;
    var maps = await db!.query(storeTable,
        // columns: [columnId, columnDone, columnTitle],
        where: '$columnDate = ?',
        whereArgs: [date]);
    if (maps.isNotEmpty) {
      for (var q in maps) {
        stores.add(
          Store(
            id: q[columnId] as int,
            date: q[columnDate] as int,
            title: q[columnTitle] as String,
          ),
        );
      }
      return stores;
    }
    return [];
  }

  Future<int?> delete(int id) async {
    logger.i('delete');
    Database? db = await database;
    return await db
        ?.delete(storeTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> update(Store todo) async {
    return await _database?.update(storeTable, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => _database?.close();
}
