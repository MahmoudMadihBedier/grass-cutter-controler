import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Services/Get/animatedPosition.dart';
import '../../Widgets/text_widget.dart';

class OutanmousMode extends StatefulWidget {
  const OutanmousMode({super.key});

  @override
  State<OutanmousMode> createState() => _OutanmousModeState();
}

class _OutanmousModeState extends State<OutanmousMode> {
  bool selected = false;
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
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.horizontal_distribute,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // _sendData(' Horn  Parameter');
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "let autonomous take \n  CONTROLS",
                        30,
                        Colors.white,
                        FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Container(
                        padding: EdgeInsets.all(40),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, 
                            MaterialPageRoute(
                                builder: (context)=>Climate())
                            );

                          },
                          child: text(
                            "lets go ",
                            30,
                            Colors.white,
                            FontWeight.bold,
                          ),
                        ),

                      ),

                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }}