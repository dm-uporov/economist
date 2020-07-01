import 'package:flutter/material.dart';
import 'package:flutterapp2020/categories/CategoriesChartWidget.dart';

import 'datepicker/DatePicker.dart';
import 'model/Category.dart';

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

  final List<Category> categories = [
    Category(1, "Продукты", 19923.3, Colors.blue),
    Category(2, "Рестораны, кафе", 24142.1, Colors.amber),
    Category(3, "Бытовые расходы", 2123.42, Colors.red),
    Category(4, "Подарки", 10000.23, Colors.brown),
    Category(5, "Транспорт", 7642.99, Colors.green),
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
          Container(
            padding: EdgeInsets.only(top: datePickerHeight),
            height: categoriesChartHeight,
            child: CategoriesChartWidget(categoriesChartHeight, categories),
          ),
          DatePicker(width, datePickerLineHeight),
        ],
      ),
    );
  }
}
