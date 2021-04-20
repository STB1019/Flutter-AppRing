import 'package:appring/pages/__init__.dart' as pages;
import 'package:flutter/material.dart';

import './index.dart';


class BaseRoute {
  BuildIndex route;
  BaseRoute(BuildContext context) {
    route = BuildIndex(context: context);
    route.addVoice = IndexVoiceBLOC(
        pages.AbovePageWidget.routeName, "Homepage", pages.AbovePageWidget(title: "Bluetooth manager"));
    route.addVoice = IndexVoiceBLOC(
        pages.ScannerPageWidget.routeName, "Scanner Raw Devices", pages.ScannerPageWidget(title: "Scanner Raw Devices"));
    IndexVoiceBLOC temp =IndexVoiceBLOC(
        pages.EntityPageWidget.routeName, "Entity Data", pages.EntityPageWidget());
    temp.setInternalLink();
    route.addVoice = temp;
    route.addVoice = IndexVoiceBLOC(pages.ContactsPageWidget.routeName, "Contatti",
        pages.ContactsPageWidget(title: "Contatti"));
  }

  get init => route.init();

  Map<String, IndexVoiceBLOC> get drawer_voices =>
      route.filter_by_platform(platform: supported_platform.all);

  List<IndexVoiceBLOC> get drawer_voices_as_list => route
      .filter_by_platform(platform: supported_platform.all)
      .values
      .toList().where((IndexVoiceBLOC element) => element.available_drawer)
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
