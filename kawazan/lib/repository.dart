import 'package:kawazan/store/photofoliostore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kawazan/stock.dart';
import 'package:kawazan/photofolio.dart';

class Repository {

  static const scripts = {
    '1' : ['CREATE TABLE stock(id INTEGER PRIMARY KEY AUTOINCREMENT,photofolio_id integer, code TEXT,price TEXT,amount TEXT, haitou TEXT, cagr TEXT)'],
    '2' : ['CREATE TABLE photofolio(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,work_flg integer,create_date date)'],
  };
  static Future<Database> get database async {
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'kazazan.db'),
      version : 2,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print ("onUpgrade oldVersion:" + oldVersion.toString() + " newVersion" + newVersion.toString());
        oldVersion += (oldVersion == 0) ? 1:0;
        for (var i = oldVersion; i <= newVersion; i++) {
          var queries = scripts[i.toString()];
          for (String query in queries) {
            print (query);
            await db.execute(query);
          }
        }
      },
      onDowngrade: (Database db, int oldVersion, int newVersion) async {
        print ("onDowngrade" + newVersion.toString());
        if (newVersion == 1) {
          await db.execute('drop table if exists stock');
          await db.execute('drop table if exists photofolio');
        }
      }
    );
    return _database;
  }
  static Future<void> insertStock(Stock stock) async {
    final Database db = await database;
    await db.insert(
      'stock',
      stock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> deleteStock(int id) async {
    final db = await database;
    await db.delete(
      'stock',
      where: "id = ?",
      whereArgs: [id],
    );
  }
  static Future<List<Stock>> getStocks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
      await db.query('stock',
        where: "photofolio_id is null");
    return List.generate(maps.length, (i) {
      return Stock(
        id: maps[i]['id'],
        code: maps[i]['code'],
        price: maps[i]['price'],
        amount: maps[i]['amount'],
        haitou: maps[i]['haitou'],
        cagr: maps[i]['cagr'],
      );
    });
  }
  static Future<List<Stock>> getRealStocks(int photofolio_id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('stock',
        where: "photofolio_id = ?",
        whereArgs: [photofolio_id],
    );
    return List.generate(maps.length, (i) {
      return Stock(
        id: maps[i]['id'],
        code: maps[i]['code'],
        price: maps[i]['price'],
        amount: maps[i]['amount'],
        haitou: maps[i]['haitou'],
        cagr: maps[i]['cagr'],
        photofolio_id: maps[i]['photofolio_id'],
      );
    });
  }
  static Future<void> insertPhotofolio(Photofolio photofolio) async {
    final Database db = await database;
    await db.insert(
      'photofolio',
      photofolio.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<dynamic> getWorkPhotofolio() async {
    final db = await database;
    List<Map<String,dynamic>> list = await db.query(
      'photofolio',
      where: "work_flg = ?",
      whereArgs: [1],
      limit : 1
    );
    print (list.length);
    if (list.length == 1){
    return new Photofolio(
      id:list[0]['id'],
      name:list[0]['name'],
      create_date: DateTime.parse(list[0]['create_date']),
      work_flg:list[0]['work_flag'],
    );
    } else {
      return null;
    }
  }
  static Future<void> updateWorkPhotofolio(DateTime date) async {
    final db = await database;
    await db.update(
        'photofolio',
        {'create_date' : date.toIso8601String()},
        where : "work_flg = ?",
        whereArgs: [1],
    );
  }
  static Future<void> updatePhotofolio(int id, DateTime date) async {
    final db = await database;
    await db.update(
      'photofolio',
      {'create_date' : date.toIso8601String()},
      where : "id = ?",
      whereArgs: [id],
    );
  }
  static Future<void> workToRealPhotofolio() async {
    final db = await database;
    await db.update(
      'photofolio',
      {'work_flg' : 0},
      where : "work_flg = ?",
      whereArgs: [1],
    );
  }
  static Future<void> workToRealStocks(Photofolio photofolio) async {
    final db = await database;
    await db.update(
      'stock',
      {'photofolio_id' : photofolio.id},
      where : "photofolio_id is null"
    );
  }
  static Future<List<Photofolio>> getPhotofolios() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('photofolio',
        orderBy: 'create_date DESC',
        where: "work_flg = 0");
    return List.generate(maps.length, (i) {
      return Photofolio(
        id: maps[i]['id'],
        name: maps[i]['name'],
        create_date:  DateTime.parse(maps[i]['create_date']),
      );
    });
  }

}