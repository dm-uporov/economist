import 'package:flutter/material.dart';
import 'dart:math';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  var _defaultWidth = 48.0;
  var _defaultHeight = 48.0;

  var _deltaX = 0.0;
  var _deltaY = 0.0;

  var _startXPosition = 0.0;
  var _startYPosition = 0.0;

  var _alignment = Alignment.bottomRight;

  static const _DURATION = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _DURATION,
      alignment: _alignment,
      child: Padding(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GestureDetector(
          onPanStart: (details) {
            _startXPosition = details.localPosition.dx;
            _startYPosition = details.localPosition.dy;
          },
          onPanUpdate: (details) {
            setState(() {
              var dx = details.localPosition.dx - _startXPosition;
              var dy = details.localPosition.dy - _startYPosition;
              _deltaX = dx.abs();
              _deltaY = dy.abs();
            });
          },
          onPanEnd: (details) {
            setState(() {
              _clearCoefficients();
            });
          },
          onPanCancel: () {
            setState(() {
              _clearCoefficients();
            });
          },
          child: AnimatedContainer(
            curve: Curves.decelerate,
            duration: _DURATION,
            width: _defaultWidth + _deltaX,
            height: _defaultHeight + _deltaY,
            color: Colors.black,
          ),
        ),
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  void _clearCoefficients() {
    _deltaX = 0.0;
    _deltaY = 0.0;
  }
}

class SpinningContainer extends AnimatedWidget {
  const SpinningContainer({Key key, AnimationController controller})
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _progress.value * 2.0 * pi,
      child: Container(width: 200.0, height: 200.0, color: Colors.green),
    );
  }
}