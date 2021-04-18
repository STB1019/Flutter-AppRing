import 'package:uuid/uuid.dart';

class DeviceHardware {
  static final String tableName = "Device";
  String _id;
  String label;
  String description;
  bool avaiable;

  DeviceHardware._internal(
      this._id, this.label, this.description, this.avaiable);

  factory DeviceHardware() {
    return DeviceHardware._internal(
        null, "Interruttore 1", "Gestore scale Est", true);
  }

  static String createTable({String id_field: "id"}) {
    return "CREATE TABLE Device (${id_field} TEXT PRIMARY KEY,label TEXT, description TEXT, avaiable INTEGER DEFAULT 0)";
  }

  static String dropTable() {
    return "DROP TABLE ${tableName}";
  }

  static String verifyIfExistTable() {
    return "SELECT * FROM ${tableName}";
  }

  String saveIntoDB({String id_field: "id"}) {
    Map<String, dynamic> map_values = {"label":label,"description":description,"avaiable":avaiable?1:0};
    if (this._id == null)
      return "INSERT INTO ${tableName} (${[
        id_field,
        ...map_values.keys.toList()
      ].join(",")}) VALUES (${[Uuid().v4().toString(), ...map_values.values.toList()].join(",")})";
    return "UPDATE ${tableName} SET ${map_values.entries.map((MapEntry<String, dynamic> e) => "${e.key} = ${e.value}").toList().join(",")} WHERE ${id_field} == ${this._id}";
  }
}
