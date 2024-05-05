
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../Widgets/text_widget.dart';
import 'get_climate.dart';
class Climate extends StatefulWidget {
  Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  final GetClimate controller=Get.put(GetClimate());

  bool selected =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      //  child:
           Container(
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
                      color:  Colors.white,
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
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  circleButton(Icons.autorenew, "Home",controller.auto.value,() {controller.setAuto();}),
                  circleButton(Icons.open_in_full_outlined, "open G",controller.cool.value, () {controller.setCool();}),
                  circleButton(Icons.close_fullscreen_outlined, "close G",controller.fan.value, () {controller.setFan();}),
                  circleButton(Icons.upload, "Load",controller.heat.value, () {controller.setHeat();}),
                ],
              ),),
              const Spacer(),
              Obx(() => SleekCircularSlider(
                innerWidget: (percentage) {
                  return Align(
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
                appearance: CircularSliderAppearance(
                  animationEnabled: true,
                  counterClockwise: true,
                  size: 280,
                  spinnerMode: false,
                  startAngle: 180,
                  angleRange: 180,
                ),
                initialValue: controller.value.value,
                max: 100,
                min: 0.0,
                onChange: (value) async {
                  controller.setValue(value);
                },
              ),),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey.shade900,
                height: 250,
                width: double.infinity,
                child: Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(onPressed: (){}, child:Text('catch 1')),
                            ElevatedButton(onPressed: (){}, child:Text('catch 2'))
                          ],
                        ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                text('Automatic Grass Cutting', 18,
                                  Colors.white,
                                  FontWeight.bold,
                                  letterspacel: 6,)
                              ],
                            ),
                            Row(
                              children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  onChanged: (value){
                                    //send data
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'enter the length'
                                  ),
                                )

                              ],
                            )
                            // Obx(() => Container(
                            //   padding: const EdgeInsets.only(right: 20),
                            //   height: 120,
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: controller.ac.value
                            //               ? Colors.blue
                            //               : Colors.blue.shade900.withOpacity(.1),
                            //           blurRadius: controller.ac.value ? 40 : 0,
                            //         )
                            //       ],
                            //       borderRadius: BorderRadius.circular(15),
                            //       color:
                            //       controller.ac.value
                            //           ? Colors.blue
                            //           : Colors.blue.shade900.withOpacity(.1)),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           text(controller.ac.value ? "AC is on" : "AC is off", 25, Colors.white,
                            //               FontWeight.bold),
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //           text("   Currently ${controller.value.value.ceil()} C", 18,
                            //               Colors.white.withOpacity(.5), FontWeight.bold)
                            //         ],
                            //       ),
                            //       Transform.scale(
                            //         scale: 1.5,
                            //         child: Switch(
                            //           activeTrackColor: Colors.blue.shade900,
                            //           activeColor: Colors.blue,
                            //           value: controller.ac.value,
                            //           onChanged: (value) => controller.setAc(),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // )),
                          ,
                     ],
                ),

              ),



              const Spacer(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget circleButton(IconData icon,String text_,bool state,VoidCallback onTap){
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: state ? 20 : 0,
                )
              ],
              color: state ? Colors.blue : Colors.blue.shade900,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        text(text_, 16, Colors.white,
            FontWeight.bold)
      ],
    );
  }
}
