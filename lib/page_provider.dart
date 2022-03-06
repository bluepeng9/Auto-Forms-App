import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:untitled7/data/util.dart';
import 'package:untitled7/page.dart';

import 'main.dart';

class SubmitListProvider extends ChangeNotifier {
  Logger logger = Logger();
  final dbHelper = PageProvider();

  int selectedDay = 20220306;

  List<Store> _submitList = [];

  List<Store> get submitList => _submitList;

  set submitList(value) {
    _submitList = value;
    notifyListeners();
  }

  SubmitListProvider() {
    logger.i('con');
    getSubmitList();
  }

  SubmitListProvider.se(selectedDay) {
    this.selectedDay = selectedDay;
    getSubmitList();
  }


  Future<List<Store>> getSubmitList() async {
    submitList = await dbHelper.getStoreByDate(selectedDay);
    logger.i('!!submitList Length: ${submitList.length}');
    return submitList;
  }

  void delete(int i) async {
    dbHelper.delete(i);
    getSubmitList();
  }
}
