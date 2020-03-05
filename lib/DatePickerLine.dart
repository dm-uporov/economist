import 'package:flutter/material.dart';
import 'package:flutterapp2020/main.dart';

class DatePickerLine extends StatefulWidget {
  const DatePickerLine({mainLineHeight, onPanUpdate})
      : _mainLineHeight = mainLineHeight,
        _onPanUpdate = onPanUpdate;

  final double _mainLineHeight;
  final GestureDragUpdateCallback _onPanUpdate;

  @override
  _DatePickerLineState createState() => _DatePickerLineState(_mainLineHeight);
}

class _DatePickerLineState extends State<DatePickerLine>
    with SingleTickerProviderStateMixin {
  _DatePickerLineState(mainLineHeight) : _mainLineHeight = mainLineHeight;

  final double _mainLineHeight;
  double _lineOffset = 0.0;

  AnimationController _lineStoppingAnimationController;
  Animation _lineStoppingAnimation;

  @override
  void initState() {
    super.initState();
    _lineStoppingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _lineStoppingAnimationController.removeListener(_moveLineByAnimation);
          _lineStoppingAnimationController.reset();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _lineOffset -= details.delta.dx;
          });
        },
        onHorizontalDragEnd: (details) {
          _lineStoppingAnimationController.removeListener(_moveLineByAnimation);
          _lineStoppingAnimationController.forward();
          _lineStoppingAnimation = Tween(
            begin: details.velocity.pixelsPerSecond.dx / 100,
            end: 0.0,
          ).animate(CurvedAnimation(
            parent: _lineStoppingAnimationController,
            curve: Curves.easeOut,
          ))
            ..addListener(_moveLineByAnimation);
        },
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, _mainLineHeight),
              painter: _LineBackgroundPainter(_mainLineHeight),
            ),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, _mainLineHeight),
              painter: _SectorsPainter(
                mainLineHeight: _mainLineHeight,
                offset: _lineOffset,
              ),
            ),
          ],
        ));
  }

  void _moveLineByAnimation() {
    setState(() {
      _lineOffset -= _lineStoppingAnimation.value;
    });
  }

  @override
  void dispose() {
    _lineStoppingAnimationController.dispose();
    super.dispose();
  }
}

class _LineBackgroundPainter extends CustomPainter {
  _LineBackgroundPainter(double mainLineHeight)
      : _mainLineHeight = mainLineHeight,
        _linePaint = Paint()
          ..color = Colors.blue
          ..strokeWidth = mainLineHeight;

  final double _mainLineHeight;
  final Paint _linePaint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, _mainLineHeight / 2),
      Offset(size.width, _mainLineHeight / 2),
      _linePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is _LineBackgroundPainter &&
        _mainLineHeight != oldDelegate._mainLineHeight;
  }
}

class _SectorsPainter extends CustomPainter {
  _SectorsPainter({
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

  final Paint _strokePaint;
  final TextStyle _titleTextStyle;
  final TextStyle _subtitleTextStyle;
  final _textDirection = TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
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
    return oldDelegate is _SectorsPainter && _offset != oldDelegate._offset;
  }
}
