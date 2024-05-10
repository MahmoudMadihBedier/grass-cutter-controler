
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Services/Get/get_car.dart';
import '../../Widgets/car_part.dart';
import '../../Widgets/text_widget.dart';

class Car extends StatefulWidget {
  Car({super.key});

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  final GetCar controller = Get.put(GetCar());

  final _bluetooth = FlutterBluetoothSerial.instance;

  bool _bluetoothState = false;

  bool _isConnecting = false;

  BluetoothConnection? _connection;

  List<BluetoothDevice> _devices = [];

  BluetoothDevice? _deviceConnected;

  int times = 0;

  void _getDevices() async {
    var res = await _bluetooth.getBondedDevices();
    setState(() => _devices = res);
  }

  void _receiveData() {
    _connection?.input?.listen((event) {
      if (String.fromCharCodes(event) == "p") {
        setState(() => times = times + 1);
      }
    });
  }

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

  @override
  void initState() {
    super.initState();

    _requestPermission();

    _bluetooth.state.then((state) {
      setState(() => _bluetoothState = state.isEnabled);
    });

    _bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BluetoothState.STATE_OFF:
          setState(() => _bluetoothState = false);
          break;
        case BluetoothState.STATE_ON:
          setState(() => _bluetoothState = true);
          break;
      case BluetoothState.STATE_TURNING_OFF:
        break;
      case BluetoothState.STATE_TURNING_ON:
        break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.deepOrange.shade900,
              Colors.black,
            ])),
        child: Column(
          children: [
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned(
                      top: 100,
                      left: 50,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 300,
                          width: 350,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/car.png'))),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 70,
                        left: 30,
                        right: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                              "the vehicle ",
                              30,
                              Colors.white,
                              FontWeight.bold,
                              letterspacel: 8.0,
                            ),
                            InkWell(
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white10,
                                ),
                                child:  Center(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.horizontal_distribute,
                                      color: Colors.white,
                                    ),
                                      onPressed:(){
                                      print('0000000');

                                      _sendData('MF BZ');
                                      },
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                        top: 120,
                        left: 25,
                        child: text(" model 1.0", 20.0,
                            Colors.white.withOpacity(.5), FontWeight.bold))
                  ],
                )),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("CONTROLS", 30, Colors.white, FontWeight.bold),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Obx(
                          //   () => CarPart(name: "Engine",state: controller.engin.value,
                          //      onTap: () => controller.setEngine()),
                          // ),
                          Obx(
                            () => CarPart(name: "sensor",state:  controller.sensor.value,
                               onTap:  () => controller.setsensor()),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Obx(
                          //   () => CarPart(name: "Arm",state:  controller.arm.value,
                          //      onTap:  () => controller.setarm()),
                          // ),
                          Obx(
                            () => CarPart(name: "Cutter",state:  controller.cutter.value,
                               onTap:  () => controller.setcutter()),
                          )
                        ],
                      ),
                       SizedBox(
                        height: 50,
                      )
                    ],

                  ),
                ))
          ],
        ),
      ),
    );
  }
}
