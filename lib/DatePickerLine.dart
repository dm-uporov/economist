import 'package:flutter/material.dart';

import 'AnimatedSelector.dart';

class DatePickerLine extends StatefulWidget {
  @override
  _DatePickerLineState createState() => _DatePickerLineState();
}

class _DatePickerLineState extends State<DatePickerLine> {

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 50.0,
            color: Colors.black,
          ),
          AnimatedSelector(),
        ],
      ),
    );
  }
}
