import 'package:flutter/material.dart';
import 'package:flutterapp2020/categories/ChartHole.dart';
import 'package:flutterapp2020/categories/ChartTileDivider.dart';
import 'package:flutterapp2020/model/Category.dart';
import 'ChartTile.dart';

class CategoriesChartWidget extends StatefulWidget {
  final double chartHeight;
  final List<Category> categories;

  const CategoriesChartWidget(this.chartHeight, this.categories, {Key key})
      : super(key: key);

  @override
  _CategoriesChartWidgetState createState() =>
      _CategoriesChartWidgetState(chartHeight, categories);
}

class _CategoriesChartWidgetState extends State<CategoriesChartWidget> {
  static const degreesSum = 360;
  static const holeRadiusPercents = 70.0;

  final double chartHeight;
  final double tileRadius;
  double holeRadius;
  List<Category> categories;

  _CategoriesChartWidgetState(this.chartHeight, this.categories)
      : tileRadius = chartHeight / 2 {
    holeRadius = tileRadius / 100 * holeRadiusPercents;
  }

  @override
  void didUpdateWidget(CategoriesChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (categories != oldWidget.categories) {
      setState(() => categories = oldWidget.categories);
    }
  }

  @override
  Widget build(BuildContext context) {
    double sum = 0;
    categories.forEach((item) => sum += item.sum);

    double nextTileStartAngle = 0;

    final categoriesTiles = categories.map((item) {
      final tileDegrees = item.sum / sum * degreesSum;
      final tile = ChartTile(
          item.color, nextTileStartAngle, tileDegrees, tileRadius);
      nextTileStartAngle += tileDegrees;
      return tile;
    });

    List<ChartTileDivider> dividers = [];
    if (categoriesTiles.length > 1) {
      categoriesTiles.forEach((tile) {
        dividers.add(ChartTileDivider(
          Colors.white,
          tile.fromDegree,
          tile.radius,
        ));
      });
    }

    List<Widget> widgets = [];
    widgets.addAll(categoriesTiles);
    widgets.addAll(dividers);
    widgets.add(ChartHole(holeRadius, Colors.white));

    return Stack(children: widgets);
  }
}
