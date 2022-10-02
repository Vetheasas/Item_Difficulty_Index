//create a database screen for all test that was processed by the app
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:item_performance/Screen/menu/menu.dart';
import 'package:item_performance/constant.dart';
import 'package:item_performance/Function/item_processing.dart';
import 'package:provider/provider.dart';
import 'package:item_performance/Data/list_data.dart';
import 'package:item_performance/Model/test_model.dart';
import 'package:item_performance/Components/button.dart';
import 'package:item_performance/DataBase/database_helper.dart';

class TestListScreen extends StatefulWidget {
  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

ProcessingItem process = ProcessingItem();
bool isProcessed = false;

class _TestListScreenState extends State<TestListScreen> {
  List itemPerformance = [];
  List<TestButton> getTestListButton(List<Test> testsList) {
    List<TestButton> testListButton = [];
    // print('testsListzzzzzzzzzzzzz is $testsList');
    for (Test test in testsList) {
      print('TEST.IDILIST IS ${test.itemIndexDifficultyList}');
      test.printTest();
      testListButton.add(TestButton(
        testName: test.testName,
        itemQuality: test.testQuality,
        itemPerformance: test
            .itemIndexDifficultyList, //check this , why does it have the same idi in the itemperformanceList??
        testDate: test.testDate,
      ));
    }

    return testListButton;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainMenu())),
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        iconTheme: IconThemeData(color: Color(0xFF2b2622)),
        title: Text(
          'Test List',
          style: defaultTextStyle.copyWith(
              fontWeight: FontWeight.w700, fontSize: 23),
        ),
        backgroundColor: Color(0xFF7070a0),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xFF46486c)),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  Provider.of<ListData>(context, listen: true).getTestList(),
            ),
          ),
        ),
      ),
    );
  }
}
