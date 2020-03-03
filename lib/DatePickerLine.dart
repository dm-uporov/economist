import 'package:flutter/material.dart';

class DatePickerLine extends StatefulWidget {
  const DatePickerLine({height, onPanUpdate})
      : _height = height,
        _onPanUpdate = onPanUpdate;

  final double _height;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  _DatePickerLineState createState() =>
      _DatePickerLineState(_height, _onPanUpdate);
}

class _DatePickerLineState extends State<DatePickerLine>
    with SingleTickerProviderStateMixin {
  _DatePickerLineState(height, onPanUpdate)
      : _height = height,
        _onPanUpdate = onPanUpdate;

  final double _height;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  Widget build(BuildContext context) {
    return
//      GestureDetector(
//      onPanUpdate: _onPanUpdate,
//      child:
        CustomPaint(
      size: Size(1000, _height),
      painter: _LinePainter(_height),
//      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(height) : _height = height;

  final double _height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = _height;
    canvas.drawLine(Offset(0, _height / 2), Offset(size.width, _height / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _LinePainter && false;
  }
}
