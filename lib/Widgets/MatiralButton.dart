//mybutton
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class regsterButton extends StatelessWidget {
  final Color color;
  final String title ;
  final VoidCallback onprassed ;
  regsterButton({required this.color ,required this.title,required this.onprassed});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed:onprassed ,
          minWidth: 200,
          height: 42,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
          ),


        ),
      ),
    );
  }
}
