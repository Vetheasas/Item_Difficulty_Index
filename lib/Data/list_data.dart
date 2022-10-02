import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:item_performance/Model/item_model.dart';
import 'package:item_performance/Components/button.dart';
import 'package:item_performance/Function/item_processing.dart';
import 'package:item_performance/DataBase/database_helper.dart';
import 'package:item_performance/Model/test_model.dart';

ProcessingItem process = ProcessingItem();

class ListData with ChangeNotifier {
  List<ItemButton> _itemPerformanceIndex = [];
  List<ItemButton> _changeList = [];
  List<int> _indexList = [];
  List<Item> itemPerformanceIndexScoreList = [];
  List<TestButton> _testListButton = [];
  List<Test> _testsList = [];
  List<TestButton> getTestList() {
    return _testListButton;
  }

  void setTestList(List<Test> testList) {
    _testsList = testList;
  }

  void createTestListScreen() async {
    List<Test> testsList = await DatabaseHelper.instance.getTestsList();
    createTestListButton(testsList);
    notifyListeners();
    // you have to move every element that needs await into the same function/place
  }

  void createTestListButton(List<Test> testsList) {
    _testListButton = [];
    // print('testsListzzzzzzzzzzzzz is $testsList');
    for (Test test in testsList) {
      print('TEST.IDILIST IS ${test.itemIndexDifficultyList}');
      test.printTest();
      _testListButton.add(TestButton(
        testName: test.testName,
        itemQuality: test.testQuality,
        itemPerformance: test
            .itemIndexDifficultyList, //check this , why does it have the same idi in the itemperformanceList??
        testDate: test.testDate,
      ));
    }
  }

  void storeItemPerformanceIndexScoreList(List<Item> idi) {
    itemPerformanceIndexScoreList = idi;
  }

  List<Item> getItemPerformanceIndexScoreList() {
    return itemPerformanceIndexScoreList;
  }

  void createItemsList(List<Item> itemList, bool isAddedToChangeList) {
    //problem from right here
    //create itemList
    itemPerformanceIndexScoreList = List.from(itemList);
    print('ipi list is $itemPerformanceIndexScoreList');

    bool isGood = true;
    for (Item i in itemPerformanceIndexScoreList) {
      isGood = process.isGood(i.itemScore, i);

      addItem(
        ItemButton(
          isAddedToChangeList: isAddedToChangeList,
          buttonText: 'Item ${i.itemNumber}',
          itemQuality: i.keep,
          itemPerformance: itemPerformanceIndexScoreList,
          itemIndex: getItemIndex,
          isGood: isGood,
          itemNumberPosition: i.itemNumber,
          item: i,
          isIDIScreen: true,
          testName: i.testName,
        ),
      );

      print('done');
    }
    notifyListeners();
  }

  void addItem(ItemButton item) {
    _itemPerformanceIndex.add(item);
    _indexList.add(getItemIndex - 1);
    notifyListeners();
    print('The task has been done');
  }

  String getTestName() {
    String testName = _itemPerformanceIndex[0].testName;
    print('TESTNAME is $testName');
    return testName;
  }

  int getItemNumber(int ItemNumberIndex) {
    return _indexList[ItemNumberIndex];
  }

  int get getItemIndex {
    return _itemPerformanceIndex.length;
  }

  void removeItem(int itemIndex) {
    int index = 0;
    _itemPerformanceIndex.removeAt(itemIndex);
    while (index < _itemPerformanceIndex.length) {
      _itemPerformanceIndex[index].itemIndex = index;
      index++;
    }
    //reassign the itemIndex after remove one item
    //Make item x independent of the index number by giving it its own variable
    notifyListeners();
  }

  List<Widget> get getIDIList {
    return _itemPerformanceIndex;
  }

  void resetList() {
    _itemPerformanceIndex = [];
    notifyListeners();
    // if (_itemPerformanceIndex.isNotEmpty) {
    //   _itemPerformanceIndex = [];
    // }
  }

  void addChangeItem(ItemButton item) {
    _changeList.add(item);
    notifyListeners();
  }

  void removeChangeItem(int itemIndex) {
    int index = 0;
    _changeList.removeAt(itemIndex);
    while (index < _changeList.length) {
      _changeList[index].itemIndex = index;
      index++;
    }
    //reassign the itemIndex after remove one item
    notifyListeners();
  }

  List<Widget> get getChangeList {
    return _changeList;
  }

  void clearAllChangeList() {
    _changeList = [];
    notifyListeners();
  }

  int get getChangeListIndex {
    return _changeList.length;
  }
}
