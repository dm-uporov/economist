import 'package:flutter/material.dart';

class AnimatedSelector extends StatefulWidget {
  @override
  _AnimatedSelectorState createState() => _AnimatedSelectorState();
}

class _AnimatedSelectorState extends State<AnimatedSelector>
    with SingleTickerProviderStateMixin {
  Animation<double> _increaseAnimation;
  AnimationController _increaseAnimationController;

  double _circleIncreaseCoefficient = 0.0;

  @override
  void initState() {
    super.initState();
    _increaseAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        reverseDuration: const Duration(milliseconds: 300),
        vsync: this)
      ..forward();
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
      child: CustomPaint(
        painter: _Selector(_circleIncreaseCoefficient),
        child: Container(
          width: 30.0,
          height: 100.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _increaseAnimationController.dispose();
//    _decreaseAnimationController.dispose();
    super.dispose();
  }
}

class _Selector extends CustomPainter {
  _Selector(this.circleIncreaseCoefficient);

  static const _CIRCLE_DEFAULT_RADIUS_PERCENT = 0.15;
  static const _CIRCLE_RADIUS_MAX_INCREASE_PERCENT = 3.0;

  // from 0.0 to 1.0
  final double circleIncreaseCoefficient;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6.0;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), paint);

    final circleDefaultRadius = size.height * _CIRCLE_DEFAULT_RADIUS_PERCENT;
    // `/ 2` cause of radius (not diameter)
    final circleMaxIncrease =
        circleDefaultRadius * _CIRCLE_RADIUS_MAX_INCREASE_PERCENT / 2;
    final circleIncrease = circleMaxIncrease * circleIncreaseCoefficient;
    final circleRadius = circleDefaultRadius + circleIncrease;
    final circleCenterY = size.height - circleRadius;

    canvas.drawCircle(Offset(centerX, circleCenterY), circleRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _Selector &&
        circleIncreaseCoefficient != oldDelegate.circleIncreaseCoefficient;
  }
}
