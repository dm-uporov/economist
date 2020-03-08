import 'package:flutter/material.dart';
import 'package:flutterapp2020/DatePickerLine.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(double width) : _width = width;

  final double _width;

  @override
  _DatePickerState createState() => _DatePickerState(_width);
}

class _DatePickerState extends State<DatePicker> {
  final double _width;
  final double _lineHeight = 48.0;
  final double _sectorWidth = 10.0;
  final double _selectorWidth = 40.0;
  final double _selectorHeight = 96.0;
  final double _selectorCircleIncreaseCoefficient = 1.8;

  final DateTime _currentDate = DateTime.now();
  DateTime _firstSelectorDate;
  DateTime _secondSelectorDate;

  List<DateWithPosition> _initDates;
  List<DateWithPosition> _datesWithPositions;

  _DatePickerState(double width) : _width = width {
    _initDates = computeDates(_currentDate, width, _sectorWidth, 0.0);
    _datesWithPositions = _initDates;
    _firstSelectorDate = _currentDate.subtract(Duration(days: 30));
    _secondSelectorDate = _currentDate;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          height: _selectorHeight,
          child: DatePickerLine(
            width: _width,
            height: _lineHeight,
            sectorWidth: _sectorWidth,
            currentDate: _currentDate,
            initDates: _initDates,
            callback: (datesWithPositions) {
              setState(() {
                _datesWithPositions = datesWithPositions;
              });
            },
          ),
        ),
        DatePickerSelector(
          _datesWithPositions,
          width: _selectorWidth,
          height: _selectorHeight,
          lineWidth: _width,
          circleIncreaseCoefficient: _selectorCircleIncreaseCoefficient,
          initDate: _firstSelectorDate,
          callback: (date) => _firstSelectorDate = date,
        ),
        DatePickerSelector(
          _datesWithPositions,
          width: _selectorWidth,
          height: _selectorHeight,
          lineWidth: _width,
          circleIncreaseCoefficient: _selectorCircleIncreaseCoefficient,
          initDate: _secondSelectorDate,
          callback: (date) => _secondSelectorDate = date,
        ),
      ],
    );
  }
}