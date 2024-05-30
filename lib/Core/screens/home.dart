import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:floating_frosted_bottom_bar/app/frosted_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grasscuttercontroler/Core/screens/motion.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Services/Get/get_navigation.dart';
import 'car.dart';
import 'ARM.dart';
import 'outonmusMode.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var light = false;
  var index = 0;
  GetNavigationBar controller = Get.put(GetNavigationBar());

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
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: FrostedBottomBar(
            borderRadius: BorderRadius.circular(50),
            bottom: 10,
            opacity: 1,
            curve: Curves.easeInOut,
            bottomBarColor: Colors.blue.withOpacity(.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TabBar(
                onTap: (value) {
                  controller.setIndex(value);
                },
                indicatorColor: Colors.orange,
                indicatorPadding: const EdgeInsets.symmetric(vertical: -8),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Obx(() => tabItem(controller.index.value == 0, Icons.home)),
                  Obx(
                    () => tabItem(
                        controller.index.value == 1, Icons.control_camera),
                  ),
                  Obx(() => tabItem(controller.index.value == 2,
                      Icons.motion_photos_on_sharp)),
                  Obx(() => tabItem(controller.index.value == 3, Icons.motion_photos_auto))
                ],
              ),
            ),
            body: (context, controller) {
              return TabBarView(
                children: [
                  Car(),
                  ARM(),
                  motion(),
                  OutanmousMode(),
                ],
              );
            },
          ),
        ));
  }

  Widget tabItem(bool state, IconData icon) {
    return state
        ? Icon(key: UniqueKey(), icon, color: Colors.white)
        : Icon(key: UniqueKey(), icon, color: Colors.deepOrange);
  }
}
