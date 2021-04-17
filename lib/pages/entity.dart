import 'package:appring/widget/nav.dart';
import 'package:flutter/material.dart';
import 'package:appring/bloc/bluetooth/__init__.dart' as ble;

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class EntityPageScreenArguments {
  final String title;
  final ble.Device device;
  EntityPageScreenArguments(this.title,this.device);
}

class EntityPageWidget extends StatefulWidget {
  static String routeName = "/bluetooth/Entity/device";
  final String title; //= "-missing-title-";
  final ble.Device device;

  EntityPageWidget({this.title: null,this.device:null});

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
          // DESIGN set specific action to update collected devices
          actions: [],
        ),
        // drawer: Drawer(
        //   child: BuilderNavWidget(),
        // ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(device.uuid.toString())
            ],
          ),
        ));
  }
}
