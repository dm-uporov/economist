import 'package:flutter/material.dart';
import 'package:flutterapp2020/datepicker/DatePickerLine.dart';

import 'DatePickerSelector.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    this.width,
    this.lineHeight,
    this.selectorSize,
  });

  /// The full width of date picker line
  final double width;

  /// The height of solid line background
  final double lineHeight;

  /// Diameter of selector bubble, as well as height of picker under the main line
  final double selectorSize;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  _DatePickerState() {
    datesWithPositions = computeDates(currentDate, widget.width, sectorWidth, 0.0);
    firstSelectorDate = currentDate.subtract(Duration(days: 30));
    secondSelectorDate = currentDate;
    selectorWidth = widget.selectorSize;
    selectorHeight = widget.lineHeight + widget.selectorSize;
  }

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
            width: widget.width,
            height: widget.lineHeight,
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
          lineWidth: widget.width,
          circleIncreaseCoefficient: selectorCircleIncreaseCoefficient,
          initDate: firstSelectorDate,
          callback: (date) => firstSelectorDate = date,
        ),
        DatePickerSelector(
          datesWithPositions,
          width: selectorWidth,
          height: selectorHeight,
          sectorWidth: sectorWidth,
          lineWidth: widget.width,
          circleIncreaseCoefficient: selectorCircleIncreaseCoefficient,
          initDate: secondSelectorDate,
          callback: (date) => secondSelectorDate = date,
        ),
      ],
    );
  }
}
