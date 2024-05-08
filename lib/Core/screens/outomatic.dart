
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../Widgets/CircButtom.dart';
import '../../Widgets/text_widget.dart';
import '../../Services/Get/get_outomatic.dart';
class outomatic extends StatefulWidget {
  outomatic({super.key});

  @override
  State<outomatic> createState() => _outomaticState();
}

class _outomaticState extends State<outomatic> {
  final massageTextcontrolar=TextEditingController();
  final massageTextControlar=TextEditingController();
   final Getoutomatic controller = Get.put(Getoutomatic());
  late final int length;
  late final int width;


  bool selected = false;
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        height: double.infinity,
        width: double.infinity,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Center(
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                ),
                text(
                  "Arm Control",
                  30,
                  Colors.white,
                  FontWeight.bold,
                  letterspacel: 6,
                ),
                InkWell(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.motion_photos_auto,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(() =>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    circleButton(
                        Icons.autorenew, "Home",
                        controller.auto.value, () {
                          _sendData('AT HM');
                          print('1');

                    }),
                    circleButton(Icons.open_in_full_outlined, "open G",
                        controller.cool.value, () {
                          _sendData('AT GO');

                          print('1');

                        }),
                    circleButton(Icons.close_fullscreen_outlined, "close G",
                        controller.fan.value, () {
                          _sendData('AT GC');
                          print('1');

                        }),
                    circleButton(
                        Icons.upload, "Load",
                        controller.heat.value, () {
                      _sendData('AT L1');

                      print('1');

                    }),
                  ],
                ),),
            SizedBox(
              height: 1,
            ),
            Obx(() =>
                SleekCircularSlider(
                  innerWidget: (percentage) {
                    return const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage('assets/images/ARM.png'))


                            ],
                          ),
                        ));
                  },
                  appearance: const CircularSliderAppearance(
                    animationEnabled: true,
                    counterClockwise: true,
                    size: 280,
                    spinnerMode: false,
                    startAngle: 180,
                    angleRange: 180,
                  ),
                  initialValue: controller.value.value,
                  max: 170,
                  min: 10,
                  onChange: (value) async {
                  double rotat =value ;
                  print(value);
                  _sendData('SR BS $rotat');
                  },
                ),),
            const Spacer(),
            Expanded(
              flex: 6,
              // top: 320,
              // left: 0,
              // bottom: 80,
              // right: 0,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                ),
                width: double.infinity,
                height: 500.0,
                decoration:  BoxDecoration(
                  color: Colors.grey.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          circleButton(
                              Icons.catching_pokemon_outlined, "catch1", controller.auto.value,
                                  () {
                                print('1');
                                _sendData('AT C1');

                          }),
                          circleButton(Icons.catching_pokemon_outlined, "catch2",
                              controller.cool.value,
                                  () {
                                    print('1');
                                    _sendData('AT C2');
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(
                            "Automatic Grass \n     cutting",
                            20,
                            Colors.white,
                            FontWeight.bold,
                            letterspacel: 6,
                          ),

                        ],
                      ),
                       Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: massageTextcontrolar,
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 18
                              ),

                              onChanged:(value){
                                length=int.parse(value);
                                print(length);

                              } ,
                              keyboardType: TextInputType.number, // Example for numeric input
                              maxLength: 3, // Enforce a maximum of 3 characters
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter length",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0), // Add spacing between text fields
                          Expanded(
                            child: TextField(
                              onChanged: (value){
                                width=int.parse(value);
                                print(value);
                              },

                              style:TextStyle(
                                  color: Colors.black,
                                  fontSize: 18
                              ),
                              // Set desired text field properties here
                              controller: massageTextControlar,
                              keyboardType: TextInputType.number, // Example for numeric input
                              maxLength: 3, // Enforce a maximum of 3 characters
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter width ",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          circleButton(
                              Icons.start_outlined, "start", controller.auto.value,
                                  () {
                                print('$length-----$width');

                              }),
                          circleButton(Icons.stop_circle_outlined, "stop",
                              controller.cool.value,
                                  () {
                            massageTextcontrolar.clear();
                            massageTextControlar.clear();
                            length=0;
                            width=0;


                              }),
                        ],
                      ),



                    ],
                  ),
                ),
              ),

            ),


          ],
        ),
      ),

    );
  }
}