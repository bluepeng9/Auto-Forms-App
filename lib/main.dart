import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled7/browser/browser.dart';
import 'package:untitled7/data/util.dart';
import 'package:untitled7/day_submit_list_page.dart';
import 'package:logger/logger.dart';
import 'package:untitled7/page_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => SubmitListProvider()),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubmitListProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: '신발'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _sharedText;

  int date = 20220301;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    logger.i('START');

    StreamSubscription _intentDataStreamSubscription;
    // For sharing or opening urls/text coming from outside
    // the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      logger.i('inside');
      setState(() {
        _sharedText = value;
      });
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => Browser(
            sharedUrl: _sharedText,
          ),
        ),
      );
    }, onError: (err) {
      logger.e("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside
    // the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      logger.i('outside $value');
      setState(() {
        _sharedText = value.toString();
      });
      if (value == null) {
        return;
      }
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => Browser(
            sharedUrl: _sharedText,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i('main build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTableCalendar(context),
          ],
        ),
      ),
    );
  }

  TableCalendar<Object?> _buildTableCalendar(BuildContext context) {
    logger.e('cal build');
    // context.read<SubmitListProvider>().getLength(day);
    // var provider = Provider.of<SubmitListProvider>(
    //   context,listen: false,
    // );
    var tableCalendar = TableCalendar(
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          logger.i('aa');
          var date = Utils.getFormatTime(day);

          // return _buildMarker(date);
          return aa(date);
        },
        headerTitleBuilder: (context, day) {},
      ),
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      onDaySelected: (selectedDay, focusedDay) async {
        date = Utils.getFormatTime(selectedDay);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => DayDetailPage(Utils.getFormatTime(selectedDay)),
          ),
        );
      },
    );

    return tableCalendar;
  }

  Positioned _buildMarker(date) {
    context.read<SubmitListProvider>().getLength(date);
    return Positioned(
      bottom: 0,
      child: Container(
        width: 40,
        height: 13,
        decoration: const BoxDecoration(
          color: Colors.black12,
        ),
        child: Text(
          context.watch<SubmitListProvider>().length2[date].toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}

class aa extends StatelessWidget{

  int date;
  aa(this.date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SubmitListProvider>().getLength(date);
    return Positioned(
      bottom: 0,
      child: Container(
        width: 40,
        height: 13,
        decoration: const BoxDecoration(
          color: Colors.black12,
        ),
        child: Text(
          context.watch<SubmitListProvider>().length2[date].toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }


}
