import 'item_model.dart';
import 'dart:developer';

class Test {
  late String testName;
  late DateTime? testDate;
  late List itemIndexDifficultyList;
  late int testQuality; // 0 = bad , 1 = good , 2 = questionable
  late List? changeList;
  Test(
      {required this.testName,
      required this.testDate,
      required this.itemIndexDifficultyList,
      required this.testQuality,
      required this.changeList});
  void printTest() {
    log('testName is $testName');
    log('testDate is $testDate');
    log('itemIndexDifficultyList $itemIndexDifficultyList');
    log('testQuality is $testQuality');
  }
}
