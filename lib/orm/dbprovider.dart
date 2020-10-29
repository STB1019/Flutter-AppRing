import 'package:appring/orm/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Desidero definire una classe che mi permetta di accedere al database(file)
/// senza dovermi preoccupare delle "noie" da Directory.
/// Inoltre, voglio che gestisca in autonima, le azioni CRUD sul DB
class DBMS {
  /// Nome del file
  String _nameDBFile = "db.sqlite";

  // Pattern singleton
  static final DBMS entity = DBMS._();
  DBMS._();

  // Variabile di comodo
  Database _db;

  Future<Database> get database async {
    if (_db == null) _db = await createDB();
    return _db;
  }

  /// Creazione DB, compresa logica di creazione file
  Future<Database> createDB() async {
    String path = await _create_file_db();
    Database obj_db;
    obj_db = await openDatabase(path, version: 1, onOpen: (Database db) async {
      return db;
    }, onCreate: (Database db, int version) async {
      List<dynamic> query = [TaskEntity];
      query.forEach((sql) async{
        var buffer;
        try{
          buffer=await db.rawQuery(sql.dbDropTable);
        }catch(e){
          print(e);
          print(buffer);
        }
        buffer=await db.rawQuery(sql.dbCreateTable);
        print(sql.dbCreateTable);
        print(buffer);
      });

      return db;
    });
    return obj_db;
  }

  newObj({String table, List<String> keys, List<String> values}) async {
    if (table == null || keys == null || values == null) return null;
    var db = await database;
    var raw = await db.rawInsert(
        "INSERT INTO $table (${keys.join(",")})"
        " VALUES (${List.generate(keys.length, (_) => "?").join(",")})",
        values);
    return raw;
  }

  updateObj(tablename, {obj, where, whereArgs}) async {
    var db = await database;
    var res = await db.update(tablename, obj.toMap(),
        where: where, whereArgs: whereArgs);
    return res;
  }

  getObj(tablename,
      {distinct,
      columns,
      where,
      whereArgs,
      groupBy,
      having,
      orderBy,
      limit,
      offset}) async {
    var db = await database;
    var res = [];
    if (columns != null || where != null || whereArgs != null)
      res = await db.query(tablename,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset);
    else
      res = await db.query(tablename);
    return res;
  }

  /// PRIVATE AREA

  Future<String> _create_file_db() async {
    return join(await getDatabasesPath(), _nameDBFile);
  }
}

class ModelEntity {
  ModelEntity();

  factory ModelEntity.fromMap(Map<String, dynamic> obj) {
    return ModelEntity();
  }
  static get dbCreateTable => "";

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>();
  }

  static insert(DBMS db, ModelEntity obj, {String tableName}) async {
    await db.newObj(
        table: tableName,
        keys: List.castFrom<dynamic, String>(obj.toMap().keys.toList()),
        values: List.castFrom<dynamic, String>(obj.toMap().values.toList()));
  }


}
