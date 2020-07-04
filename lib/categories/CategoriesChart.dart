import 'package:flutter/material.dart';
import 'package:flutterapp2020/model/Category.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' hide Colors;

class CategoriesChartDelegate extends SliverPersistentHeaderDelegate {
  final List<Category> categories;

  CategoriesChartDelegate(this.categories);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: CustomPaint(
        size: Size(250, 250),
        painter: CategoriesChartPainter(categories),
      ),
    );
  }

  @override
  double get maxExtent => 270;

  @override
  double get minExtent => 170;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is CategoriesChartDelegate &&
        categories != oldDelegate.categories;
  }
}

class CategoriesChartPainter extends CustomPainter {
  static const innerRadiusPercents = 66.6;

  final List<Category> categories;

  CategoriesChartPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final radius = height / 2;

    final tiles = toTiles(categories, radius);
    drawTiles(canvas, size, tiles);

    final dividers = getDividers(tiles);
    drawDividers(canvas, size, dividers);

    final innerRadius = radius / 100 * innerRadiusPercents;
    drawHole(canvas, size, innerRadius);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is CategoriesChartPainter &&
        categories != oldDelegate.categories;
  }

  void drawTiles(Canvas canvas, Size size, List<CategoryTile> tiles) {
    tiles.forEach((tile) => drawTile(canvas, size, tile));
  }

  void drawTile(Canvas canvas, Size size, CategoryTile tile) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    final fromRadians = radians(tile.fromDegree);
    final sizeRadians = radians(tile.sizeDegrees);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: tile.radius),
      fromRadians,
      sizeRadians,
      true,
      Paint()..color = tile.color,
    );
  }

  void drawDividers(Canvas canvas, Size size, List<TileDivider> dividers) {
    dividers.forEach((divider) => drawDivider(canvas, size, divider));
  }

  void drawDivider(Canvas canvas, Size size, TileDivider divider) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    final atRadians = radians(divider.atDegree);

    final delta = Offset(
        cos(atRadians) * divider.radius, sin(atRadians) * divider.radius);
    canvas.drawLine(
      center,
      center + delta,
      Paint()
        ..color = divider.color
        ..strokeWidth = 3.0,
    );
  }

  void drawHole(Canvas canvas, Size size, double radius) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
  }

  List<CategoryTile> toTiles(List<Category> categories, double radius) {
    double sum = 0;
    categories.forEach((item) => sum += item.sum);

    double nextTileStartAngle = 0;

    final categoriesTiles = categories.map((item) {
      final tileDegrees = item.sum / sum * 360;
      final tile = CategoryTile(
        color: item.color,
        fromDegree: nextTileStartAngle,
        sizeDegrees: tileDegrees,
        radius: radius,
      );
      nextTileStartAngle += tileDegrees;
      return tile;
    }).toList();
    return categoriesTiles;
  }

  List<TileDivider> getDividers(List<CategoryTile> tiles) {
    List<TileDivider> dividers = [];
    if (tiles.length > 1) {
      tiles.forEach((tile) {
        dividers.add(TileDivider(
          color: Colors.white,
          atDegree: tile.fromDegree,
          radius: tile.radius,
        ));
        dividers.add(TileDivider(
          color: Colors.white,
          atDegree: tile.fromDegree + tile.sizeDegrees,
          radius: tile.radius,
        ));
      });
    }
    return dividers;
  }
}

class CategoryTile {
  const CategoryTile({
    @required this.color,
    @required this.fromDegree,
    @required this.sizeDegrees,
    @required this.radius,
  });

  final Color color;
  final double fromDegree;
  final double sizeDegrees;
  final double radius;
}

class TileDivider {
  const TileDivider({
    @required this.color,
    @required this.atDegree,
    @required this.radius,
  });

  final Color color;
  final double atDegree;
  final double radius;
}
