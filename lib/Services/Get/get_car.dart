 import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

 final _bluetooth = FlutterBluetoothSerial.instance;

 bool _bluetoothState = false;

 bool _isConnecting = false;

 BluetoothConnection? _connection;

 List<BluetoothDevice> _devices = [];

 BluetoothDevice? _deviceConnected;

 int times = 0;

 // void _getDevices() async {
 //   var res = await _bluetooth.getBondedDevices();
 //   setState(() => _devices = res);
 // }

 // void _receiveData() {
 //   _connection?.input?.listen((event) {
 //     if (String.fromCharCodes(event) == "p") {
 //       setState(() => times = times + 1);
 //     }
 //   });
 // }

 void _sendData(String data) {
   if (_connection?.isConnected ?? false) {
     _connection?.output.add(ascii.encode(data));
   }
 }

 void _requestPermission() async {
   await Permission.location.request();
   await Permission.bluetooth.request();
   await Permission.bluetoothScan.request();
   await Permission.bluetoothConnect.request();
 }

 // @override
 // void initState() {
 //   super.initState();
 //
 //   _requestPermission();
 //
 //   _bluetooth.state.then((state) {
 //     setState(() => _bluetoothState = state.isEnabled);
 //   });

 //   bluetooth.onStateChanged().listen((state) {
 //     switch (state) {
 //       case BluetoothState.STATE_OFF:
 //         setState(() => _bluetoothState = false);
 //         break;
 //       case BluetoothState.STATE_ON:
 //         setState(() => _bluetoothState = true);
 //         break;
 //     // case BluetoothState.STATE_TURNING_OFF:
 //     //   break;
 //     // case BluetoothState.STATE_TURNING_ON:
 //     //   break;
 //     }
 //   });
 // }


class GetCar extends GetxController{
  RxBool engin=true.obs;
  RxBool sensor=false.obs;
  RxBool arm=true.obs;
  RxBool cutter=false.obs;



   setEngine(){
    engin.value=!engin.value;
    // _sendData("Enginparmeter");
    // print(0);
  }
   setsensor(){
     sensor.value=!sensor.value;
     if( sensor ==true) {
       _sendData('Sensor parmeter to work ');
       print("1");
     }else{
       _sendData('Sensor parmeter to  srop work ');
       print("0");
     }

  }
  setarm(){    // if( arm ==true) {
    //   _sendData('arm parmeter to work ');
    //   print("1");
    // }else{
    //   _sendData('arm parmeter to  srop work ');
    //   print("0");
    // }
    arm.value=!arm.value;

  }
    setcutter(){
    cutter.value=!cutter.value;
    if( cutter ==true) {
      _sendData('cutter parmeter to work ');
      print("1");
    }else{
      _sendData('cutter parmeter to  srop work ');
      print("0");
    }
  }

}