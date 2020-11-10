import 'package:appring/orm/dbprovider.dart';
import 'package:appring/orm/task.dart';
import 'package:flutter/material.dart';

import 'widget/__init__.dart' as common_widget;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'La mia prima app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String formVarText;
  bool _formVarBool;
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    formVarText = widget.title;
    _formVarBool = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.sync),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Avvio reset DB"),
                        duration: Duration(seconds: 1, milliseconds: 500)));
                    DBMS.entity.createDB().then((value) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("DB settato")));
                    });
                  },
                );
              },
            ),
          ]),
      body: Form(
        key: keyForm,
        child: Column(
          children: <Widget>[
            TextFormField(
                initialValue: formVarText,
                autovalidateMode: AutovalidateMode.always,
                decoration: InputDecoration(hintText: "Aggiungi promemoria"),
                maxLines: 5,
                minLines: 1,
                validator: (String val) {
                  if (val.trim().length == 0)
                    return "Attenzione, non è corretto inviare una stringa vuota";
                  formVarText = val.trim();
                  return null;
                },
                onSaved: (String param) => param.trim(),
                onEditingComplete: () {
                  // DESIGN [@redsandev] non sono proprio sicuro di cosa faccia questa funzione
                  // https://stackoverflow.com/a/56946311/5930652
                  FocusScope.of(context).unfocus();
                }),
            Expanded(
                child: FutureBuilder(
                    future: TaskEntity.getAll(DBMS.entity),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError)
                        return Text("Non funziona niente\n${snapshot.error}");
                      if (snapshot.hasData) if (snapshot.data.length == 0)
                        return Text("Nessun dato");
                      snapshot.data.forEach((value) {
                        print(value.runtimeType);
                        print(value);
                      });
                      return Container(
                          width: 200,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                TaskEntity task =
                                    snapshot.data[index] as TaskEntity;
                                return ListTile(
                                  title: Text(task.name),
                                  subtitle: Text(task.id),
                                );
                              }));
                      //TODO
                    }))
          ],
        ),
        onChanged: () {},
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Salvataggio in corso"),
                  duration: Duration(seconds: 2, milliseconds: 500),
                ));
                TaskEntity task = TaskEntity.fromMap({"name": formVarText});
                ModelEntity.insert(DBMS.entity, task,
                    tableName: TaskEntity.tableName);
                formVarText = "";
              });
            },
            tooltip: 'Invio',
            child: Icon(
              Icons.add,
              color: Colors.green[300],
            ),
          );
        }, // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
