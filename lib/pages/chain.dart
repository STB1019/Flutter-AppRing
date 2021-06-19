import 'package:appring/orm/dbms/mobile.dart';
import 'package:appring/orm/entity/device.dart';
import 'package:appring/pages/__init__.dart';

import 'package:appring/widget/nav.dart';
import 'package:flutter/material.dart';
import 'package:appring/bloc/bluetooth/__init__.dart' as ble;

class ChainEntintyPageScreenArguments {
  final String title;
  ChainEntintyPageScreenArguments(this.title);
}

class ChainEntityPageWidget extends StatefulWidget {
  static String routeName = "/chain/entity";
  final String title;
  final Map<String, ble.Device> mapDevices = Map<String, ble.Device>();

  ChainEntityPageWidget({this.title: "Gestione dispositivi"});

  @override
  ChainEntityPageInitialState createState() {
    return ChainEntityPageInitialState();
  }
}

class ChainEntityPageInitialState extends State<ChainEntityPageWidget> {
  String title="Manage Chain";
  List<DeviceHardware> listDevice=[];
  DatabaseManager orm;

  @override
  void initState() {
    super.initState();
    orm=DatabaseManager();
  }
  @override
  void disposteState(){}

  @override
  Widget build(BuildContext context) {
    final ScannerPageScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    if (title == null) {
      if (args != null) title = args.title;
      else title=widget.title;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // actions:
      ),
      drawer: Drawer(
        child: BuilderNavWidget(),
      ),
      body: 
          ListView.builder(
            itemCount: listDevice.length,
            itemBuilder: (BuildContext context,int index){
              if(listDevice.length==0)
                return Text("Mi spiace, non ho creature speciali per te");
              return ListTile(
                leading: Icon(Icons.bluetooth),
                title: Text(listDevice.elementAt(index).toString()),
                trailing: listDevice.elementAt(index).toSave ? Icon(Icons.warning_amber):Icon(Icons.check),
                onTap: (){
                  orm.dbExecute(listDevice.elementAt(index).saveIntoDB());
                  setState((){});
                },
              );
            }
            ),
        
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){          
          setState((){listDevice.add(DeviceHardware.byParams("Titolo strano ${listDevice.length}"));
          print(listDevice);
          });
        },
        child: const Icon(Icons.add_box_outlined),
      ),
    );
  }
}
