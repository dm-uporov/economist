import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterapp2020/model/Category.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' hide Colors;

class CategoriesChartDelegate extends SliverPersistentHeaderDelegate {
  static const double padding = 20;
  static const double maxChartDiameter = 250;
  static const double minChartDiameter = 150;

  final List<Category> categories;

  CategoriesChartDelegate(this.categories);

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ClipPath(
        clipper: HoleClipper(),
        child: CustomPaint(
          size: Size(maxChartDiameter, maxChartDiameter),
          painter: CategoriesChartPainter(categories),
        ),
      ),
    );
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

class CategoriesChartPainter extends CustomPainter {
  final List<Category> categories;

  CategoriesChartPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final radius = height / 2;
    final path = Path();

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    path.addOval(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius));
    canvas.drawShadow(path, Colors.black38, 10, true);

    final tiles = toTiles(categories, radius);
    drawTiles(canvas, size, tiles);

    final dividers = getDividers(tiles);
    drawDividers(canvas, size, dividers);
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
      Paint()
        ..color = tile.color,
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

class HoleClipper extends CustomClipper<Path> {
  static const holeRadiusPercents = 66.6;

  @override
  getClip(Size size) {
    final outerRadius = size.height / 2;
    final radius = outerRadius / 100 * holeRadiusPercents;
    final center = Offset(size.width / 2, size.height / 2);

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
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
