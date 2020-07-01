import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'DatePickerLine.dart';

class DatePickerSelector extends StatefulWidget {
  DatePickerSelector(
    List<DateWithPosition> datesWithPositions, {
    this.width,
    this.height,
    this.sectorWidth,
    this.lineWidth,
    double circleIncreaseCoefficient = 2.0,
    double strokeWidth = 4.0,
    DateTime initDate,
    OnDateSelectedCallback callback,
  })  : _circleRadius = width / 2,
        _circleIncreasedRadius = width / 2 * circleIncreaseCoefficient,
        _strokeWidth = strokeWidth,
        _initDate = initDate,
        _datesWithPositions = datesWithPositions,
        _callback = callback;

  final double width;
  final double height;
  final double sectorWidth;
  final double lineWidth;
  final double _circleRadius;
  final double _circleIncreasedRadius;
  final double _strokeWidth;
  final DateTime _initDate;
  final List<DateWithPosition> _datesWithPositions;
  final OnDateSelectedCallback _callback;

  @override
  _DatePickerSelectorState createState() {
    return _DatePickerSelectorState(
      width,
      height,
      sectorWidth,
      lineWidth,
      _circleRadius,
      _circleIncreasedRadius,
      _strokeWidth,
      _initDate,
      _datesWithPositions,
      _callback,
    );
  }
}

class _DatePickerSelectorState extends State<DatePickerSelector>
    with SingleTickerProviderStateMixin {
  _DatePickerSelectorState(
    this.width,
    this.height,
    this.sectorWidth,
    this.lineWidth,
    this.circleRadius,
    this.circleIncreasedRadius,
    this.strokeWidth,
    DateTime initDate,
    List<DateWithPosition> datesWithPositions,
    OnDateSelectedCallback callback,
  )   : _date = initDate,
        _datesWithPositions = datesWithPositions,
        _maxPosition = lineWidth - (width / 2),
        _minPosition = width / 2,
        _callback = callback {
    _updatePositionByDate(initDate);
  }

  final double width;
  final double height;
  final double sectorWidth;
  final double lineWidth;
  final double circleRadius;
  final double circleIncreasedRadius;
  final double strokeWidth;
  List<DateWithPosition> _datesWithPositions;
  final OnDateSelectedCallback _callback;

  final double _maxPosition;
  final double _minPosition;

  DateTime _date;

  Animation<double> _increaseAnimation;
  AnimationController _increaseAnimationController;

  double _circleIncreaseCoefficient = 0.0;
  double _selectorPosition;

  @override
  void initState() {
    super.initState();
    _increaseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(DatePickerSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (datesDidChanged(oldWidget)) {
      setState(() {
        _datesWithPositions = oldWidget._datesWithPositions;
        _updatePositionByDate(_date);
      });
    }
  }

  bool datesDidChanged(DatePickerSelector oldWidget) {
    if (_datesWithPositions == null || _datesWithPositions.isEmpty) {
      return oldWidget._datesWithPositions != null &&
          oldWidget._datesWithPositions.isNotEmpty;
    }
    if (oldWidget._datesWithPositions == null ||
        oldWidget._datesWithPositions.isEmpty) {
      return _datesWithPositions != null && _datesWithPositions.isNotEmpty;
    }

    final first = _datesWithPositions.first;
    final oldFirst = oldWidget._datesWithPositions.first;
    final last = _datesWithPositions.last;
    final oldLast = oldWidget._datesWithPositions.last;
    return first.date != oldFirst.date ||
        first.position != oldFirst.position ||
        last.date != oldLast.date ||
        last.position != oldLast.position;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      height: height,
      duration: Duration(milliseconds: 30),
      left: _selectorPosition - (width / 2),
      child: GestureDetector(
        onPanStart: (details) {
          _increaseAnimationController.forward();
          _increaseAnimation = Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: _increaseAnimationController,
              curve: Curves.bounceOut,
              reverseCurve: Curves.linear,
            ),
          )..addListener(() {
              setState(() {
                _circleIncreaseCoefficient = _increaseAnimation.value;
              });
            });
        },
        onPanEnd: (details) {
          _increaseAnimationController.animateBack(0.0);
        },
        onPanUpdate: (details) {
          setState(() {
            final pointer = details.globalPosition.dx + (width / 2);
            _date = _findCloserDateByPosition(pointer);
            _callback.call(_date);
            _updatePositionByDate(_date);
          });
        },
        child: CustomPaint(
          size: Size(width, height),
          painter: _DatePickerSelectorPainter(
            circleRadius,
            circleIncreasedRadius,
            strokeWidth,
            _circleIncreaseCoefficient,
            _date,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _increaseAnimationController.dispose();
    super.dispose();
  }

  DateTime _findCloserDateByPosition(double position) {
    if (_datesWithPositions != null) {
      if (position < 0) {
        return _datesWithPositions.first.date;
      } else if (position > lineWidth) {
        return _datesWithPositions.last.date;
      }

      for (DateWithPosition date in _datesWithPositions) {
        final delta = (date.position - position).abs();
        if (delta <= sectorWidth / 2) {
          return date.date;
        }
      }
    }
    return null;
  }

  void _updatePositionByDate(DateTime date) {
    final found = _datesWithPositions.firstWhere(
      (element) => element.date == date,
      orElse: () => null,
    );
    if (found != null) {
      double position = found.position;
      if (position < _minPosition) {
        _selectorPosition = _minPosition;
      } else if (position > _maxPosition) {
        _selectorPosition = _maxPosition;
      } else {
        _selectorPosition = position;
      }
      return;
    }

    if (_datesWithPositions.first.date.isAfter(date)) {
      _selectorPosition = _minPosition;
    } else {
      _selectorPosition = _maxPosition;
    }
  }
}

typedef OnDateSelectedCallback = Function(DateTime date);

class _DatePickerSelectorPainter extends CustomPainter {
  _DatePickerSelectorPainter(
    this.circleRadius,
    this.circleIncreasedRadius,
    this.strokeWidth,
    this.circleIncreaseCoefficient,
    this.date,
  ) : _paint = Paint()
          ..color = Colors.lightBlueAccent
          ..strokeWidth = strokeWidth;

  final double circleRadius;
  final double circleIncreasedRadius;
  final double strokeWidth;
  final DateTime date;

  final Paint _paint;

  final double circleIncreaseCoefficient;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      _paint,
    );

    // half of increase cause it is circle coefficient (diameter), not radius coefficient
    final circleIncrease =
        circleIncreasedRadius * circleIncreaseCoefficient / 2;
    final circleCurrentRadius = circleRadius + circleIncrease;
    final circleCenterY = size.height - circleRadius;

    canvas.drawCircle(
      Offset(centerX, circleCenterY),
      circleCurrentRadius,
      _paint,
    );

    _drawDate(canvas, centerX, circleCenterY, circleCurrentRadius);
  }

  void _drawDate(Canvas canvas, double x, double y, double radius) {
    final dateString = "${DateFormat.Md().format(date)}";

    double fontSize = radius * 2.5 / dateString.length;

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: dateString,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        x - (dateString.length * fontSize / 4) - strokeWidth / 4,
        y - fontSize / 2 - strokeWidth / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _DatePickerSelectorPainter &&
        circleIncreaseCoefficient != oldDelegate.circleIncreaseCoefficient;
  }
}
