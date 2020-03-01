import 'package:flutter/material.dart';
import 'dart:math';

class PanableBall extends StatefulWidget {
  @override
  _PanableBallState createState() => _PanableBallState();
}

class _PanableBallState extends State<PanableBall> {
  static const _PADDING = 10.0;
  static const _DIAMETER = 48.0;
  static const _RADIUS = _DIAMETER / 2;

  var _positionX = 0.0;
  var _positionY = 0.0;

  static const _DURATION = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_PADDING),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _positionX = details.localPosition.dx - _RADIUS;
            _positionY = details.localPosition.dy - _RADIUS;
          });
        },
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: _DURATION,
              left: _positionX,
              top: _positionY,
              child: ClipOval(
                child: Container(
                  width: _DIAMETER,
                  height: _DIAMETER,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
