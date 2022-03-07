import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:untitled7/data/util.dart';
import 'package:untitled7/page.dart';

import 'main.dart';

class SubmitListProvider extends ChangeNotifier {
  Logger logger = Logger();
  final dbHelper = PageProvider();

  int selectedDay = 20220306;
  int selectedDay3 = 20220306;

  List<Store> _submitList = [];
  List<Store> submitList3 = [];

  Map<int, List<Store>> submitList2 = {};

  List<Store> get submitList => _submitList;

  final Map<int, dynamic> _length = {};

  Map<int, dynamic> get length2 => _length;




  set submitList(value) {
    _submitList = value;
    notifyListeners();
  }

  SubmitListProvider() {
    logger.i('provider con');
    // getSubmitList();
  }

  SubmitListProvider.se(selectedDay) {
    this.selectedDay = selectedDay;
    // getSubmitList();
  }

  Future<List<Store>> getSubmitList() async {
    submitList = await dbHelper.getStoreByDate(selectedDay);
    logger.i('!!submitList Length: ${submitList.length}');
    return submitList;
  }
  Future<List<Store>> getSubmitList3(selectedDay) async {
    selectedDay3 = selectedDay;
    var tempSubmitList3 = await dbHelper.getStoreByDate(selectedDay);
    if(!identical(submitList3, tempSubmitList3)){
      submitList3=tempSubmitList3;
      notifyListeners();
    }



    logger.i('!!submitList Length: ${submitList3.length}');
    return submitList3;
  }

  void getSubmitList2(day) async {
    var a = await dbHelper.getStoreByDate(day);
    submitList2[day] = a;
    notifyListeners();
  }

  Future<int> getLength(int day) async {
    var dayStoreList = await dbHelper.getStoreByDate(day);

    if (_length[day] == null) {
      _length[day] = dayStoreList.length;
      notifyListeners();
      return dayStoreList.length;
    } else {
      if (_length[day] != dayStoreList.length) {
        _length[day] = dayStoreList.length;
        notifyListeners();
      }
    }

    // if (a.isNotEmpty) {
    // } else {
    //   _length[day] = dayStoreList.length;
    //   // notifyListeners();
    //
    // }
    return dayStoreList.length;
  }

  void delete(int i) async {
    dbHelper.delete(i);
    // notifyListeners();
    getSubmitList3(selectedDay3);
  }
}
