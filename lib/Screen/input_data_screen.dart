// TODO: Create browse screen => then input maxscore and nitems screen tomorrow

import 'package:flutter/material.dart';
import 'package:item_performance/Components/desktop_tutorial/tutorial.dart';
import 'package:item_performance/Components/mobile_tutorial/tutorial.dart';
import 'package:item_performance/Components/alert_dialog.dart';
import 'package:item_performance/Screen/test_database_screen.dart';
import 'package:item_performance/constant.dart';

import 'package:item_performance/Components/button.dart' as menu;
import 'package:url_launcher/url_launcher.dart';
import 'menu/menu.dart';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:item_performance/Function/csv.dart';
import 'package:item_performance/Function/item_calculation.dart';
import 'package:provider/provider.dart';
import 'package:item_performance/Data/list_data.dart';
import 'package:item_performance/Model/test_model.dart';
import 'package:item_performance/Function/test_processing.dart';
import 'package:item_performance/Components/button.dart';
import 'package:item_performance/DataBase/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputData extends StatefulWidget {
  @override
  State<InputData> createState() => _InputDataState();
}

int maxScore = 0;
int numberOfItems = 0;
CSV csv = CSV();
Calculation calc = Calculation();

class _InputDataState extends State<InputData> {
  TextEditingController testName = TextEditingController();

