
import 'package:flutter/cupertino.dart';
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
                   Positioned(
                     top: 320,
                     left: 0,
                     bottom: 80,
                     right: 0,
                     child: Container(
                       padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                       width: double.infinity, // Ensures full width
                       height: 500.0, // Set a specific height
                       decoration: const BoxDecoration(
                         color: Colors.grey,
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(30),
                           topRight: Radius.circular(30),
                         ),
                       ),
                       child: SingleChildScrollView(
                         // Wrap the Column with SingleChildScrollView for scrolling
                         child: Column(
                         //  crossAxisAlignment: CrossAxisAlignment.start,
                           children: [

                             // Add your content here, ensuring they have appropriate sizing
                             // (e.g., limited height for Text widgets)
                           ],
                         ),
                       ),
                     ),
                   ),



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
