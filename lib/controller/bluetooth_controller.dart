import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  var bluetoothState = false.obs;
  var isConnecting = false.obs;
  BluetoothConnection? connection;
  var devices = <BluetoothDevice>[].obs;
  BluetoothDevice? deviceConnected;
  var times = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermission();
    _bluetooth.state.then((state) {
      bluetoothState.value = state.isEnabled;
    });

    _bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BluetoothState.STATE_OFF:
          bluetoothState.value = false;
          break;
        case BluetoothState.STATE_ON:
          bluetoothState.value = true;
          break;
      }
    });
  }

  void _requestPermission() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  void getDevices() async {
    var res = await _bluetooth.getBondedDevices();
    devices.value = res;
  }

  void receiveData() {
    connection?.input?.listen((event) {
      if (String.fromCharCodes(event) == "p") {
        times.value = times.value + 1;
      }
    });
  }

  void sendData(String data) {
    if (connection?.isConnected ?? false) {
      connection?.output.add(ascii.encode(data));
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    isConnecting.value = true;
    connection = await BluetoothConnection.toAddress(device.address);
    deviceConnected = device;
    devices.clear();
    isConnecting.value = false;
    receiveData();
  }

  void disconnect() async {
    await connection?.finish();
    deviceConnected = null;
  }

  Future<void> enableBluetooth() async {
    await _bluetooth.requestEnable();
  }

  Future<void> disableBluetooth() async {
    await _bluetooth.requestDisable();
  }
}
