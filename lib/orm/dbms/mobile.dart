import 'dart:io';
import '../entity/__init__.dart' as entity;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static Database _dbObj;
  static String _dbPath, _dbFolder;
  static bool _sObj = false, _sPath = false, _sAvaiable = false;
  static final String id_field="id";
  static final String _dbName = "dbDevice.db";
  static final DatabaseManager _databaseManager = DatabaseManager._internal();

  bool get statusObj => _sObj;

  bool get statusPath => _sPath;

  bool get statusDBAvaiable => _sAvaiable;

  /// Ritorna l'oggeto database; se vuoto, lo genera e lo ritorn
  Future<Database> get db async {
    if (_dbObj != null) return _dbObj;
    await initDatabase();
    return _dbObj;
  }

  /// Ritorna il path del database; se vuoto, lo genera e lo ritorna
  Future<String> get dbPath async {
    if (_dbPath != null) return _dbPath;
    _dbFolder = await getDatabasesPath();
    _dbPath = join(_dbFolder, _dbName);
    return _dbPath;
  }

  factory DatabaseManager() {
    return _databaseManager;
  }

  DatabaseManager._internal();

  initDatabase() async {
    String path = await dbPath;
    _dbObj = await openDatabase(
      // path file where exist db file
      path,
      // version db, different by installation
            version: 1,
      // set function for config db
            onConfigure: _dbOnConfigure,
      // callend only once
            onCreate: _dbOnCreate,
            onDowngrade: onDatabaseDowngradeDelete)
        .then((value) {
      _sObj = true;
      return value;
    }, onError: (e) {
      print("Errore durante l'apertura del DB\n${e}");
      return null;
    });
  }

  _dbOnConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _dbOnCreate(Database db, int version) async {
    try {
      await Directory(_dbFolder).create(recursive: false);
      _sPath = true;
    } catch (e) {
      print(
          "Errore in creazione databasepath ${_dbFolder.toString()}\n${e.toString()}");
    }
  }

  Future dbExecute(String sql) {
    try{
      return _dbObj.execute(sql);
    }catch(e){
      return null;
    }
  }

  Future dbCreateTable() {
    try {
      var value= dbExecute(entity.DeviceHardware.verifyIfExistTable())
          .then((value) => value, onError: (e) {
        print("CREATE TABLE");
        print(e);
        return dbForceCreateTable();
      });
      print("FAIL?? ${value}");
      return value;
    } catch (e) {
      print("CREATE TABLE");
      print(e);
      return dbForceCreateTable();
    }
  }

  Future dbForceCreateTable() {
    return dbExecute(entity.DeviceHardware.createTable(id_field:id_field)).then((value) {
      print("ESITO CREATE TABLE ${value}");
      _sAvaiable = true;
    }, onError: (error) {
      print("Esito Fallito ${error}");
      _sAvaiable = false;
    });
  }

  Future dbDropTable() {
    return null;
    try {
       var value=dbExecute(entity.DeviceHardware.dropTable());
      return value;
    } catch (e) {
      print("Impossibile cancellare la tabella");
      print(e);
      return null;
    }
  }
}
