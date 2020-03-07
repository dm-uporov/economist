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
  var _secondSelectorPosition = 260.0;

  DateTime _firstSelectorDate;
  DateTime _secondSelectorDate;

  List<DateWithPosition> _datesWithPositions;

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
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateFirstSelectorPosition();
    _updateSecondSelectorPosition();
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          height: _selectorHeight,
          child: DatePickerLine(
            mainLineHeight: _lineHeight,
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
                _firstSelectorPosition =
                    details.globalPosition.dx - (_selectorWidth / 2);
                _updateFirstSelectorPosition(force: true);
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
                _secondSelectorPosition =
                    details.globalPosition.dx - (_selectorWidth / 2);
                _updateSecondSelectorPosition(force: true);
              });
            },
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

  double _positionByDate(DateTime date, double fallbackPosition) {
    if (date == null) return fallbackPosition;
    if (_datesWithPositions == null) return fallbackPosition;
    if (_datesWithPositions.isEmpty) return fallbackPosition;

    final found = _datesWithPositions.firstWhere(
      (element) => element.date == date,
      orElse: () => null,
    );
    if (found != null) return found.position;

    if (_datesWithPositions.first.date.isAfter(date)) {
      return 0.0;
    } else {
      return 360.0;
    }
  }
}
