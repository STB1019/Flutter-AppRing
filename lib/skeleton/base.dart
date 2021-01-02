import 'package:appring/pages/above.dart';
import 'package:appring/pages/contacts.dart';
import 'package:flutter/material.dart';

import './index.dart';

// TODO verify if still correct
class BaseRoute {
  BuildIndex route;
  BaseRoute(BuildContext context) {
    route = BuildIndex(context: context);
    route.addVoice = IndexVoiceBLOC(
        AbovePageWidget.routeName, "Titolo", AbovePageWidget(title: "Titolo"));
    route.addVoice = IndexVoiceBLOC(ContactsPageWidget.routeName, "Contatti",
        ContactsPageWidget(title: "Contatti"));
  }

  get init => route.init();

  Map<String, IndexVoiceBLOC> get drawer_voices =>
      route.filter_by_platform(platform: supported_platform.all);

  List<IndexVoiceBLOC> get drawer_voices_as_list => route
      .filter_by_platform(platform: supported_platform.all)
      .values
      .toList();
}

class Base extends StatelessWidget {
  final String title;

  Base({this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: this.title,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: "/",
        routes: BaseRoute(context).init);
  }
}