  List rawData = [];
  bool isBrowsed = false;
  List processData = [];
  List itemPerformanceIndex = [];
  late Test test;
  var dbHelper = DatabaseHelper.instance;
  List<Test> testsList = [];
  List<TestButton> testListButton = [];
  List<TestButton> getTestListButton(List<Test> testsList) {
    List<TestButton> testListButton = [];
    print('testsListzzzzzzzzzzzzz is $testsList');
    for (Test test in testsList) {
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

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
  }

  void _insert(String? testDate, double? idi, int numberOfItems) async {
    // DatabaseHelper.instance.getTestTableName(testName.text);
    dbHelper.getTestTableName(testName.text);
    Map<String, dynamic> row = {
      dbHelper.columnTestDate: testDate,
      dbHelper.columnItemIDI: idi,
    };
    dbHelper.create();
    if ((await dbHelper.queryRowCount())! < numberOfItems) {
      await dbHelper.insert(row);
    }
    print('Inserted date is $testDate');
    print('Inserted idi is $idi');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    log('${await dbHelper.queryRowCount()}');
  }

  void _getTestsList() async {
    Provider.of<ListData>(context, listen: false).createTestListScreen();
    // you have to move every element that needs await into the same function/place
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TestListScreen()));
  }

  int findFullScore(List list) {
    List extractedList = [];
    int fullScore = 0;
    for (var i in list) {
      if (i.contains(' / ')) {
        if (!i.contains('--')) {
          List splitList = i.split(' / ');
          for (String x in splitList) {
            log('x is $x');
            try {
              if (fullScore < double.parse(x)) {
                fullScore = (double.parse(x)).toInt();
              }
            } catch (e) {
              log('error x is $x');
            }
            extractedList.add(i);
          }
        }
      }
    }
    print(extractedList);
    print(extractedList.length);
    print('fullscore is $fullScore');
    return fullScore;
  }

  int findNumberOfItem(List list, int fullScore) {
    int numberOfItem = 0;
    bool startCounting = false;
    int index = 0;
    int foundFullScore = 0;
    while (index < list.length) {
      if (list[index].contains(' / ')) {
        if (!list[index].contains('--')) {
          if (startCounting == true) {
            if (!list[index].contains(' / $fullScore')) {
              print('list[index] is ${list[index]}');
              numberOfItem++;
            }
          }

          if (list[index].contains(' / $fullScore')) {
            startCounting = true;
            foundFullScore++;
          }
          if (foundFullScore == 2) {
            index = list.length;
          }
        }
      }
      index++;
    }
    return numberOfItem;
  }

  void _processingData(String testName) async {
    prefs = await SharedPreferences.getInstance();
    log('pref is ${prefs.getBool("loggedIn")}');
    log('testName is $testName');
    if (prefs.getBool("loggedIn") == null) {
      // check if this is the first time
      // when prefs is first initi alized, it is null not false
      getSharedPreferences();
      //db will initialize if you access its instance
      setState(() {
        // try {
        DatabaseHelper.instance.getTestTableName(testName);
        rawData = csv.returnRawData()[0];
        maxScore = findFullScore(rawData);
        numberOfItems = findNumberOfItem(rawData, maxScore);
        csv.inputData(maxScore, numberOfItems);
        log('$rawData');
        processData =
            calc.getGradedStudentList(rawData, maxScore, numberOfItems);
        int i = 0;

        itemPerformanceIndex = [];
        DateTime testDate = csv.getTestDateTime();
        while (i < numberOfItems) {
          _insert(
              '$testDate',
              calc.calculateItemDifficultyIndex(
                  processData, processData.length, i),
              numberOfItems);
          itemPerformanceIndex.add(calc.calculateItemDifficultyIndex(
              processData, processData.length, i));
          i++;
        }
        print('processData length is ${processData.length}');

        log('process data is${processData}');
        log('ipi is${itemPerformanceIndex}');
        log('$i');
        _query();
        test = ProcessingTest.instance
            .processTest(testName, testDate, itemPerformanceIndex, []);
        try {
          _getTestsList();
        } catch (e) {
          _query();
        }

        //done with creating test item

        //TODO: create a test/table list based on the number of table in the database
        //access all table, get the table name, get all the test date, calculate the quality of the test
        log('testlist is $testsList');

        log('testListButton is $testListButton');
      });
    } else if (await dbHelper.checkIfTableExisted(testName) == false) {
      setState(() {
        // try {

        rawData = csv.returnRawData()[0];
        maxScore = findFullScore(rawData);
        numberOfItems = findNumberOfItem(rawData, maxScore);
        csv.inputData(maxScore, numberOfItems);
        log('$rawData');
        processData =
            calc.getGradedStudentList(rawData, maxScore, numberOfItems);
        int i = 0;

        itemPerformanceIndex = [];
        DateTime testDate = csv.getTestDateTime();
        while (i < numberOfItems) {
          _insert(
              '$testDate',
              calc.calculateItemDifficultyIndex(
                  processData, processData.length, i),
              numberOfItems);
          itemPerformanceIndex.add(calc.calculateItemDifficultyIndex(
              processData, processData.length, i));
          i++;
        }
        print('processData length is ${processData.length}');

        log('process data is${processData}');
        log('ipi is${itemPerformanceIndex}');
        log('$i');
        _query();
        test = ProcessingTest.instance
            .processTest(testName, testDate, itemPerformanceIndex, []);
        try {
          _getTestsList();
        } catch (e) {
          _query();
        }

        //done with creating test item

        //TODO: Create pop up that will state that the user forgot to write the test name,score...etc
        //TODO: Update the tutorial last photo with the current Input Data Screen and instruction
        //access all table, get the table name, get all the test date, calculate the quality of the test
        log('testlist is $testsList');

        log('testListButton is $testListButton');
      });
    } else {
      print('The name is already existed');
      showAlertDialog(context, true);
    }
  }

  void pickFile() async {
    bool browsed = await csv.pickFile();
    setState(() {
      isBrowsed = false;
      isBrowsed = browsed;
      print('isBrowsed is $isBrowsed');
    });
  }

  Widget getTutorialPlatform() {
    if (Platform.isAndroid) {
      print('android');
      return MobileTutorial();
    } else {
      return DesktopTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // not resizing when keyboard pop up
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF2b2622)),
        title: Text(
          'Input Data',
          style: defaultTextStyle.copyWith(
              fontWeight: FontWeight.w700, fontSize: 23),
        ),
        backgroundColor: Color(0xFF7070a0),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFF46486c)),
          child: Column(
            children: [
              isBrowsed
                  ? Container()
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          menu.MenuButton(
                            flex: 1,
                            buttonText: 'Download Sample',
                            goRoute: () async {
                              var url = Uri.parse(
                                  'https://drive.google.com/drive/folders/1knPWsab70Ll_8ICqrjhJJtInj5aiOYUA?usp=sharing');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          menu.MenuButton(
                            flex: 2,
                            buttonText: 'Tutorial',
                            goRoute: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          getTutorialPlatform()));
                            },
                          ),
                          menu.MenuButton(
                            flex: 2,
                            buttonText: 'Browse For CSV',
                            goRoute: () async {
                              pickFile();
                              // setState(() {
                              //    = csv.checkIsBrowsed();
                              // });
                            },
                          ),
                        ],
                      ),
                    ),
              isBrowsed
                  ? Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DataLabel(
                            label: 'Test Name',
                          ),
                          DataTextField(
                            controller: testName,
                            hintText:
                                'Write the test name here', //TODO: try to make it not accept inputted names (NAME ALREADY EXISTED)
                            textInputType: TextInputType.text,
                          ),
                          menu.MenuButton(
                            flex: 1,
                            buttonText: 'Done',
                            goRoute: () {
                              if (testName.text == "") {
                                showAlertDialog(context, false);
                              } else {
                                _processingData(testName.text);
                              }
                            },
                          ),
                          Expanded(flex: 4, child: Container())
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class DataLabel extends StatelessWidget {
  late String label;
  DataLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 3, right: 30, top: 20),
      child: Text(
        label,
        style: TextStyle(color: Color(0xFF262626)),
      ),
    );
  }
}

