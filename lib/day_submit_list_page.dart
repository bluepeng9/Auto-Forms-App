import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled7/page.dart';
import 'package:logger/logger.dart';
import 'package:untitled7/page_provider.dart';
import 'package:untitled7/pagelistview.dart';

import 'button/page.dart';
import 'data/util.dart';

class DayDetailPage extends StatefulWidget {
  const DayDetailPage(
    this.selectedDay, {
    Key? key,
  }) : super(key: key);
  final int selectedDay;

  @override
  State<StatefulWidget> createState() => _DayDetailPageState();
}

class _DayDetailPageState extends State<DayDetailPage> {
  final dbHelper = PageProvider();
  List<Store> submitList = [];

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('submit list page build');
    return Scaffold(
      body: Column(
        children: [
            DaySubmitList(widget.selectedDay),
        ],
      ),
    );
  }
}