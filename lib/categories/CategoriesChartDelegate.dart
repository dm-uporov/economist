import 'package:flutter/material.dart';
import 'package:flutterapp2020/categories/CategoriesChartWidget.dart';
import 'package:flutterapp2020/model/Category.dart';

class CategoriesChartDelegate extends SliverPersistentHeaderDelegate {
  final List<Category> categories;

  static const double topPadding = 20;

  CategoriesChartDelegate(this.categories);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final supposedExtent = maxExtent - shrinkOffset;
    final height = supposedExtent > minExtent ? supposedExtent : minExtent;
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: Colors.white,
      child: CategoriesChartWidget(height - topPadding, categories),
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
