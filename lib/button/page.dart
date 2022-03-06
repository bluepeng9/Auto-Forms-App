import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../page.dart';
import '../page_provider.dart';

class PageContainer extends StatefulWidget {
  final Store store;

  const PageContainer(this.store, {Key? key}) : super(key: key);



  @override
  State<StatefulWidget> createState() =>_PageContainerState();
}

class _PageContainerState extends State<PageContainer>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.black),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Text(
            widget.store.title.toString(),
          ),
          CupertinoButton(
            child: const Text('삭제'),
            onPressed: () {
              Provider.of<SubmitListProvider>(context,listen: false).delete(widget.store.id!);
            },
          )
        ],
      ),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.black),
      // ),
    );
  }
}