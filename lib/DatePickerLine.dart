import 'package:flutter/material.dart';

class DatePickerLine extends StatefulWidget {
  const DatePickerLine({height, onTap, onPanUpdate})
      : _height = height,
        _onTap = onTap,
        _onPanUpdate = onPanUpdate;

  final double _height;
  final GestureTapDownCallback _onTap;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  _DatePickerLineState createState() =>
      _DatePickerLineState(_height, _onTap, _onPanUpdate);
}

class _DatePickerLineState extends State<DatePickerLine>
    with SingleTickerProviderStateMixin {
  _DatePickerLineState(height, onTap, onPanUpdate)
      : _height = height,
        _onTap = onTap,
        _onPanUpdate = onPanUpdate;

  final double _height;
  final GestureTapDownCallback _onTap;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTap,
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        size: Size(1000, _height),
        painter: _LinePainter(_height),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(height) : _height = height;

  final double _height;
  final double _sectorWidth = 10.0;
  final double _sectorStrokeWidth = 2.0;
  final double _sectorStrokeHeight = 7.0;
  final double _batchStrokeHeight = 15.0;
  final double _bigBatchStrokeHeight = 30.0;

  final double _sectorsBatchSize = 5;
  final double _sectorsBigBatchSize = 31;

  final double _batchTitleSize = 15.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = _height;
    final centerOfLine = _height / 2;
    canvas.drawLine(
      Offset(0, centerOfLine),
      Offset(size.width, centerOfLine),
      paint,
    );

    final sectorBorderPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = _sectorStrokeWidth;

    var sectorBorderPosition = _sectorWidth;
    var counter = 0;
    while (sectorBorderPosition < size.width) {
      counter++;
      double yPosition;
      if (counter % _sectorsBigBatchSize == 0) {
        yPosition = _height - _bigBatchStrokeHeight;
        counter = 0;
      } else if (counter % _sectorsBatchSize == 0) {
        yPosition = _height - _batchStrokeHeight;

        final textPainter = TextPainter(
          text: TextSpan(
            text: "$counter",
            style: TextStyle(color: Colors.black, fontSize: _batchTitleSize),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(
              sectorBorderPosition -
                  (_batchTitleSize / 2) -
                  (_sectorStrokeWidth / 2),
              _height,
            ));
      } else {
        yPosition = _height - _sectorStrokeHeight;
      }
      canvas.drawLine(
        Offset(sectorBorderPosition, yPosition),
        Offset(sectorBorderPosition, _height),
        sectorBorderPaint,
      );
      sectorBorderPosition += _sectorWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _LinePainter && false;
  }
}
