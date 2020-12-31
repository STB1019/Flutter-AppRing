import 'package:flutter/material.dart';

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class AbovePageScreenArguments {
  final String title;

  AbovePageScreenArguments(this.title);
}

class AbovePageWidget extends StatefulWidget {
  static String routeName = "/";
  String title;

  @override
  AbovePageInitialState createState() {
    // TODO a seconda dello stato in cui versa l'app, è necessario visualizzare una specifica pagina
    return AbovePageInitialState();
  }
}

class AbovePageInitialState extends State<AbovePageWidget> {
  String title;

  @override
  void initState() {
    if (title == null) {
      if (widget.title != null) title = widget.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AbovePageScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    print(args);
    if (title == null) {
      if (args != null) title = args.title;
    }
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("Prova")],
        ),
      ),
    );
  }
}
