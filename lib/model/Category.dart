import 'dart:ui';

class Category {
  final int id;
  final String title;
  final double sum;
  final Color color;

  Category(this.id, this.title, this.sum, this.color);

  @override
  bool operator ==(other) {
    return other is Category &&
        id == other.id &&
        title == other.title &&
        sum == other.sum &&
        color == other.color;
  }

  @override
  int get hashCode {
    return id + title.hashCode + sum.toInt() + color.value;
  }

  Category copy({int id, String title, double sum, Color color}) {
    return Category(
      id ?? this.id,
      title ?? this.title,
      sum ?? this.sum,
      color ?? this.color
    );
  }
}
