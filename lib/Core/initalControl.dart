// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../Services/Get/get_car.dart';
// import '../Widgets/car_part.dart';
// import '../Widgets/text_widget.dart';
//
// class ControlScreen extends StatefulWidget {
//
//   final GetCar controller = Get.put(GetCar());
//
//   @override
//   State<ControlScreen> createState() => _ControlScreenState();
// }
//
// class _ControlScreenState extends State<ControlScreen> {
//   final _bluetooth = FlutterBluetoothSerial.instance;
//   bool _bluetoothState = false;
//   bool _isConnecting = false;
//   BluetoothConnection? _connection;
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _deviceConnected;
//   int times = 0;
//
//   void _getDevices() async {
//     var res = await _bluetooth.getBondedDevices();
//     setState(() => _devices = res);
//   }
//
//   void _receiveData() {
//     _connection?.input?.listen((event) {
//       if (String.fromCharCodes(event) == "p") {
//         setState(() => times = times + 1);
//       }
//     });
//   }
//
//   void _sendData(String data) {
//     if (_connection?.isConnected ?? false) {
//       _connection?.output.add(ascii.encode(data));
//     }
//   }
//
//   void _requestPermission() async {
//     await Permission.location.request();
//     await Permission.bluetooth.request();
//     await Permission.bluetoothScan.request();
//     await Permission.bluetoothConnect.request();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _requestPermission();
//
//     _bluetooth.state.then((state) {
//       setState(() => _bluetoothState = state.isEnabled);
//     });
//
//     _bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BluetoothState.STATE_OFF:
//           setState(() => _bluetoothState = false);
//           break;
//         case BluetoothState.STATE_ON:
//           setState(() => _bluetoothState = true);
//           break;
//       // case BluetoothState.STATE_TURNING_OFF:
//       //   break;
//       // case BluetoothState.STATE_TURNING_ON:
//       //   break;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.deepOrange.shade900,
//                   Colors.black,
//                 ])),
//         child: Column(
//           children: [
//             Expanded(
//                 flex: 4,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: 100,
//                       left: 50,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Container(
//                           height: 300,
//                           width: 350,
//                           decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                   image: AssetImage('assets/images/car.png'))),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                         top: 70,
//                         left: 30,
//                         right: 30,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             text(
//                               "the vehicle ",
//                               30,
//                               Colors.white,
//                               FontWeight.bold,
//                               letterspacel: 8.0,
//                             ),
//                             InkWell(
//                               child: Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white10,
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.sunny,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         )),
//                     Positioned(
//                         top: 120,
//                         left: 25,
//                         child: text(" model 1.0", 20.0,
//                             Colors.white.withOpacity(.5), FontWeight.bold))
//                   ],
//                 )),
//             Expanded(
//                 flex: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       text("CONTROLS", 30, Colors.white, FontWeight.bold),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Obx(
//                                 () => CarPart(name: "Engine",state: controller.engin.value,
//                                 onTap: () => controller.setEngine()),
//                           ),
//                           Obx(
//                                 () => CarPart(name: "Door",state:  controller.door.value,
//                                 onTap:  () => controller.setDoor()),
//                           )
//                         ],
//                       ),
//
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Obx(
//                                 () => CarPart(name: "Trunk",state:  controller.trunk.value,
//                                 onTap:  () => controller.setTrunk()),
//                           ),
//                           Obx(
//                                 () => CarPart(name: "Climate",state:  controller.climate.value,
//                                 onTap:  () => controller.setClimate()),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
