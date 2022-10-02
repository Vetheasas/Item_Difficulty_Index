import 'dart:developer';
import 'dart:ui';
import 'package:item_performance/Data/load_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:item_performance/constant.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:io' show Platform;
import 'package:item_performance/Components/button.dart' as menu;
import 'package:item_performance/Model/test_model.dart';

List<Widget> changeList = []; // make change screen access data through db

class ChangeScreen extends StatefulWidget {
  @override
  State<ChangeScreen> createState() => _ChangeScreenState();
}

List<menu.TestButton> getTestListButton(List<Test> testsList) {
  List<menu.TestButton> testListButton = [];
  // print('testsListzzzzzzzzzzzzz is $testsList');
  for (Test test in testsList) {
    print('TEST.IDILIST IS ${test.itemIndexDifficultyList}');
    testListButton.add(menu.TestButton(
      testName: test.testName,
      itemQuality: test.testQuality,
      itemPerformance: test
          .itemIndexDifficultyList, //check this , why does it have the same idi in the itemperformanceList??
      testDate: test.testDate,
    ));
  }

  return testListButton;
}

class _ChangeScreenState extends State<ChangeScreen> {
  List<menu.TestButton> changesListButton = [];

  List<menu.TestButton> testListButton = [];

  @override
  Widget build(BuildContext context) {
    log('Provider.of<LoadData>(context, listen: true).getChangeList is ${Provider.of<LoadData>(context, listen: true).getChangeList[0]}');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          height: Platform.isAndroid ? 79 : 56,
          decoration: BoxDecoration(color: Color(0xFF7070a0)),
          child: Padding(
            padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButton(color: Color(0xFF2c2724)),
                Padding(
                  padding: Platform.isAndroid
                      ? const EdgeInsets.only(left: 20, top: 2, right: 50)
                      : const EdgeInsets.only(left: 33, top: 2),
                  child: Text(
                    'Change List',
                    style: defaultTextStyle.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 23),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xFF46486c)),
          child: ScreenTypeLayout(
            tablet: GridView.count(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              crossAxisCount: 3,
              children:
                  Provider.of<LoadData>(context, listen: true).getChangeList,
            ),
            mobile: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: Provider.of<LoadData>(context, listen: true)
                      .getChangeList,
                )),
            desktop: GridView.count(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              crossAxisCount: 4,
              children:
                  Provider.of<LoadData>(context, listen: true).getChangeList,
            ),
          ),
        ),
      ),
    );
  }
}
