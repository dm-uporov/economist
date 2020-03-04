import 'package:flutter/material.dart';

class DatePickerLine extends StatefulWidget {
  const DatePickerLine({mainLineHeight, onTap, onPanUpdate})
      : _mainLineHeight = mainLineHeight,
        _onTap = onTap,
        _onPanUpdate = onPanUpdate;

  final double _mainLineHeight;
  final GestureTapDownCallback _onTap;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  _DatePickerLineState createState() =>
      _DatePickerLineState(_mainLineHeight, _onTap, _onPanUpdate);
}

class _DatePickerLineState extends State<DatePickerLine>
    with SingleTickerProviderStateMixin {
  _DatePickerLineState(mainLineHeight, onTap, onPanUpdate)
      : _mainLineHeight = mainLineHeight,
        _onTap = onTap,
        _onPanUpdate = onPanUpdate;

  final double _mainLineHeight;
  final GestureTapDownCallback _onTap;
  final GestureDragUpdateCallback _onPanUpdate;
  double _lineOffset = 0.0;
  double _panStartPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTap,
      onPanStart: (details) {
        _panStartPosition = details.globalPosition.dx;
      },
      onPanUpdate: (details) {
        setState(() {
          _lineOffset -= details.delta.dx;
        });
      },
      onPanCancel: () => _panStartPosition = 0.0,
      onPanEnd: (details) => _panStartPosition = 0.0,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, _mainLineHeight),
        painter: _LinePainter(
          mainLineHeight: _mainLineHeight,
          offset: _lineOffset,
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    double mainLineHeight,
    double sectorWidth = 10.0,
    double sectorStrokeWidth = 2.0,
    double sectorStrokeHeight = 12.0,
    double bigSectorStrokeHeight = 24.0,
    double batchStrokeHeight = 48.0,
    double titleTextSize = 15.0,
    double subtitleTextSize = 15.0,
    double offset = 0.0,
  })  : _mainLineHeight = mainLineHeight,
        _sectorWidth = sectorWidth,
        _sectorStrokeWidth = sectorStrokeWidth,
        _sectorStrokeHeight = sectorStrokeHeight,
        _bigSectorStrokeHeight = bigSectorStrokeHeight,
        _batchStrokeHeight = batchStrokeHeight,
        _offset = offset,
        _subtitleTextSize = subtitleTextSize,
        _titleTextSize = titleTextSize,
        _linePaint = Paint()
          ..color = Colors.blue
          ..strokeWidth = mainLineHeight,
        _strokePaint = Paint()
          ..color = Colors.white70
          ..strokeWidth = sectorStrokeWidth,
        _titleTextStyle = TextStyle(
          color: Colors.black87,
          fontSize: titleTextSize,
        ),
        _subtitleTextStyle = TextStyle(
          color: Colors.black54,
          fontSize: subtitleTextSize,
        );

  final double _mainLineHeight;
  final double _sectorWidth;
  final double _sectorStrokeWidth;
  final double _sectorStrokeHeight;
  final double _bigSectorStrokeHeight;
  final double _batchStrokeHeight;
  final double _offset;

  final double _titleTextSize;
  final double _subtitleTextSize;

  final double _bigSectorsOffset = 5;
  final double _batchSize = 31;

  final Paint _linePaint;
  final Paint _strokePaint;
  final TextStyle _titleTextStyle;
  final TextStyle _subtitleTextStyle;
  final _textDirection = TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
    drawMainLine(canvas, size);

    final hiddenSectorsSize = (_offset / _sectorWidth).ceil();
    final startOffset = _offset % _sectorWidth;

    var sectorBorderPosition = -startOffset;
    var counter = (hiddenSectorsSize % _batchSize).ceil();
    while (sectorBorderPosition < size.width) {
      counter++;
      double strokeHeight;
      if (counter % _batchSize == 0) {
        strokeHeight = _batchStrokeHeight;
        if (counter % _bigSectorsOffset == 0) {
          drawSubtitle(canvas, sectorBorderPosition, "$counter");
        }
        counter = 0;
      } else if (counter % _bigSectorsOffset == 0) {
        strokeHeight = _bigSectorStrokeHeight;
        drawSubtitle(canvas, sectorBorderPosition, "$counter");
      } else {
        strokeHeight = _sectorStrokeHeight;
      }

      drawStroke(canvas, sectorBorderPosition, strokeHeight);
      sectorBorderPosition += _sectorWidth;
    }
  }

  void drawMainLine(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, _mainLineHeight / 2),
      Offset(size.width, _mainLineHeight / 2),
      _linePaint,
    );
  }

  void drawStroke(Canvas canvas, double xPosition, double height) {
    canvas.drawLine(
      Offset(xPosition, _mainLineHeight - height),
      Offset(xPosition, _mainLineHeight),
      _strokePaint,
    );
  }

  void drawTitle(Canvas canvas, double position, String title) {}

  void drawSubtitle(Canvas canvas, double position, String subtitle) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: subtitle, style: _subtitleTextStyle),
      textDirection: _textDirection,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position -
            (subtitle.length * _subtitleTextSize / 2 / 2) -
            (_sectorStrokeWidth / 2),
        _mainLineHeight,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _LinePainter && false;
  }
}