class DataTextField extends StatelessWidget {
  late String hintText;
  TextEditingController controller = TextEditingController();
  TextInputType textInputType;
  DataTextField(
      {required this.hintText,
      required this.controller,
      required this.textInputType});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: hintText, filled: true, fillColor: Colors.white),
      ),
    );
  }
}

// void inputOriginal(){
//   setState(() {
//     // try {
//     maxScore = int.parse(fullScore.text);
//     numberOfItems = int.parse(nItems.text);
//     csv.inputData(maxScore, numberOfItems);
//
//     rawData = csv.returnRawData()[0];
//     log('$rawData');
//     processData =
//         calc.getGradedStudentList(rawData, maxScore, numberOfItems);
//     int i = 0;
//
//     itemPerformanceIndex = [];
//     DateTime testDate = csv.getTestDateTime();
//     while (i < numberOfItems) {
//       _insert(
//           '$testDate',
//           calc.calculateItemDifficultyIndex(
//               processData, processData.length, i),
//           numberOfItems);
//       itemPerformanceIndex.add(calc.calculateItemDifficultyIndex(
//           processData, processData.length, i));
//       i++;
//     }
//     print('processData length is ${processData.length}');
//
//     log('process data is${processData}');
//     log('ipi is${itemPerformanceIndex}');
//     log('$i');
//     _query();
//     test = ProcessingTest.instance
//         .processTest(testName, testDate, itemPerformanceIndex, []);
//     try {
//       _getTestsList();
//     } catch (e) {
//       _query();
//     }
//
//     //done with creating test item
//
//     //TODO: create a test/table list based on the number of table in the database
//     //access all table, get the table name, get all the test date, calculate the quality of the test
//     log('testlist is $testsList');
//
//     // test.printTest();
//     // _getTestName();
//     // _getTestDate();
//     // _getIDI();
//     log('testListButton is $testListButton');
//     // log('${calc.calculateItemDifficultyIndex(processData[0], processData.length)}');
//     // } catch (e) {
//     //   print(e);
//     //   print(int.parse(fullScore.text));
//     //   print(int.parse(nItems.text));
//     // }
//   });
// }
