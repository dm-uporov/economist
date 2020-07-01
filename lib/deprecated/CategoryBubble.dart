import 'package:flutter/material.dart';

class CategoryBubble extends StatefulWidget {
  const CategoryBubble(
      {double positionX, double positionY, double topOffset, double radius})
      : _positionX = positionX,
        _positionY = positionY,
        _topOffset = topOffset,
        _radius = radius;

  /// bubble x position
  final double _positionX;

  /// bubble y position
  final double _positionY;

  /// top offset
  final double _topOffset;

  /// bubble radius
  final double _radius;

  @override
  _CategoryBubbleState createState() => _CategoryBubbleState(
      positionX: _positionX,
      positionY: _positionY,
      topOffset: _topOffset,
      radius: _radius);
}

class _CategoryBubbleState extends State<CategoryBubble> {
  _CategoryBubbleState(
      {double positionX, double positionY, double topOffset, double radius})
      : _positionX = positionX,
        _positionY = positionY,
        _topOffset = topOffset,
        _radius = radius;

  /// bubble x position
  double _positionX;

  /// bubble y position
  double _positionY;

  /// top offset
  final double _topOffset;

  /// bubble radius
  final double _radius;

  Color color = Colors.amber;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AnimatedPositioned(
      left: _positionX - _radius,
      top: _positionY - _radius - _topOffset,
      duration: Duration(milliseconds: 30),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final dx = details.globalPosition.dx; // + (_width / 2);
            final dy = details.globalPosition.dy; // + (_width / 2);
            _positionX = dx - 16;
            _positionY = dy - _radius - _topOffset;

            if (_positionX - _radius < 0 ||
                _positionX + _radius > width - 32 ||
                _positionY - _radius < _topOffset ||
                _positionY + _radius * 2 + 32 > height - _topOffset) {
              color = Colors.blue;
            } else {
              color = Colors.amber;
            }
          });
        },
        child: CustomPaint(
          size: Size(_radius * 2, _radius * 2),
          painter: _BubblePainter(_radius, color),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.radius, Color color) : _paint = Paint()..color = color;

  final double radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(radius, radius), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _BubblePainter && radius != oldDelegate.radius;
  }
}
