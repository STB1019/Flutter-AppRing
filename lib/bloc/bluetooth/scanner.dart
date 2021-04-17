import 'dart:async';
import '__init__.dart' as ble;

import 'package:flutter_ble_lib/flutter_ble_lib.dart';

enum BluetoothRadioStatus { UNDEF, OFF, ON, UNAUTH, RESETTING, UNSUPPORT }
enum BluetoothScannerStatus {UNDEF,OFF,ON,RESETTING}
class BLEScanner {
  // Attributes
  BleManager driver;
  BluetoothScannerStatus bluetoothScannerStatus=BluetoothScannerStatus.UNDEF;
  // Mng Stream
  StreamController<ble.Device> mngDevice =
      StreamController<ble.Device>.broadcast();

  StreamSink get pushDevice => mngDevice.sink;

  Stream get pullDevice => mngDevice.stream;

  BLEScanner() {
    this.driver = BleManager();
  }

  factory BLEScanner.fromMap(Map<String, dynamic> input) {
    BLEScanner obj = BLEScanner();
    obj.driver = input["driver"] ?? BleManager();
    return obj;
  }

  // Init Scanner
  initScanner() async {
    await this.driver.createClient();
  }

  // Dispose Scanner
  disposeScanner() {
    this.driver.destroyClient();
    this.bluetoothScannerStatus=BluetoothScannerStatus.RESETTING;
  }
  // Status scanner
  get statusScanner => this.bluetoothScannerStatus;

  // Start Scanner
  startScanner() async {
    this.bluetoothScannerStatus=BluetoothScannerStatus.ON;
    this.driver.startPeripheralScan().listen((ScanResult scanResult) {
      this.pushDevice.add(ble.Device.fromMap(this.driver, {
            "label": scanResult.peripheral.name.toString(),
            "uuid": scanResult.peripheral.identifier.toString(),
          }));
    });
  }

  // Stop Scanner
  stopScanner() async {
    await this.driver.stopPeripheralScan();
    this.bluetoothScannerStatus=BluetoothScannerStatus.OFF;
  }

  // Switch Scanner
  switchScanner()async{
    switch(this.bluetoothScannerStatus){
      case BluetoothScannerStatus.ON:
        await this.stopScanner();
        break;
      case BluetoothScannerStatus.OFF:
        await this.startScanner();
        break;
      case BluetoothScannerStatus.UNDEF:
      default:
        await this.stopScanner();
        break;
    }
  }

  // Status Radio
  Future<BluetoothRadioStatus> statusRadio() async {
    var temp = await this.driver.bluetoothState();
    switch (temp) {
      case BluetoothState.POWERED_ON:
        return BluetoothRadioStatus.ON;

      case BluetoothState.POWERED_OFF:
        return BluetoothRadioStatus.OFF;
      case BluetoothState.RESETTING:
        return BluetoothRadioStatus.RESETTING;
      case BluetoothState.UNAUTHORIZED:
        return BluetoothRadioStatus.UNAUTH;
      case BluetoothState.UNSUPPORTED:
        return BluetoothRadioStatus.UNSUPPORT;
      case BluetoothState.UNKNOWN:
      default:
        return BluetoothRadioStatus.UNDEF;
    }
  }

  setRadio({BluetoothRadioStatus value: BluetoothRadioStatus.OFF}) {
    switch (value) {
      case BluetoothRadioStatus.ON:
        this.driver.enableRadio();
        break;
      case BluetoothRadioStatus.OFF:
      default:
        this.driver.disableRadio();
        break;
    }
  }


  // Switch Scanner
  switchRadio()async{
    switch(this.bluetoothScannerStatus){
      case BluetoothScannerStatus.ON:
        setRadio(value: ble.BluetoothRadioStatus.ON);
        setRadio(value: ble.BluetoothRadioStatus.ON);
        break;
      case BluetoothScannerStatus.OFF:
        setRadio(value: ble.BluetoothRadioStatus.OFF);
        break;
      case BluetoothScannerStatus.UNDEF:
      default:
        await this.stopScanner();
        break;
    }
  }
}
