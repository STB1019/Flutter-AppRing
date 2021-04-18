import 'package:appring/orm/dbms/mobile.dart';
import 'package:appring/skeleton/base.dart';
import 'package:appring/widget/nav.dart';
import 'package:appring/widget/notify.dart';
import 'package:flutter/material.dart';
import 'package:appring/bloc/bluetooth/__init__.dart' as ble;
import 'package:sqflite/sqflite.dart';

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class AbovePageScreenArguments {
  final String title;
  final DatabaseManager orm;

  AbovePageScreenArguments(this.title, this.orm);
}

class AbovePageWidget extends StatefulWidget {
  static String routeName = "/";
  final String title; //= "-missing-title-";

  AbovePageWidget({this.title: "-missing-title-"});

  @override
  AbovePageInitialState createState() {
    // TODO using state's App, is a good option to choose a specific state

    return AbovePageInitialState();
  }
}

class AbovePageInitialState extends State<AbovePageWidget> {
  String title;
  DatabaseManager orm;
  bool workOnDB = false;

  @override
  void initState() {
    if (title == null) {
      if (widget.title != null) title = widget.title;
    }
    super.initState();
  }

  @override
  void disposeState() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AbovePageScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    if (title == null) {
      if (args != null) title = args.title;
    }
    if (orm == null) {
      if (args != null)
        orm = args.orm;
      else
        orm = DatabaseManager();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // DESIGN set specific action to update collected devices
        actions: [],
      ),
      drawer: Drawer(
        child: BuilderNavWidget(),
      ),
      body: Column(
        children: <Widget>[
          Center(child: Text("Welcome to $title")),
          FutureBuilder(
              future: orm.db,
              builder:
                  (BuildContext context, AsyncSnapshot<Database> snapshot) {
                Icon resp = Icon(
                  Icons.info,
                  color: Colors.blueAccent,
                );
                Text title = Text("Database deve essere creato");
                if (snapshot.hasError || !snapshot.hasData)
                  Icon(
                    Icons.error,
                    color: Colors.red,
                  );
                else {
                  workOnDB = true;
                  resp = Icon(Icons.info,
                      color: orm.statusObj ? Colors.green : Colors.orange);
                  title = Text(orm.statusObj
                      ? "Database disponibile"
                      : "Database da creare");
                  return ListTile(
                    leading: resp,
                    title: title,
                    onTap: () {
                      orm.dbPath.then((String value) {
                        notificationString(context, "Path db is $value");
                        setState(() {});
                      }, onError: (value) {
                        notificationString(context, "Errore\n$value");
                        setState(() {});
                      });
                    },
                    onLongPress: () async {
                      await orm.dbCreateTable();
                      notificationString(context, "Creazione tabelle in corso");
                    },
                  );
                }
                return ListTile(
                  leading: resp,
                  title: title,
                  onTap: () {
                    setState(() {
                      orm.initDatabase();
                      setState(() {});
                    });
                  },
                );
              }),
          Visibility(
              visible: workOnDB,
              child: ListTile(
                leading: Icon(Icons.storage,
                    color: orm.statusDBAvaiable ? Colors.green : Colors.amber),
                title: Text(orm.statusDBAvaiable
                    ? "Database pronto"
                    : "Database da inizializzare"),
                onTap: ()async{
                  if(orm.statusDBAvaiable) {
                    notificationString(context, "Il Database è disponibile");
                    setState(() {

                    });
                  }else{
                    notificationString(context, "Inizializzazione Database avviata");
                    await orm.dbDropTable();
                    await orm.dbCreateTable();
                    notificationString(context, orm.statusDBAvaiable ? "Iniziazilizzazione Database completata": "Impossibile completare l'inizializzazione");
                    setState(() {
                      print("ORM IS ${orm.statusDBAvaiable}");
                    });
                  }

                },
              ))
        ],
      ),
    );
  }
}
