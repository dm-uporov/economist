import 'package:flutter/material.dart';

class ChartHole extends StatelessWidget {
  const ChartHole(this.radius, this.color);

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _ChartHolePainter(radius, color),
    );
  }
}

class _ChartHolePainter extends CustomPainter {
  _ChartHolePainter(this.radius, Color color) : _paint = Paint()..color = color;

  final double radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _ChartHolePainter && radius != oldDelegate.radius;
  }
}
