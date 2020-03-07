import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class DatePickerLine extends StatefulWidget {
  const DatePickerLine({
    mainLineHeight,
    DatesPositionsChangedCallback callback,
  })  : _mainLineHeight = mainLineHeight,
        _callback = callback;

  final double _mainLineHeight;
  final DatesPositionsChangedCallback _callback;

  @override
  _DatePickerLineState createState() =>
      _DatePickerLineState(_mainLineHeight, _callback);
}

class _DatePickerLineState extends State<DatePickerLine>
    with SingleTickerProviderStateMixin {
  _DatePickerLineState(
    double mainLineHeight,
    DatesPositionsChangedCallback callback,
  )   : _mainLineHeight = mainLineHeight,
        _callback = callback;

  final DatesPositionsChangedCallback _callback;
  final double _mainLineHeight;

  final double _sectorWidth = 10.0;
  final DateTime _initDate = DateTime.now();
  double _lineOffset = 0.0;
  List<DateWithPosition> _dates;

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
    final double width = MediaQuery.of(context).size.width;
    _dates = _computeDates(width, _sectorWidth, _lineOffset);
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          _moveLine(details.delta.dx);
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
        onHorizontalDragDown: (_) {
          _lineStoppingAnimationController.stop(canceled: false);
        },
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: Size(width, _mainLineHeight),
              painter: _LineBackgroundPainter(_mainLineHeight),
            ),
            CustomPaint(
              size: Size(width, _mainLineHeight),
              painter: _DatesPainter(
                dates: _dates,
                offset: _lineOffset,
                mainLineHeight: _mainLineHeight,
              ),
            ),
          ],
        ));
  }

  List<DateWithPosition> _computeDates(
    double width,
    double sectorWidth,
    double lineOffset,
  ) {
    final dates = List<DateWithPosition>();

    final daysScreenCapacity = (width / sectorWidth).ceil();

    final daysOffset = (lineOffset / sectorWidth) - (daysScreenCapacity - 5);
    final startOffset = lineOffset % sectorWidth;

    var sectorBorderPosition = -startOffset;

    DateTime date = _initDate.add(Duration(days: daysOffset.ceil()));
    while (sectorBorderPosition < width) {
      dates.add(DateWithPosition(date, sectorBorderPosition));
      date = date.add(ONE_DAY);
      sectorBorderPosition += sectorWidth;
    }
    return dates;
  }

  void _moveLine(double delta) {
    final dates = _computeDates(360.0, _sectorWidth, _lineOffset);
    _callback.call(dates);
    setState(() {
      _dates = dates;
      _lineOffset -= delta;
    });
  }

  void _moveLineByAnimation() {
    _moveLine(_lineStoppingAnimation.value);
  }

  @override
  void dispose() {
    _lineStoppingAnimationController.dispose();
    super.dispose();
  }
}

typedef DatesPositionsChangedCallback = Function(List<DateWithPosition> dates);

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

const ONE_DAY = Duration(days: 1);
const MIDDLE_DAY_OF_MONTH = 15;

class _DatesPainter extends CustomPainter {
  _DatesPainter({
    List<DateWithPosition> dates,
    double mainLineHeight,
    double sectorStrokeWidth = 2.0,
    double sectorStrokeHeight = 12.0,
    double bigSectorStrokeHeight = 24.0,
    double batchStrokeHeight = 48.0,
    double titleTextSize = 15.0,
    double subtitleTextSize = 15.0,
    double offset = 0.0,
  })  : _dates = dates,
        _mainLineHeight = mainLineHeight,
        _sectorStrokeWidth = sectorStrokeWidth,
        _sectorStrokeHeight = sectorStrokeHeight,
        _bigSectorStrokeHeight = bigSectorStrokeHeight,
        _monthsDividerStrokeHeight = batchStrokeHeight,
        _offset = offset,
        _subtitleTextSize = subtitleTextSize,
        _titleTextSize = titleTextSize,
        _strokePaint = Paint()
          ..color = Colors.white70
          ..strokeWidth = sectorStrokeWidth,
        _monthsDividerPaint = Paint()
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

  final List<DateWithPosition> _dates;
  final double _mainLineHeight;
  final double _sectorStrokeWidth;
  final double _sectorStrokeHeight;
  final double _bigSectorStrokeHeight;
  final double _monthsDividerStrokeHeight;
  final double _offset;

  final double _titleTextSize;
  final double _subtitleTextSize;

  final double _bigSectorsOffset = 5;

  final Paint _strokePaint;
  final Paint _monthsDividerPaint;
  final TextStyle _titleTextStyle;
  final TextStyle _subtitleTextStyle;
  final TextDirection _textDirection = TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
    for (DateWithPosition dateWithPosition in _dates) {
      final date = dateWithPosition.date;
      final position = dateWithPosition.position;

      if (date.month != date.add(ONE_DAY).month) {
        drawStroke(canvas, position, _monthsDividerStrokeHeight,
            paint: _monthsDividerPaint);
        if (date.day % _bigSectorsOffset == 0) {
          drawSubtitle(canvas, position, "${date.day}");
        }
      } else if (date.day % _bigSectorsOffset == 0) {
        drawStroke(canvas, position, _bigSectorStrokeHeight);
        drawSubtitle(canvas, position, "${date.day}");
      } else {
        drawStroke(canvas, position, _sectorStrokeHeight);
      }

      if (date.day == MIDDLE_DAY_OF_MONTH) {
        drawTitle(canvas, position, "${DateFormat.MMMM().format(date)}");
      }
    }
  }

  void drawStroke(Canvas canvas, double xPosition, double height,
      {Paint paint}) {
    canvas.drawLine(
      Offset(xPosition, _mainLineHeight - height),
      Offset(xPosition, _mainLineHeight),
      paint == null ? _strokePaint : paint,
    );
  }

  void drawTitle(Canvas canvas, double position, String title) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: title, style: _titleTextStyle),
      textDirection: _textDirection,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position -
            (title.length * _titleTextSize / 2 / 2) -
            (_sectorStrokeWidth / 2),
        -20.0,
      ),
    );
  }

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
    return oldDelegate is _DatesPainter && _offset != oldDelegate._offset;
  }
}

class DateWithPosition {
  final DateTime date;
  final double position;

  DateWithPosition(this.date, this.position);
}

typedef DatesRedrawnCallback = void Function(List<DateWithPosition> dates);
