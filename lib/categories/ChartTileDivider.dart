import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class ChartTileDivider extends StatelessWidget {
  const ChartTileDivider(this.color, this.atDegree, this.radius);

  final Color color;
  final double atDegree;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _ChartTileDividerPainter(atDegree, radius, color),
    );
  }
}

class _ChartTileDividerPainter extends CustomPainter {
  _ChartTileDividerPainter(this.atDegree, this.radius, Color color)
      : _paint = Paint()
          ..color = color
          ..strokeWidth = 3.0;

  final double atDegree;
  final double radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    final atRadians = radians(atDegree);

    final delta = Offset(cos(atRadians) * radius, sin(atRadians) * radius);
    canvas.drawLine(center, center + delta, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _ChartTileDividerPainter &&
        (radius != oldDelegate.radius || atDegree != oldDelegate.atDegree);
  }
}
