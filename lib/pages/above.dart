import 'package:appring/skeleton/base.dart';
import 'package:appring/widget/nav.dart';
import 'package:flutter/material.dart';

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class AbovePageScreenArguments {
  final String title;

  AbovePageScreenArguments(this.title);
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
    print("ARGS ARE ${args}");
    if (title == null) {
      if (args != null) title = args.title;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: BuilderNavWidget(),
      ),
      body: Column(
        children: <Widget>[Center(child: Text("Welcome to $title"))],
      ),
    );
  }
}
