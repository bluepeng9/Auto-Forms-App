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
    logger.e('cal');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  // Provider.of<SubmitListProvider>(context).gettUtils.getFormatTime(day)
                },
              ),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),

              onDaySelected: (selectedDay, focusedDay) {
                date = Utils.getFormatTime(selectedDay);
                var provider =
                    Provider.of<SubmitListProvider>(context, listen: false);
                provider.selectedDay = date;
                provider.getSubmitList();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) =>
                        DayDetailPage(Utils.getFormatTime(selectedDay)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
