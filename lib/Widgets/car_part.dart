
import 'package:flutter/material.dart';
import 'package:grasscuttercontroler/Widgets/text_widget.dart';
class CarPart extends StatelessWidget {
  final bool state;
  final String name;
  final VoidCallback onTap;
  const CarPart({super.key, required this.state, required this.name,required this.onTap});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 100,
      width: 320,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: state ? Colors.red : Colors.transparent,
              blurRadius: state ? 50 : 0,
            )
          ],
          color: state ? Colors.deepOrange.shade900 : Colors.black.withOpacity(.5),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(name, 25, Colors.white, FontWeight.bold),
              const SizedBox(
                height: 10,
              ),
              text(state ? "Opened" : "Closed", 20,
                  Colors.white.withOpacity(.5), FontWeight.bold),
            ],
          ),
          const Spacer(),
          Transform.rotate(
            alignment: Alignment.centerRight,
            angle: 0,
            child: Transform.scale(
              scaleX: 1.5,
              scaleY: 1.5,
              child: Switch(

                activeColor: Colors.deepOrange.shade900,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(.1),
                value: state,
                onChanged: (value) => onTap(),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
