import 'package:flutter/material.dart';

class DatePickerSelector extends StatefulWidget {
  const DatePickerSelector({
    double width,
    double height,
    double circleIncreaseCoefficient = 2.0,
    double strokeWidth = 4.0,
    GestureDragUpdateCallback onPanUpdate,
  })  : _width = width,
        _height = height,
        _circleRadius = width / 2,
        _circleIncreasedRadius = width / 2 * circleIncreaseCoefficient,
        _strokeWidth = strokeWidth,
        _onPanUpdate = onPanUpdate;

  final double _width;
  final double _height;
  final double _circleRadius;
  final double _circleIncreasedRadius;
  final double _strokeWidth;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  _DatePickerSelectorState createState() => _DatePickerSelectorState(
        _width,
        _height,
        _circleRadius,
        _circleIncreasedRadius,
        _strokeWidth,
        _onPanUpdate,
      );
}

class _DatePickerSelectorState extends State<DatePickerSelector>
    with SingleTickerProviderStateMixin {
  _DatePickerSelectorState(
    double width,
    double height,
    double circleRadius,
    double circleIncreasedRadius,
    double strokeWidth,
    GestureDragUpdateCallback onPanUpdate,
  )   : _width = width,
        _height = height,
        _circleRadius = circleRadius,
        _circleIncreasedRadius = circleIncreasedRadius,
        _strokeWidth = strokeWidth,
        _onPanUpdate = onPanUpdate;

  final double _width;
  final double _height;
  final double _circleRadius;
  final double _circleIncreasedRadius;
  final double _strokeWidth;
  final GestureDragUpdateCallback _onPanUpdate;

  Animation<double> _increaseAnimation;
  AnimationController _increaseAnimationController;

  double _circleIncreaseCoefficient = 0.0;

  @override
  void initState() {
    super.initState();
    _increaseAnimationController = AnimationController(
        duration: const Duration(milliseconds: 700),
        reverseDuration: const Duration(milliseconds: 200),
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        size: Size(_width, _height),
        painter: _DatePickerSelectorPainter(
          _circleRadius,
          _circleIncreasedRadius,
          _strokeWidth,
          _circleIncreaseCoefficient,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _increaseAnimationController.dispose();
    super.dispose();
  }
}

class _DatePickerSelectorPainter extends CustomPainter {
  _DatePickerSelectorPainter(
    this.circleRadius,
    this.circleIncreasedRadius,
    this.strokeWidth,
    this.circleIncreaseCoefficient,
  );

  final double circleRadius;
  final double circleIncreasedRadius;
  final double strokeWidth;

  // from 0.0 to 1.0
  final double circleIncreaseCoefficient;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = strokeWidth;
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      paint,
    );

    // half of increase cause it is circle coefficient (diameter), not radius coefficient
    final circleIncrease =
        circleIncreasedRadius * circleIncreaseCoefficient / 2;
    final circleCurrentRadius = circleRadius + circleIncrease;
    final circleCenterY = size.height - circleRadius;

    canvas.drawCircle(
      Offset(centerX, circleCenterY),
      circleCurrentRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _DatePickerSelectorPainter &&
        circleIncreaseCoefficient != oldDelegate.circleIncreaseCoefficient;
  }
}
