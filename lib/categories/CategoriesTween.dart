import 'package:flutter/animation.dart';
import 'package:flutterapp2020/model/Category.dart';

class CategoriesTween extends Tween<List<Category>> {
  CategoriesTween(begin, end) : super(begin: begin, end: end);

  @override
  List<Category> lerp(double t) {
    final List<Category> result = [];

    end.forEach((category) {
      final foundBegin = begin.isEmpty
          ? null
          : begin.firstWhere(
              (item) => category.id == item.id,
              orElse: null,
            );

      final beginSum = foundBegin == null ? 0 : foundBegin.sum;

      final sumDelta = (category.sum - beginSum) * t;
      final currentSum = beginSum + sumDelta;

      result.add(category.copy(sum: currentSum));
    });

    return result;
  }
}
