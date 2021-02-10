import 'package:appring/widget/nav.dart';
import 'package:flutter/material.dart';
import 'package:appring/bloc/bluetooth/__init__.dart' as ble;

import 'entity.dart';

// following sample in https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
class ScannerPageScreenArguments {
  final String title;

  ScannerPageScreenArguments(this.title);
}

class ScannerPageWidget extends StatefulWidget {
  static String routeName = "/bluetooth/scanner";
  final String title; //= "-missing-title-";
  final ble.BLEScanner driver = ble.BLEScanner();
  final Map<String, ble.Device> listDevice = Map<String, ble.Device>();

  ScannerPageWidget({this.title: "Scanner Bluetooth Device Raw"});

  @override
  ScannerPageInitialState createState() {
    // TODO using state's App, is a good option to choose a specific state

    return ScannerPageInitialState();
  }
}

class ScannerPageInitialState extends State<ScannerPageWidget> {
  String title;
  Icon iconBLE = Icon(
        Icons.bluetooth_disabled,
        color: Colors.black26,
      ),
      iconRadio = Icon(
        Icons.portable_wifi_off,
        color: Colors.black26,
      );

  @override
  void initState() {
    if (title == null) {
      if (widget.title != null) title = widget.title;
    }
    widget.driver.initScanner();
    setIconRadio();
    setIconScanner();
    super.initState();
  }

  @override
  void disposeState() {
    widget.driver.disposeScanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScannerPageScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    if (title == null) {
      if (args != null) title = args.title;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          // DESIGN set specific action to update collected devices
          actions: [
            IconButton(
                icon: this.iconRadio,
                onPressed: () async {
                  widget.driver.switchRadio();
                  setIconRadio();
                  setState(() {});
                }),
            IconButton(
                icon: this.iconBLE,
                onPressed: () async {
                  await widget.driver.switchScanner();
                  setIconScanner();
                  setState(() {});
                })
          ],
        ),
        drawer: Drawer(
          child: BuilderNavWidget(),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  child: Text(
                      "Al momento vi sono ${widget.listDevice.values.length}")),
              Container(
                  child: Expanded(
                      child: StreamBuilder<ble.Device>(
                          stream: widget.driver.pullDevice,
                          builder: (BuildContext context,
                              AsyncSnapshot<ble.Device> asyncSnapshot) {
                            if (asyncSnapshot.hasError)
                              return Text("Errore in recupero dati");
                            if (asyncSnapshot.hasData) {
                              ble.Device device = asyncSnapshot.data;
                              widget.listDevice
                                  .putIfAbsent(device.uuid, () => device);
                              device.discovering();
                            }
                            return ListView.builder(
                                itemCount: widget.listDevice.keys.length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return DeviceWidget(
                                      widget.listDevice.values
                                          .toList()
                                          .elementAt(index),
                                      index);
                                });
                          })))
            ],
          ),
        ));
  }

  Widget DeviceWidget(ble.Device device, int index) {
    return ListTile(
      isThreeLine: true,
      leading: Text("$index"),
      title: Text("${device.uuid}"),
      onTap: () {
        Navigator.pushNamed(
          context,
          EntityPageWidget.routeName,
          arguments: EntityPageScreenArguments(
            device.uuid,device
          ),
        );
      },
      onLongPress: () async {
        bool status = await device.connected();
        if (status)
          device.entity.disconnectOrCancelConnection();
        else
          device.entity.connect();
        setState(() {});
      },
      subtitle: FutureBuilder<bool>(
        future: device.connected(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          String phrase = "non accessibile";
          if (snapshot.hasData)
            phrase = snapshot.data ? "connesso" : "disconnesso";
          if (snapshot.hasError) phrase = "non disponibile";
          return Text("Dispositivo $phrase");
        },
      ),
    );
  }

  void setIconRadio() async {
    switch (await widget.driver.statusRadio()) {
      case ble.BluetoothRadioStatus.OFF:
        this.iconRadio = Icon(Icons.portable_wifi_off, color: Colors.white);
        break;
      case ble.BluetoothRadioStatus.ON:
        this.iconRadio = Icon(Icons.wifi_tethering, color: Colors.white);
        break;
      case ble.BluetoothRadioStatus.UNAUTH:
        this.iconRadio = Icon(Icons.portable_wifi_off, color: Colors.red);
        break;
      case ble.BluetoothRadioStatus.RESETTING:
        this.iconRadio = Icon(Icons.wifi_tethering, color: Colors.amber);
        break;
      case ble.BluetoothRadioStatus.UNSUPPORT:
        this.iconRadio = Icon(Icons.portable_wifi_off, color: Colors.grey);
        break;
      case ble.BluetoothRadioStatus.UNDEF:
      default:
        this.iconRadio = Icon(Icons.wifi_tethering, color: Colors.grey);
        break;
    }
  }

  void setIconScanner() {
    switch (widget.driver.statusScanner) {
      case ble.BluetoothScannerStatus.OFF:
        this.iconBLE = Icon(Icons.bluetooth_disabled, color: Colors.white);
        break;
      case ble.BluetoothScannerStatus.ON:
        this.iconBLE = Icon(Icons.bluetooth_connected, color: Colors.white);
        break;
      case ble.BluetoothScannerStatus.RESETTING:
        this.iconBLE = Icon(Icons.bluetooth, color: Colors.amber);
        break;
      case ble.BluetoothScannerStatus.UNDEF:
        this.iconBLE = Icon(Icons.bluetooth, color: Colors.grey);
        break;
      default:
        this.iconBLE = Icon(Icons.bluetooth_disabled, color: Colors.grey);
        break;
    }
  }
}
