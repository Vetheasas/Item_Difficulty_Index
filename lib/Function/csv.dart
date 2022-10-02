import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:item_performance/constant.dart';

import 'package:item_performance/Components/button.dart' as menu;
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:csv/csv.dart';

class CSV {
  int maxScore = 0;
  int numberOfItems = 0;
  List correctAnswerNumbers = [];

  List field = [];
  CSV();
  Future<bool> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = File(file.path!).openRead();
      field = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();
      // log('${field[0]}');
      log('field length is ${field}');
      return true;
    } else {
      return false;
    }
  }

  void inputData(int fullScore, int nItems) {
    numberOfItems = nItems;
    maxScore = fullScore;
  }

  bool checkIsBrowsed() {
    if (field == []) {
      return false;
    } else {
      return true;
    }
  }

  List returnRawData() {
    log('field is $field');
    return field;
  }

  DateTime getTestDateTime() {
    int index = 0;
    int TestDateIndex = 0;
    String testDate = '';
    while (index < field[0].length) {
      if (field[0][index].contains('/ $maxScore')) {
        TestDateIndex = index - 1;
        testDate = (field[0][TestDateIndex]).split('[Feedback]')[1];
        log('testDate is ${testDate}');
        String date = ((testDate.split(" "))[0]).substring(
            1); // substring is used to remove letter from the string // THERE IS ONE INVISIBLE PAGE BREAK/LETTER THERE// THAT IS WHY I USED SUBSTRING
        log(date);
        List dateTest = (date.split("/"));
        log('dateTest is $dateTest');
        String processedTestDate =
            '${dateTest[2]}/${dateTest[1]}/${dateTest[0]}';
        log(' ${processedTestDate}');
        return DateFormat('d/M/y').parse(processedTestDate);
      }
      index++;
    }
    print('It is not working');
    return DateTime.now();
  }

  List showResult() {
    print(numberOfItems);
    print(maxScore);
    int index = 0;
    int sum = 0;
    correctAnswerNumbers = [];
    int ind = 0;
    while (ind < numberOfItems) {
      print('ind is $ind');
      correctAnswerNumbers.add([]);
      ind++;
    }
    for (var i in field[0]) {
      if (!i.contains('/ $maxScore')) {
        if (i.contains('.00')) {
          if (!i.contains('0.00')) {
            correctAnswerNumbers[sum].add(1);
          } else if (i.contains('0.00')) {
            correctAnswerNumbers[sum].add(0);
          }
          // log('Index is $index');
          // log('$i');
          sum++;
          if (sum == numberOfItems) {
            sum = 0;
          }
          // findout why sum isn't 195 but it is 185 why 22 fullscore doesnt count
        }
      }

      index++;
    }
    log('${correctAnswerNumbers}');
    return correctAnswerNumbers;
  }
}
