import 'package:flutter/material.dart';
import 'package:flutterapp2020/datepicker/DatePickerLine.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(double width, lineHeight)
      : _width = width,
        _lineHeight = lineHeight;

  /// full width of date picker line
  final double _width;

  /// height of solid line background
  final double _lineHeight;

  @override
  _DatePickerState createState() => _DatePickerState(_width, _lineHeight);
}

class _DatePickerState extends State<DatePicker> {
  _DatePickerState(double width, double lineHeight)
      : _width = width,
        _lineHeight = lineHeight {
    _datesWithPositions = computeDates(_currentDate, width, _sectorWidth, 0.0);
    _firstSelectorDate = _currentDate.subtract(Duration(days: 30));
    _secondSelectorDate = _currentDate;
  }

  /// full width of date picker line
  final double _width;

  /// height of solid line background
  final double _lineHeight;

  /// init gap between sectors (days by default)
  final double _sectorWidth = 10.0;

  /// diameter of selector circle
  final double _selectorWidth = 40.0;

  /// height of selector (from top of line to bottom of circle)
  final double _selectorHeight = 96.0;

  /// max coefficient to selector increase animation
  final double _selectorCircleIncreaseCoefficient = 1.8;

  /// because of main use case the date picker (economist)
  /// the current date will appear closer to the end of line
  /// TODO add ability to change this behavior
  final DateTime _currentDate = DateTime.now();

  /// by default left selector selected date
  /// user can change position manually, so it is `first` selector instead of `left`
  DateTime _firstSelectorDate;

  /// right selector selected date
  DateTime _secondSelectorDate;

  /// visible dates and theirs positions by the x axis
  List<DateWithPosition> _datesWithPositions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          height: _selectorHeight,
          child: DatePickerLine(
            width: _width,
            height: _lineHeight,
            sectorWidth: _sectorWidth,
            currentDate: _currentDate,
            initDates: _datesWithPositions,
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
          sectorWidth: _sectorWidth,
          lineWidth: _width,
          circleIncreaseCoefficient: _selectorCircleIncreaseCoefficient,
          initDate: _firstSelectorDate,
          callback: (date) => _firstSelectorDate = date,
        ),
        DatePickerSelector(
          _datesWithPositions,
          width: _selectorWidth,
          height: _selectorHeight,
          sectorWidth: _sectorWidth,
          lineWidth: _width,
          circleIncreaseCoefficient: _selectorCircleIncreaseCoefficient,
          initDate: _secondSelectorDate,
          callback: (date) => _secondSelectorDate = date,
        ),
      ],
    );
  }
}
