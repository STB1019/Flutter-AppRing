import 'package:appring/orm/entity/__init__.dart';

import 'bluetooth/entity.dart' as ble;

class ProxyEntity {
  ble.Device bluetooth;
  DeviceHardware dbModel;
  ProxyEntity();

  ble.Device get hw=>bluetooth;
  set hw(ble.Device hw){
    bluetooth=hw;
  }

  DeviceHardware get sw=>dbModel;
  set sw(DeviceHardware sw){
    dbModel=sw;
  }

  factory ProxyEntity.FromHW(ble.Device bluetoothDevice) {
    ProxyEntity obj = ProxyEntity();
    obj.hw=bluetoothDevice;
    obj.sw=DeviceHardware();
    return obj;
  }
}
