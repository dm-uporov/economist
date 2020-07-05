import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterapp2020/model/Category.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'CategoriesTween.dart';

const double padding = 20;
const double maxChartDiameter = 250;
const double minChartDiameter = 150;

class CategoriesChartDelegate extends SliverPersistentHeaderDelegate {
  final List<Category> categories;

  CategoriesChartDelegate(this.categories);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedCategoriesChart(categories);
//    return Padding(
//      padding: EdgeInsets.only(top: padding, bottom: padding),
//      child: CustomPaint(
//        size: Size(maxChartDiameter, maxChartDiameter),
//        painter: CategoriesChartPainter(categories),
//      ),
//    );
  }

  @override
  double get maxExtent => maxChartDiameter + 2 * padding;

  @override
  double get minExtent => minChartDiameter + 2 * padding;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is CategoriesChartDelegate &&
        categories != oldDelegate.categories;
  }
}

class AnimatedCategoriesChart extends StatefulWidget {
  final List<Category> categories;

  AnimatedCategoriesChart(this.categories);

  @override
  _AnimatedCategoriesChartState createState() =>
      _AnimatedCategoriesChartState(categories);
}

class _AnimatedCategoriesChartState extends State<AnimatedCategoriesChart> {
  List<Category> oldCategories;

  _AnimatedCategoriesChartState(List<Category> categories) {
    oldCategories = categories;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: CategoriesTween(oldCategories, widget.categories),
      duration: Duration(milliseconds: 200),
      builder: (BuildContext context, List<Category> categories, Widget child) {
        return Padding(
          padding: EdgeInsets.only(top: padding, bottom: padding),
          child: CustomPaint(
            size: Size(maxChartDiameter, maxChartDiameter),
            painter: CategoriesChartPainter(categories),
          ),
        );
      },
//        child: Icon(Icons.aspect_ratio),
    );
  }

  @override
  void didUpdateWidget(AnimatedCategoriesChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories != oldWidget.categories) {
      setState(() {
        oldCategories = oldWidget.categories;
      });
    }
  }
}

class CategoriesChartPainter extends CustomPainter {
  static const holeRadiusPercents = 66.6;
  static const dividerGapDegrees = 5;
  static const maxElevation = 5;

  final List<Category> categories;

  CategoriesChartPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final heightDelta = maxChartDiameter - height;
    final relativeDelta = heightDelta / (maxChartDiameter - minChartDiameter);
    final shadowHeight = maxElevation * relativeDelta;
    final tilesShadowHeight = maxElevation - shadowHeight;

    drawBottomShadow(canvas, size, shadowHeight);

    final centerX = width / 2;
    final centerY = height / 2 - shadowHeight;
    final radius = min(centerX, centerY);
    final center = Offset(centerX, centerY);

    final tiles = toTiles(categories, radius);
    drawTiles(canvas, center, tiles, tilesShadowHeight);
  }

  void drawBottomShadow(Canvas canvas, Size size, double shadowHeight) {
    final path = Path()
      ..addRect(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)));
    canvas.drawShadow(path, Colors.black, shadowHeight, false);
    canvas.drawPath(
        path, Paint()..color = ThemeData.light().scaffoldBackgroundColor);
  }

  void drawTiles(Canvas canvas, Offset center, List<CategoryTile> tiles,
      double elevation) {
    final tilesWithPaths = tiles.map((tile) => withPath(tile, center: center));
    tilesWithPaths.forEach((item) {
      canvas.drawShadow(item.path, Colors.black, elevation, false);
    });
    tilesWithPaths.forEach((item) {
      canvas.drawPath(item.path, Paint()..color = item.tile.color);
    });
  }

  TileWithPath withPath(CategoryTile tile, {@required Offset center}) {
    /// `+ 90` to split the ring exactly at the bottom center
    final fromRadians = radians(tile.fromDegree + 90);
    final sizeRadians = radians(tile.sizeDegrees);

    final outerPolygon = arcPolygon(
      center: center,
      fromRadians: fromRadians,
      sizeRadians: sizeRadians,
      radius: tile.radius,
    );

    final innerPolygon = arcPolygon(
      center: center,
      fromRadians: fromRadians,
      sizeRadians: sizeRadians,
      radius: tile.innerRadius,
    ).reversed.toList();

    return TileWithPath(
      tile: tile,
      path: Path()..addPolygon(outerPolygon + innerPolygon, true),
    );
  }

  List<Offset> arcPolygon(
      {Offset center, double fromRadians, double sizeRadians, double radius}) {
    final pointsCount = (sizeRadians * 100).toInt();
    final pointDeltaRadians = sizeRadians / pointsCount;
    final pointsRadians =
        List.generate(pointsCount, (i) => i * pointDeltaRadians + fromRadians);

    return pointsRadians.map((radian) {
      return Offset(
          cos(radian) * radius + center.dx, sin(radian) * radius + center.dy);
    }).toList();
  }

  List<CategoryTile> toTiles(List<Category> categories, double radius) {
    double sum = 0;
    categories.forEach((item) => sum += item.sum);

    final length = categories.length;
    final dividersDegreesSum = length > 1 ? length * dividerGapDegrees : 0;
    final tilesDegreesSum = 360 - dividersDegreesSum;

    double nextTileStartAngle = 0;

    final categoriesTiles = categories.map((item) {
      final tileDegrees = item.sum / sum * tilesDegreesSum;
      final tile = CategoryTile(
          color: item.color,
          fromDegree: nextTileStartAngle,
          sizeDegrees: tileDegrees,
          radius: radius,
          innerRadius: radius / 100 * holeRadiusPercents);
      nextTileStartAngle += tileDegrees + dividerGapDegrees;
      return tile;
    }).toList();
    return categoriesTiles;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is CategoriesChartPainter &&
        categories != oldDelegate.categories;
  }
}

class CategoryTile {
  const CategoryTile({
    @required this.color,
    @required this.fromDegree,
    @required this.sizeDegrees,
    @required this.radius,
    @required this.innerRadius,
  });

  final Color color;
  final double fromDegree;
  final double sizeDegrees;
  final double radius;
  final double innerRadius;
}

class TileWithPath {
  TileWithPath({
    @required this.tile,
    @required this.path,
  });

  final CategoryTile tile;
  final Path path;
}
