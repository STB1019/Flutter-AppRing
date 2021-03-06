import 'package:uuid/uuid.dart';

class DeviceHardware {
  static final String tableName = "Device";
  String _id;
  bool toSave = true;
  String label;
  String description;
  bool available;

  DeviceHardware._internal(
      this._id, this.label, this.description, this.available);

  factory DeviceHardware() {
    return DeviceHardware._internal(
        Uuid().v4().toString(), "Interruttore 1", "Gestore scale Est", true);
  }

  static String createTable({String id_field: "id"}) {
    return "CREATE TABLE Device (${id_field} TEXT PRIMARY KEY,label TEXT, description TEXT, available INTEGER DEFAULT 0)";
  }

  static String dropTable() {
    return "DROP TABLE ${tableName}";
  }

  static String verifyIfExistTable() {
    return "SELECT * FROM ${tableName}";
  }

  setToSave() {
    toSave = true;
  }

  setToSaved() {
    toSave = false;
  }

  String saveIntoDB({String id_field: "id"}) {
    Map<String, dynamic> map_values = {
      "label": label,
      "description": description,
      "available": available ? 1 : 0
    };
    if (toSave) {
      toSave = false;
      return "INSERT INTO ${tableName} (${[
        id_field,
        ...map_values.keys.toList()
      ].join(",")}) VALUES (${[_id, ...map_values.values.toList()].join(",")})";
    }
    return "UPDATE ${tableName} SET ${map_values.entries.map((MapEntry<String, dynamic> e) => "${e.key} = ${e.value}").toList().join(",")} WHERE ${id_field} == ${this._id}";
  }
}
