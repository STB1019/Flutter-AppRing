import 'package:sqflite/sqflite.dart';

mixin ORM {
  Database _db;

  void create(dynamic obj,
      {ConflictAlgorithm conflictAlgorithm: ConflictAlgorithm.rollback}) async {
    await _db.insert(obj.table, obj.toMap(),
        conflictAlgorithm: conflictAlgorithm);
  }

  Future read(String table,
      {bool distinct: true,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset,
      Map obj}) async {
    if (obj != null) {
      if (columns == null) columns = obj.keys.toList();
      if (where == null)
        where = obj.keys
            .toList()
            .map((e) => "${e.toString()} = ?")
            .toList()
            .join(",");
      if (whereArgs == null)
        whereArgs = obj.keys
            .where((label) => columns.contains(label))
            .map<String>((label) => obj[label].toString())
            .toList();
      whereArgs = obj.values.toList().map((e) => e.toString()).toList();
    }
    return await _db.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
  }

  Future<int> update(String table, Map obj,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm: ConflictAlgorithm.replace}) async {
    return await _db.update(table, obj,
        whereArgs: whereArgs,
        where: where,
        conflictAlgorithm: conflictAlgorithm);
  }

  Future delete(String table, {String where, List<dynamic> whereArgs}) async {
    return await _db.delete(table, where: where, whereArgs: whereArgs);
  }
}
