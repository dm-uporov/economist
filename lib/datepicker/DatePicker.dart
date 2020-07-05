import 'package:flutter/material.dart';
import 'package:flutterapp2020/datepicker/DatePickerLine.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    @required this.width,
    @required this.lineHeight,
    @required this.selectorSize,
    @required this.callback,
    @required this.initFromDate,
    @required this.initToDate,
  });

  /// The full width of date picker line
  final double width;

  /// The height of solid line background
  final double lineHeight;

  /// Diameter of selector bubble, as well as height of picker under the main line
  final double selectorSize;

  final DateTime initFromDate;
  final DateTime initToDate;

  final DatesUpdatesCallback callback;

  @override
  _DatePickerState createState() => _DatePickerState(
        width,
        lineHeight,
        selectorSize,
        initFromDate,
        initToDate,
      );
}

class _DatePickerState extends State<DatePicker> {
  _DatePickerState(
    this.width,
    this.lineHeight,
    this.selectorSize,
    this.firstSelectorDate,
    this.secondSelectorDate,
  ) {
    datesWithPositions = computeDates(currentDate, width, sectorWidth, 0.0);
    selectorWidth = selectorSize;
    selectorHeight = lineHeight + selectorSize;
  }

  /// The full width of date picker line
  final double width;

  /// Height of solid line background
  final double lineHeight;

  /// Diameter of selector bubble, as well as height of picker under the main line
  final double selectorSize;

  /// The init gap between sectors (days by default)
  final double sectorWidth = 10.0;

  /// Diameter of selector circle
  double selectorWidth;

  /// Height of selector (from top of line to bottom of circle)
  double selectorHeight;

  /// max coefficient to selector increase animation
  final double selectorCircleIncreaseCoefficient = 1.8;

  /// because of main use case the date picker (economist)
  /// the current date will appear closer to the end of line
  /// TODO add ability to change this behavior
  final DateTime currentDate = DateTime.now();

  /// by default left selector selected date
  /// user can change position manually, so it is `first` selector instead of `left`
  DateTime firstSelectorDate;

  /// right selector selected date
  DateTime secondSelectorDate;

  /// visible dates and theirs positions by the x axis
  List<DateWithPosition> datesWithPositions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          height: selectorHeight,
          child: DatePickerLine(
            width: width,
            height: lineHeight,
            sectorWidth: sectorWidth,
            currentDate: currentDate,
            initDates: datesWithPositions,
            callback: (newDatesWithPositions) {
              setState(() {
                datesWithPositions = newDatesWithPositions;
              });
            },
          ),
        ),
        DatePickerSelector(
          datesWithPositions,
          width: selectorWidth,
          height: selectorHeight,
          sectorWidth: sectorWidth,
          lineWidth: width,
          circleIncreaseCoefficient: selectorCircleIncreaseCoefficient,
          initDate: firstSelectorDate,
          callback: (date) {
            if (firstSelectorDate != date) {
              firstSelectorDate = date;
              _onDatesUpdated();
            }
          },
        ),
        DatePickerSelector(
          datesWithPositions,
          width: selectorWidth,
          height: selectorHeight,
          sectorWidth: sectorWidth,
          lineWidth: width,
          circleIncreaseCoefficient: selectorCircleIncreaseCoefficient,
          initDate: secondSelectorDate,
          callback: (date) {
            if (secondSelectorDate != date) {
              secondSelectorDate = date;
              _onDatesUpdated();
            }
          },
        ),
      ],
    );
  }

  void _onDatesUpdated() {
    if (firstSelectorDate.isBefore(secondSelectorDate)) {
      widget.callback(firstSelectorDate, secondSelectorDate);
    } else {
      widget.callback(secondSelectorDate, firstSelectorDate);
    }
  }
}

typedef DatesUpdatesCallback = Function(DateTime from, DateTime to);
