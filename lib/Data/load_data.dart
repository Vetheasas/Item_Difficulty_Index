import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:item_performance/Model/item_model.dart';
import 'package:item_performance/Components/button.dart';
import 'package:item_performance/Function/item_processing.dart';
import 'package:item_performance/DataBase/database_helper.dart';

ProcessingItem process = ProcessingItem();

class LoadData with ChangeNotifier {
  List<ItemButton> _itemPerformanceIndex = [];
  List<ChangeListItemButtons> _changeList = [];
  List<int> _indexList = [];
  DatabaseHelper db = DatabaseHelper.instance;
  void resetList() {
    _changeList = [];
    notifyListeners();
  }

  void loadData(String tableName, bool isAddedToChangeList) {
    //create itemList
    // print('ipi list is $itemPerformanceIndexScoreList');

    int changeListNumberIndex = 0;
    bool isGood = true;
    int changeListLength = DatabaseHelper.instance.getChangeListLength;
    print(
        'DatabaseHelper.instance.changeItem.length is ${DatabaseHelper.instance.changeItem.length}');
    if (_changeList.isEmpty) {
      print('start');
      print('changeListLength is $changeListLength');
      // the changelist is empty, so we need to
      while (changeListNumberIndex < changeListLength) {
        print('Done with changelist');

        addChangeListItemButtons(ChangeListItemButtons(
          itemNumber: DatabaseHelper.instance.changeItem[changeListNumberIndex]
              ['_id'], // need to get the real number
          itemScore: DatabaseHelper.instance.changeItem[changeListNumberIndex][
              'changelist'], //TODO: use something else other than -1 for removing item because it will affect the test overall score
          itemQuality: process.itemQuality(
              DatabaseHelper.instance.changeItem[changeListNumberIndex]
                  ['changelist']), // need to get the real quality
          itemName:
              'Item ${DatabaseHelper.instance.changeItem[changeListNumberIndex]['_id']}',
          testName: tableName,
        ) // change the item name here to more updated one

            );
        log('_changeList is $_changeList');
        print('index is $changeListNumberIndex');
        changeListNumberIndex++;
        print('done');
      }
      notifyListeners();
    } else {
      // there is already data in the changelist
      print('else');
      changeListNumberIndex = _changeList.length - 1;
      print('changeListNumberIndex is $changeListNumberIndex');
      print('_changeList.length is ${_changeList.length}');
      while (changeListNumberIndex < changeListLength) {
        print(' loop changeListNumberIndex is $changeListNumberIndex');
        print(
            'DatabaseHelper.instance.changeItem.length is ${DatabaseHelper.instance.changeItem.length}');
        addChangeListItemButtons(
          ChangeListItemButtons(
            itemNumber: DatabaseHelper.instance
                    .changeItem[DatabaseHelper.instance.changeItem.length - 1]
                ['_id'], // need to get the real number
            itemScore: DatabaseHelper.instance
                    .changeItem[DatabaseHelper.instance.changeItem.length - 1][
                'changelist'], //TODO: use something else other than -1 for removing item because it will affect the test overall score
            itemQuality: process.itemQuality(DatabaseHelper.instance
                    .changeItem[DatabaseHelper.instance.changeItem.length - 1]
                ['changelist']), // need to get the real quality
            itemName:
                'Item ${DatabaseHelper.instance.changeItem[DatabaseHelper.instance.changeItem.length - 1]['_id']}',
            testName: tableName,
          ), // change the item name here to more updated one
        );
        changeListNumberIndex++;
      }
      notifyListeners();
    }
  }

  void addChangeListItemButtons(ChangeListItemButtons item) {
    // add ChangeListItemButton to changelist
    _changeList.add(item);
    _indexList.add(getItemIndex - 1);
    notifyListeners();
    print('The task has been done');
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

  // void resetList() {
  //   if (_itemPerformanceIndex.isNotEmpty) {
  //     _itemPerformanceIndex = [];
  //   }
  // }

  void addChangeItem(ChangeListItemButtons item) {
    _changeList.add(item);
    notifyListeners();
  }

  void removeChangeItem(int itemIndex) {
    int index = 0;
    _changeList.removeAt(itemIndex);
    while (index < _changeList.length) {
      _changeList[index].itemNumber = index;
      index++;
    }
    //reassign the itemIndex after remove one item
    notifyListeners();
  }

  List<ChangeListItemButtons> get getChangeList {
    return _changeList;
  }

  bool changeListIsEmpty() {
    if (_changeList.length == 0) {
      return true;
    } else {
      print('_changeList.length is ${_changeList.length}');
      return false;
    }
  }

  void clearAllChangeList() {
    _changeList = [];
    notifyListeners();
  }

  int get getChangeListIndex {
    return _changeList.length;
  }
}
