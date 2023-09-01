import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:item_performance/DataBase/database_helper.dart';
import 'package:item_performance/Screen/input_data_screen.dart';
import 'package:item_performance/Screen/test_database_screen.dart';
import 'package:item_performance/constant.dart';

import 'package:item_performance/Components/button.dart' as menu;
import 'package:item_performance/Data/list_data.dart';
import 'package:provider/provider.dart';
import 'package:item_performance/Function/item_processing.dart';

import 'package:item_performance/Model/test_model.dart';
import 'package:item_performance/Components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

late SharedPreferences prefs;

class MainMenu extends StatefulWidget {
  @override
  State<MainMenu> createState() => _MainMenuState();
}

ProcessingItem process = ProcessingItem();
bool isProcessed = false;

//TODO: make menu gain access to Test Object
class _MainMenuState extends State<MainMenu> {
  List<TestButton> getTestListButton(List<Test> testsList) {
    List<TestButton> testListButton = [];
    // print('testsListzzzzzzzzzzzzz is $testsList');
    for (Test test in testsList) {
      print('TEST.IDILIST IS ${test.itemIndexDifficultyList}');
      test.printTest();
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

  void _queryall() async {
    log('${await DatabaseHelper.instance.queryAllRows()}');
  }

  List<menu.TestButton> testListButton = [];

  bool dbWithData = false;
  void checkForFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("loggedIn") == true) {
      //db will initialize if you access its instance

      Provider.of<ListData>(context, listen: false).createTestListScreen();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkForFirstTime(); // you need to initialized pref first

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xFF2b2622)),
        title: Text(
          'Main Menu',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(
                      'images/test_logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              menu.MenuButton(
                flex: 1,
                buttonText: 'Test List',
                goRoute: () {
                  print('a');
                  setState(() {
                    checkForFirstTime();
                    print('dbWithData is $dbWithData');
                  });

                  print('dbWithData is $dbWithData');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestListScreen()));
                },
              ),
              menu.MenuButton(
                flex: 1,
                buttonText: 'Add a new test',
                goRoute: () {
                  print('a');

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InputData()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
