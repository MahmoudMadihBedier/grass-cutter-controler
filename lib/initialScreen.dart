import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:grasscuttercontroler/Core/initalControl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Widgets/ActionButton.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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
        // case BluetoothState.STATE_TURNING_OFF:
        //   break;
        // case BluetoothState.STATE_TURNING_ON:
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrange.shade900,
                Colors.black,
              ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Gress vechile controlor ',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Column(
          children: [
            _controlBT(),
            _infoDevice(),
            Expanded(child: _listDevices()),
            // _inputSerial(),
            _ToControler(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  Widget _controlBT() {
    return SwitchListTile(
      value: _bluetoothState,
      onChanged: (bool value) async {
        if (value) {
          await _bluetooth.requestEnable();
        } else {
          await _bluetooth.requestDisable();
        }
      },
      tileColor: Colors.black26,
      title: Text(
          _bluetoothState ? "Bluetooth connect" : "Bluetooth disconnect",
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  Widget _infoDevice() {
    return ListTile(
      tileColor: Colors.black12,
      title: Text("Conected to : ${_deviceConnected?.name ?? "none"}",
          style: TextStyle(color: Colors.white, fontSize: 10)),
      trailing: _connection?.isConnected ?? false
          ? TextButton(
              onPressed: () async {
                await _connection?.finish();
                setState(() => _deviceConnected = null);
              },
              child: const Text("disconnect"),
            )
          : TextButton(
              onPressed: _getDevices,
              child: const Text("View devices"),
            ),
    );
  }

  Widget _listDevices() {
    return _isConnecting
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  ...[
                    for (final device in _devices)
                      ListTile(
                        title: Text(device.name ?? device.address),
                        trailing: TextButton(
                          child: const Text('connect'),
                          onPressed: () async {
                            setState(() => _isConnecting = true);

                            _connection = await BluetoothConnection.toAddress(
                                device.address);
                            _deviceConnected = device;
                            _devices = [];
                            _isConnecting = false;

                            _receiveData();

                            setState(() {});
                          },
                        ),
                      )
                  ]
                ],
              ),
            ),
          );
  }

  // Widget _inputSerial() {
  //   return ListTile(
  //     trailing: TextButton(
  //       child: const Text('restart'),
  //       onPressed: () => setState(() => times = 0),
  //     ),
  //     title: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 16.0),
  //       child: Text(
  //         "Push button pressed (x$times)",
  //         style: const TextStyle(fontSize: 18.0),
  //       ),
  //     ),
  //   );
  // }
  Widget _ToControler() {
    return ListTile(
      trailing: TextButton(
        child: const Text('Go to controler',style: TextStyle(color: Colors.green),),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ControlScreen()));
        },
      ),
      title: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          "cheack by apply the light and just ==>",
          style: TextStyle(fontSize:8 ,color: Colors.white),
        ),
      ),
    );
  }

  Widget _buttons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      color: Colors.black12,
      child: Column(
        children: [
          const Text('check the vecilhe connected ', style: TextStyle(color: Colors.white,fontSize: 18.0)),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: "Light",
                  color: Colors.green,
                  onTap: () => _sendData("MF LD 1"),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: ActionButton(
                  color: Colors.red,
                  text: "To turn off",
                  onTap: () => _sendData("MF LD 0"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
