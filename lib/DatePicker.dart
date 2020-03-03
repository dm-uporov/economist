import 'package:flutter/material.dart';
import 'package:flutterapp2020/DatePickerLine.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  final _lineHeight = 30.0;
  final _selectorWidth = 30.0;
  final _selectorHeight = 80.0;
  final _selectorStrokeWidth = 10.0;
  final _selectorCircleRadius = 20.0;
  final _selectorCircleIncreasedRadius = 40.0;

  var _positionX = 100.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          height: _selectorHeight,
          child: DatePickerLine(
            height: _lineHeight,
            onPanUpdate: (details) {},
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 100),
          left: _positionX,
          child: DatePickerSelector(
            width: _selectorWidth,
            height: _selectorHeight,
            strokeWidth: _selectorStrokeWidth,
            circleRadius: _selectorCircleRadius,
            circleIncreasedRadius: _selectorCircleIncreasedRadius,
            onPanUpdate: (details) {
              setState(() {
                _positionX = details.globalPosition.dx - (_selectorWidth / 2);
              });
            },
          ),
        ),
      ],
    );
  }
}
