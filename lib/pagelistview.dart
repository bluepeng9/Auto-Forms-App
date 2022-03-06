import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:untitled7/page.dart';
import 'package:untitled7/page_provider.dart';

import 'button/page.dart';
import 'day_submit_list_page.dart';

class DaySubmitList extends StatefulWidget {
  final int selectedDay;

  const DaySubmitList(this.selectedDay, {Key? key}) : super(key: key);

  @override
  _DaySubmitListState createState() => _DaySubmitListState();
}

class _DaySubmitListState extends State<DaySubmitList> {
  final dbHelper = PageProvider();

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Text(widget.selectedDay.toString());
          } else if (index == 1) {
            var provider = Provider.of<SubmitListProvider>(context,);
            provider.selectedDay = widget.selectedDay;

            return Column(
              children: List.generate(
                provider.submitList.length,
                (index) {
                  return PageContainer(provider.submitList[index]);
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
