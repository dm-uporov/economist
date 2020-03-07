import 'package:flutter/material.dart';
import 'package:flutterapp2020/DatePickerLine.dart';
import 'package:intl/intl.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(double width) :_width = width;

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

  double _firstSelectorPosition = 100.0;
  double _secondSelectorPosition = 260.0;

  DateTime _currentDate = DateTime.now();
  DateTime _firstSelectorDate;
  DateTime _secondSelectorDate;

  List<DateWithPosition> _initDates;
  List<DateWithPosition> _datesWithPositions;

  _DatePickerState(double width) : _width = width {
    _initDates = computeDates(_currentDate, width, _sectorWidth, 0.0);
    _datesWithPositions = _initDates;
    _firstSelectorDate = _currentDate.subtract(Duration(days: 30));
    _secondSelectorDate = _currentDate;
    _updateFirstSelectorPosition();
    _updateSecondSelectorPosition();
  }

  ///
  /// `force` mean ignore current selector date
  ///
  void _updateFirstSelectorPosition({bool force = false}) {
    if (_firstSelectorDate == null || force) {
      _firstSelectorDate = _findCloserDateByPosition(_firstSelectorPosition);
    }
    _firstSelectorPosition = _positionByDate(
      _firstSelectorDate,
      _firstSelectorPosition,
      _width,
    );
  }

  ///
  /// `force` mean ignore current selector date
  ///
  void _updateSecondSelectorPosition({bool force = false}) {
    if (_secondSelectorDate == null || force) {
      _secondSelectorDate = _findCloserDateByPosition(_secondSelectorPosition);
    }
    _secondSelectorPosition = _positionByDate(
      _secondSelectorDate,
      _secondSelectorPosition,
      _width,
    );
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
                _updateFirstSelectorPosition();
                _updateSecondSelectorPosition();
              });
            },
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 50),
          left: _firstSelectorPosition,
          child: DatePickerSelector(
            width: _selectorWidth,
            height: _selectorHeight,
            circleIncreaseCoefficient: _selectorCircleIncreaseCoefficient,
            onPanUpdate: (details) {
              setState(() {
                _firstSelectorPosition =
                    details.globalPosition.dx - (_selectorWidth / 2);
                _updateFirstSelectorPosition(force: true);
              });
            },
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 50),
          left: _secondSelectorPosition,
          child: Stack(
            children: <Widget>[
              DatePickerSelector(
                width: _selectorWidth,
                height: _selectorHeight,
                circleIncreaseCoefficient: _selectorCircleIncreaseCoefficient,
                onPanUpdate: (details) {
                  setState(() {
                    _secondSelectorPosition =
                        details.globalPosition.dx - (_selectorWidth / 2);
                    _updateSecondSelectorPosition(force: true);
                  });
                },
              ),
              Text(
                _secondSelectorDate == null
                    ? "null"
                    : DateFormat.d().format(_secondSelectorDate),
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime _findCloserDateByPosition(double position) {
    final date = _findCloserDateWithPositionByPosition(position);
    return date == null ? null : date.date;
  }

  DateWithPosition _findCloserDateWithPositionByPosition(double position) {
    if (_datesWithPositions != null) {
      for (DateWithPosition date in _datesWithPositions) {
        final delta = (date.position - position).abs();
        if (delta <= 5.0) {
          return date;
        }
      }
    }
    return null;
  }

  double _positionByDate(DateTime date,
      double fallbackPosition,
      double maxPosition,) {
    if (date == null) return fallbackPosition;
    if (_datesWithPositions == null) return fallbackPosition;
    if (_datesWithPositions.isEmpty) return fallbackPosition;

    final found = _datesWithPositions.firstWhere(
          (element) => element.date == date,
      orElse: () => null,
    );
    if (found != null) return found.position - _selectorWidth / 2;

    if (_datesWithPositions.first.date.isAfter(date)) {
      return -_selectorWidth / 2;
    } else {
      return maxPosition - _selectorWidth / 2;
    }
  }
}
