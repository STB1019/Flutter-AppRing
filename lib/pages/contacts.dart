import 'package:appring/widget/nav.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class ContactsPageScreenArguments {
  final String title;

  ContactsPageScreenArguments(this.title);
}

class ContactsPageWidget extends StatefulWidget {
  static String routeName = "/contacts";
  final String title; //= "-missing-title-";

  ContactsPageWidget({this.title: "-missing-title-"});

  @override
  ContactsPageInitialState createState() {
    // TODO using state's App, is a good option to choose a specific state
    return ContactsPageInitialState();
  }
}

class ContactsPageInitialState extends State<ContactsPageWidget> {
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
    final ContactsPageScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    print(args);
    if (title == null) {
      if (args != null) title = args.title;
    }

    return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Drawer(
          child: BuilderNavWidget(),
        ),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Center(
              child: Text(
            "Thank you!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100),
          )),
          Text(
              "Send your idea, request and even doubt on this code, using your account at"),
          GestureDetector(
              onTap: () async {
                await launch(
                    "https://github.com/STB1019/Flutter-AppRing/discussions");
              },
              child: Text(
                "TAP HERE to go into \n https://github.com/STB1019/Flutter-AppRing",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
        ]));
  }
}
