import 'package:appring/widget/nav.dart';
import 'package:appring/widget/notify.dart';
import 'package:flutter/material.dart';
import 'package:appring/bloc/bluetooth/__init__.dart' as ble;

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class EntityPageScreenArguments {
  final String title;
  final ble.Device device;

  EntityPageScreenArguments(this.title, this.device);
}

class EntityPageWidget extends StatefulWidget {
  static String routeName = "/bluetooth/Entity/device";
  final String title; //= "-missing-title-";
  final ble.Device device;

  EntityPageWidget({this.title: null, this.device: null});

  @override
  EntityPageInitialState createState() {
    // TODO using state's App, is a good option to choose a specific state

    return EntityPageInitialState();
  }
}

class EntityPageInitialState extends State<EntityPageWidget> {
  String title;
  ble.Device device;

  @override
  void initState() {
    if (widget.title != null) title = widget.title;
    if (widget.device != null) device = widget.device;
    super.initState();
  }

  @override
  void disposeState() {
    super.dispose();
    widget.device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final EntityPageScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    print("ARGS ${title}");
    print(args.title);
    print(args.device);
    if (title == null) {
      title = args.title;
      device = args.device;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                icon: Icon(Icons.cached),
                onPressed: () {
                  setState(() {});
                })
          ],
        ),
        // drawer: Drawer(
        //   child: BuilderNavWidget(),
        // ),
        body: Column(
          children: <Widget>[
            SummaryWidget(context, device),
            ListProperties(context, device)
          ],
        ));
  }

  Widget SummaryWidget(BuildContext context, ble.Device device) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError)
                  return Icon(Icons.power_settings_new, color: Colors.red);
                else if (snapshot.hasData)
                  return Icon(
                    Icons.power_settings_new,
                    color: Colors.green,
                  );
                else
                  return Icon(Icons.power_settings_new);
              },
            ),
            onPressed: () {
              notificationString(context, "Tentantivo di connessione in corso");
              device.connect().then((value) {
                notificationString(context, "Collegamento riuscito",
                    icon: Icon(Icons.check));
              }, onError: (e) {
                print("ERRORE ${e}");
                notificationString(context, "Collegamento fallito",
                    icon: Icon(Icons.warning_amber_sharp));
              });
            },
          ),
        ),
        ListTile(
            leading: Icon(Icons.tag),
            title: Text(
                device.entity.name == null ? "-missing-" : device.entity.name)),
        ListTile(
            leading: Icon(Icons.tag),
            title: Text(device.entity.identifier == null
                ? "-missing-"
                : device.entity.identifier)),
      ],
    );
  }

  Widget ListProperties(BuildContext context, ble.Device device) {
    return FutureBuilder(
        future: device.entity.discoverAllServicesAndCharacteristics(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            //notificationString(context, "Errore");
            return Center(child: Text("Errore di connessione"));
          } else if (!snapshot.hasData) {
            // notificationString(context, "Data assente");
            return Center(child: Text("Assenza di dati"));
          }
          return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data,
                  itemBuilder: (BuildContext context, int index) {
                    return Container();
                  }));
        });
  }
}
