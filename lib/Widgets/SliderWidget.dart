
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  // Define a callback function to receive the slider value
  final ValueChanged<double>? onValueChanged;

  const SliderWidget({Key? key, this.onValueChanged}) : super(key: key);


  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _CurrentSliderValue =30;

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: _CurrentSliderValue,
        max: 100,
        divisions: 20,
        label: _CurrentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _CurrentSliderValue = value;
        });

        // Call the onValueChanged callback if provided
        widget.onValueChanged?.call(value);
      },);

        }

  }

