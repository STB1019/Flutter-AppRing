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

  factory MyHomePage.pincopallo() {
    return null;
  }

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

  @override
  initState() {
    super.initState();
    formVarText = widget.title;
    _formVarBool = false;
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.agriculture),
                  onPressed: () {
                    SnackBar snackbar =
                    SnackBar(content: Text("Yo, I'm here!"));
                    Scaffold.of(context).showSnackBar(snackbar);
                  },
                );
              },
            ),
          ]),
      body: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
                initialValue: formVarText,
                validator: (String val) {
                  if (val.trim().compareTo("tummolo") == 0)
                    return null;
                  return "ERRORE!";
                }
            ),
            common_widget.formCheckboxLitTile(_formVarBool, (bool newValue) {
              setState(() {
                _formVarBool = newValue;
              });
            })
          ],
        ),
        onChanged: () {},
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              SnackBar snackBar = SnackBar(
                  content: Text("Salvataggio in corso"));
              Scaffold.of(context).showSnackBar(snackBar);
            });
          },
          tooltip: 'Invio',
          child: Icon(
            Icons.send_sharp,
            color: Colors.green[300],
          ),
        );
      }, // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
