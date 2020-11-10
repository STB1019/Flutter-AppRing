import 'package:appring/orm/dbprovider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class TaskEntity extends ModelEntity {
  static final String tableName = "task";
  String id,name;
  bool todo;
  // DateTime since,until;

  static get dbCreateTable => "CREATE TABLE $tableName ("
      "id TEXT PRIMARY KEY,"
      "name TEXT NULL,"
      "todo INTEGER DEFAULT 0"
      ");";

  static get dbDropTable => "DROP TABLE IF EXISTS $tableName;";

  TaskEntity({this.id, this.name, this.todo: false});

  factory TaskEntity.fromMap(Map<String, dynamic> objMap) {
    return TaskEntity(
        id: objMap.containsKey("id") ? objMap["id"] : Uuid().v4(),
        name: objMap.containsKey("name") ? objMap["name"] : "-missing-",
        todo: objMap.containsKey("todo") ? objMap["todo"] : false);
  }

  factory TaskEntity.fromSQL(Map<String, dynamic> objMap) {
    return TaskEntity(
        id: objMap["id"],
        name: objMap["name"] ,
        todo: objMap["todo"]==0 ? false : true);
  }

  Map<String, dynamic> toSQL() {
    return {
      "id": this.id.trim(),
      "name": this.name.trim(),
      "todo": this.todo ? 1 : 0
    };
  }

  String toString(){
    return "$id $name";
  }

  // DB Function
  static Future<List> getAll(db) async {
    var buffer = await db.getObj(tableName);
    return buffer.map((c) => TaskEntity.fromSQL(c)).toList();
  }
}
