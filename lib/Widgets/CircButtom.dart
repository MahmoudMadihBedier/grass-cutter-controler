
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grasscuttercontroler/Widgets/text_widget.dart';

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
                blurRadius: 20 ,
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

