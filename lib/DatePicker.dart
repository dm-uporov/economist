import 'package:flutter/material.dart';
import 'package:flutterapp2020/DatePickerLine.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final _lineHeight = 48.0;
  final _selectorWidth = 30.0;
  final _selectorHeight = 96.0;
  final _selectorStrokeWidth = 4.0;
  final _selectorCircleRadius = 20.0;
  final _selectorCircleIncreasedRadius = 40.0;

  var _firstSelectorPosition = 100.0;
  var _secondSelectorPosition = 200.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          height: _selectorHeight,
          child: DatePickerLine(
            mainLineHeight: _lineHeight,
//            onTap: (details) {
//              setState(() {
//                final tapPosition = details.globalPosition.dx;
//                final firstSelectorDelta = tapPosition - _firstSelectorPosition;
//                final secondSelectorDelta = tapPosition - _secondSelectorPosition;
//                if (firstSelectorDelta.abs() < secondSelectorDelta.abs()) {
//                  _firstSelectorPosition = tapPosition - (_selectorWidth / 2);
//                } else {
//                  _secondSelectorPosition = tapPosition - (_selectorWidth / 2);
//                }
//              });
//            },
            onPanUpdate: (details) {},
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 100),
          left: _firstSelectorPosition,
          child: DatePickerSelector(
            width: _selectorWidth,
            height: _selectorHeight,
            strokeWidth: _selectorStrokeWidth,
            circleRadius: _selectorCircleRadius,
            circleIncreasedRadius: _selectorCircleIncreasedRadius,
            onPanUpdate: (details) {
              setState(() {
                _firstSelectorPosition = details.globalPosition.dx - (_selectorWidth / 2);
              });
            },
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 100),
          left: _secondSelectorPosition,
          child: DatePickerSelector(
            width: _selectorWidth,
            height: _selectorHeight,
            strokeWidth: _selectorStrokeWidth,
            circleRadius: _selectorCircleRadius,
            circleIncreasedRadius: _selectorCircleIncreasedRadius,
            onPanUpdate: (details) {
              setState(() {
                _secondSelectorPosition = details.globalPosition.dx - (_selectorWidth / 2);
              });
            },
          ),
        ),
      ],
    );
  }
}
