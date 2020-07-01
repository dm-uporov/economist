import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class ChartTile extends StatelessWidget {
  const ChartTile(this.color, this.fromDegree, this.sizeDegrees, this.radius);

  final Color color;
  final double fromDegree;
  final double sizeDegrees;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _ChartTilePainter(fromDegree, sizeDegrees, radius, color),
    );
  }
}

class _ChartTilePainter extends CustomPainter {
  _ChartTilePainter(this.fromDegree, this.sizeDegrees, this.radius, Color color)
      : _paint = Paint()..color = color;

  final double fromDegree;
  final double sizeDegrees;
  final double radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    final fromRadians = radians(fromDegree);
    final sizeRadians = radians(sizeDegrees);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      fromRadians,
      sizeRadians,
      true,
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _ChartTilePainter &&
        (radius != oldDelegate.radius ||
            fromDegree != oldDelegate.fromDegree ||
            sizeDegrees != oldDelegate.sizeDegrees);
  }
}
