import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp2020/categories/CategoriesChart.dart';

import 'categories/CategoriesChart.dart';
import 'datepicker/DatePicker.dart';
import 'model/Category.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double datePickerHeight = 200;
  static const double categoriesChartHeight = 250;

  List<Category> categories = [
    Category(1, "Продукты", 19923.3, Colors.blue),
    Category(2, "Рестораны, кафе", 24142.1, Colors.amber),
    Category(3, "Бытовые расходы", 2123.42, Colors.cyan),
    Category(4, "Подарки", 10000.23, Colors.purple),
    Category(5, "Транспорт", 7642.99, Colors.redAccent),
    Category(6, "Благотворительность", 13242.99, Colors.yellow),
    Category(7, "Животные", 12442.99, Colors.teal),
    Category(8, "Хобби", 24242.99, Colors.deepOrangeAccent),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double datePickerLineHeight = 48.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: datePickerLineHeight),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPersistentHeader(
                  delegate: CategoriesChartDelegate(categories),
                  pinned: true,
                ),
                SliverFixedExtentList(
                  delegate: SliverChildListDelegate(
                    categoriesListOfWidgets(categories),
                  ),
                  itemExtent: 48,
                ),
              ],
            ),
          ),
          DatePicker(
            width: width,
            lineHeight: datePickerLineHeight,
            selectorSize: 40,
            callback: (from, to) {
              setState(() {
                List<Category> newCategories = [];
                categories.forEach((item) {
                  final random = Random();

                  final maxDelta = item.sum / 10;
                  final delta = random.nextInt(maxDelta.toInt());
                  final sign = random.nextBool();

                  final newSum = sign ? item.sum - delta : item.sum + delta;
                  newCategories.add(item.copy(sum: newSum));
                });
                categories = newCategories;
              });
            },
          ),
        ],
      ),
    );
  }

  List<Widget> categoriesListOfWidgets(List<Category> categories) {
    List<Widget> result = [];
    List<Widget> list = categories.map((item) {
      return ListTile(
        title: Text(item.title),
        subtitle: Text(item.sum.toString()),
        leading: CircleAvatar(backgroundColor: item.color),
      );
    }).toList();

    result.addAll(list);
    result.addAll(list);
    result.addAll(list);
    return result;
  }
}
