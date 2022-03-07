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
    context.read<SubmitListProvider>().getSubmitList3(widget.selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    logger.i('list build');

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(widget.selectedDay.toString());
          } else if (index == 1) {
            // var provider = Provider.of<SubmitListProvider>(context,);
            // provider.selectedDay = widget.selectedDay;
            return buildColumn();
          }
          return Container();
        },
      ),
    );
  }

  Column buildColumn() {

    return Column(
      children: List.generate(
        context.watch<SubmitListProvider>().submitList3.length,
        (index) {
          return PageContainer(context.watch<SubmitListProvider>().submitList3[index]);
        },
      ),
    );
  }
}
