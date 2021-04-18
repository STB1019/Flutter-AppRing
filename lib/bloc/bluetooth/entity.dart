import 'package:flutter_ble_lib/flutter_ble_lib.dart';

/**
 *
 */
class Device {
  Peripheral entity;
  String label, uuid,addr;

  Device();

  factory Device.fromMap(BleManager bleManager, Map<String, dynamic> input) {
    Device obj = Device();
    obj.label = input["label"] ?? "Default";
    obj.uuid = input["uuid"] ?? "00000000-0000-0000-8000-000000000000";
    obj.addr = "";
    obj.entity = bleManager.createUnsafePeripheral(obj.uuid.toString());
    return obj;
  }

  Future<void> connect() async {
    return await entity.connect().then((value){
      addr=entity.name;
      return value;
    }, onError: (e) {});
  }

  Future<bool> isConnected() async {
    return await entity.isConnected();
  }

  Future<void> disconnect() async {
    return await entity.disconnectOrCancelConnection();
  }

  Future<List<Service>> listServices() async {
    return await entity.services();
  }

  discovering() async {
    await entity.discoverAllServicesAndCharacteristics();
  }
}
