import 'package:flutter/material.dart';
import 'package:item_performance/Screen/individual_item_screen.dart';
import 'package:item_performance/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:item_performance/Model/item_model.dart';
import 'package:item_performance/Screen/item_difficulty_list_screen/item_performance_screen.dart';
import 'package:intl/intl.dart';
import 'package:item_performance/Data/list_data.dart' as data;
import 'package:provider/provider.dart';
import 'package:item_performance/Function/item_processing.dart';

import 'package:item_performance/DataBase/database_helper.dart';
import 'dart:developer';

import 'package:responsive_builder/responsive_builder.dart';

class MenuButton extends StatelessWidget {
  late String buttonText;
  late VoidCallback goRoute;
  late int flex;
  MenuButton(
      {required this.buttonText, required this.goRoute, required this.flex});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
          child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.all(
                  Color(0xFF9792bd),
                ),
              ),
              onPressed: goRoute,
              child: Container(
                  child: Text(
                buttonText,
                style: defaultTextStyle.copyWith(
                    fontSize: sizingInformation.deviceScreenType ==
                            DeviceScreenType.mobile
                        ? 25
                        : 50),
              ))),
        );
      }),
    );
  }
}

class TestButton extends StatelessWidget {
  //use inheritance or interface with ItemButton
  late String testName;
  late String dateText;
  late int itemQuality;
  late List itemPerformance;
  late List testList;
  late DateTime? testDate;
  late double fontSize;
  TestButton({
    required this.testName,
    required this.itemQuality,
    required this.itemPerformance,
    required this.testDate,
  });
  Widget itemQualityImage() {
    if (itemQuality == 0) {
      return Image.asset(
        'images/Cross.png',
        fit: BoxFit.scaleDown,
      );
    } else if (itemQuality == 1) {
      return Image.asset(
        'images/Check.png',
        fit: BoxFit.scaleDown,
      );
    } else {
      return Image.asset(
        'images/question.png', //TODO: try to use exclamation mark tomorrow
        fit: BoxFit.scaleDown,
      );
    }
  }

  double getMobileFontSize() {
    if (testName.length > 18) {
      return 9;
    } else {
      return 20;
    }
  }

  double getDesktopFontSize() {
    if (testName.length > 18) {
      return 18;
    } else {
      return 40;
    }
  }

  String getTestName() {
    String processedString = testName;
    if (processedString[0] == '_') {
      processedString = processedString.substring(1);
    }
    if (processedString.contains('_')) {
      log('processedString is $processedString');
      processedString = processedString.replaceAll('_', ' ');
    }
    return processedString;
  }

  void goToIDI(context) async {
    List<Item> itemList = [];
    List<double> newIDIList = [];
    newIDIList =
        await DatabaseHelper.instance.getIDIList(testName); // get new idiList
    itemList = process.process(newIDIList, testName);
    Provider.of<data.ListData>(context, listen: false).resetList();
    Provider.of<data.ListData>(context, listen: false).createItemsList(
        itemList, //TODO: test removing item => see if it actually refreshes immediately
        false);
    Navigator.push(
        context,
        MaterialPageRoute<bool>(
            builder: (context) => ItemPerformanceScreen(
                  testName: testName,
                ))).then((bool? res) {
      // check here if you got your data or not
      if (res != null && res == true) {
        Provider.of<data.ListData>(context, listen: false)
            .createTestListScreen();
      }
    }); //TODO: test out changelist from multiple test_x
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2),
        child: ResponsiveBuilder(builder: (context, sizingInformation) {
          return SizedBox(
            width: double.infinity,
            height:
                sizingInformation.deviceScreenType == DeviceScreenType.mobile
                    ? 100
                    : 200,
            child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor: MaterialStateProperty.all(
                    // itemQuality ? Color(0xFF185f36) : Color(0xFF73242b),
                    Color(0xFF46486c),
                  ),
                ),
                onPressed: () {
                  Provider.of<data.ListData>(context, listen: false)
                      .resetList(); // reset the list so that everytime we load/process the item, the list
                  goToIDI(
                      context); // When using a database, to be dynamic, we should use/query the database as much as possible.
                },
                child: Stack(
                  children: [
                    Positioned(
                      left: sizingInformation.deviceScreenType ==
                              DeviceScreenType.mobile
                          ? 10
                          : 20,
                      right: sizingInformation.deviceScreenType ==
                              DeviceScreenType.mobile
                          ? 50
                          : 100,
                      top: sizingInformation.deviceScreenType ==
                              DeviceScreenType.mobile
                          ? 30
                          : 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTestName(),
                            style: defaultTextStyle.copyWith(
                                fontSize: sizingInformation.deviceScreenType ==
                                        DeviceScreenType.mobile
                                    ? getMobileFontSize()
                                    : getDesktopFontSize()),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${DateFormat('yyyy-MM-dd').format(testDate!)}',
                            style: defaultTextStyle.copyWith(
                                fontSize: sizingInformation.deviceScreenType ==
                                        DeviceScreenType.mobile
                                    ? 13
                                    : 26,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: sizingInformation.deviceScreenType ==
                                DeviceScreenType.mobile
                            ? 240
                            : MediaQuery.of(context).size.width - 200,
                        top: sizingInformation.deviceScreenType ==
                                DeviceScreenType.mobile
                            ? 14
                            : 34,
                        child: SizedBox(
                            width: sizingInformation.deviceScreenType ==
                                    DeviceScreenType.mobile
                                ? 67
                                : 124,
                            height: sizingInformation.deviceScreenType ==
                                    DeviceScreenType.mobile
                                ? 67
                                : 124,
                            child: itemQualityImage()))
                  ],
                )),
          );
        }));
  }
}

class ItemButton extends StatelessWidget {
  late String buttonText;
  late int itemQuality;
  late List itemPerformance;
  late Item item;
  late int itemIndex;
  late int itemNumberPosition;
  late bool isAddedToChangeList;
  late bool isIDIScreen;
  double rightPadding = 70;
  late bool isGood;
  late String testName;

  ItemButton(
      {required this.buttonText,
      required this.itemQuality,
      required this.itemPerformance,
      required this.itemIndex,
      required this.itemNumberPosition,
      required this.isGood,
      required this.isAddedToChangeList,
      required this.item,
      required this.isIDIScreen,
      required this.testName});
  Widget itemQualityImage() {
    if (itemQuality == 0) {
      return Image.asset(
        'images/Cross.png',
        fit: BoxFit.scaleDown,
      );
    } else if (itemQuality == 1) {
      return Image.asset(
        'images/Check.png',
        fit: BoxFit.scaleDown,
      );
    } else {
      return Image.asset(
        'images/question.png', //TODO: try to use exclamation mark tomorrow
        fit: BoxFit.scaleDown,
      );
    }
  }

  void refreshScreen(context) async {
    List<Item> itemList = [];
    List<double> newIDIList = [];
    newIDIList = await DatabaseHelper.instance.getIDIList(
        Provider.of<data.ListData>(context, listen: false)
            .getTestName()); // get new idiList
    itemList = process.process(newIDIList,
        Provider.of<data.ListData>(context, listen: false).getTestName());
    Provider.of<data.ListData>(context, listen: false).resetList();
    Provider.of<data.ListData>(context, listen: false).createItemsList(
        itemList, //TODO: test removing item => see if it actually refreshes immediately
        false); //TODO: test out changelist from multiple test_x
  }

  @override
  Widget build(BuildContext context) {
    if (buttonText.length < 7) {
      rightPadding = 89;
    }
    if (buttonText == 'Item 1') {
      rightPadding = 93;
    }
    if (buttonText == 'Item 11') {
      rightPadding = 80;
    }
    if (buttonText == 'Item 21') {
      rightPadding = 77;
    }
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          width: sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? double.infinity
              : 100,
          height: 100,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(2),
              backgroundColor: MaterialStateProperty.all(
                // itemQuality ? Color(0xFF185f36) : Color(0xFF73242b),
                Color(0xFF46486c),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                      builder: (context) => IItemScreen(
                            itemNumber: itemNumberPosition,
                            itemScore: item.itemScore,
                            itemQuality:
                                ProcessingItem().itemQuality(item.itemScore),
                            itemName: 'Item $itemNumberPosition',
                            isIDIScreen: isIDIScreen,
                            testName: testName,
                          ))).then((bool? res) {
                // check here if you got your data or not
                if (res != null && res == true) {
                  refreshScreen(context);
                }
              });
            },
            child: ScreenTypeLayout(
              tablet: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    //TODO: learn to use positioned or stacks next time
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.file,
                        color: Color(0xFF2b2622),
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          buttonText,
                          style: defaultTextStyle.copyWith(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                      width: 85, height: 85, child: itemQualityImage()),
                ),
              ]),
              desktop: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    //TODO: learn to use positioned or stacks next time
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.file,
                        color: Color(0xFF2b2622),
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          buttonText,
                          style: defaultTextStyle.copyWith(fontSize: 40),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                      width: 100, height: 100, child: itemQualityImage()),
                ),
              ]),
              mobile: Stack(children: [
                Positioned(
                  left: 10,
                  right: 50,
                  top: 30,
                  child: Row(
                    //TODO: learn to use positioned or stacks next time

                    children: [
                      FaIcon(
                        FontAwesomeIcons.file,
                        color: Color(0xFF2b2622),
                        size: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                            child: Text(
                          buttonText,
                          style: defaultTextStyle.copyWith(fontSize: 37),
                        )),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width - 120,
                  top: 14,
                  child: SizedBox(
                      width: 67, height: 67, child: itemQualityImage()),
                )
              ]),
            ),
          ),
        ),
      );
    });
  }
}

//TODO: for the first time, when go into testlist,
//TODO: if you add a test to changelist, it won't add the test to the list
//TODO: find out why
//TODO: and fix it // Maybe it has something to do with the double refresh??
//TODO: changeItem is []

//TODO: When go to changeList before adding, it will work normally. Why?????
class ChangeListItemButtons extends StatelessWidget {
  late int itemQuality;
  late int itemNumber;
  late double itemScore;
  late String itemName;
  late String testName;
  double rightPadding = 70;

  ChangeListItemButtons(
      {required this.itemNumber,
      required this.itemScore,
      required this.itemQuality,
      required this.itemName,
      required this.testName});
  Widget itemQualityImage() {
    if (itemQuality == 0) {
      return Image.asset(
        'images/Cross.png',
        fit: BoxFit.scaleDown,
      );
    } else if (itemQuality == 1) {
      return Image.asset(
        'images/Check.png',
        fit: BoxFit.scaleDown,
      );
    } else {
      return Image.asset(
        'images/question.png', //TODO: try to use exclamation mark tomorrow
        fit: BoxFit.scaleDown,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (itemName.length < 7) {
      rightPadding = 89;
    }
    if (itemName == 'Item 1') {
      rightPadding = 93;
    }
    if (itemName == 'Item 11') {
      rightPadding = 80;
    }
    if (itemName == 'Item 21') {
      rightPadding = 77;
    }
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          width: sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? double.infinity
              : 100,
          height: 100,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(2),
              backgroundColor: MaterialStateProperty.all(
                // itemQuality ? Color(0xFF185f36) : Color(0xFF73242b),
                Color(0xFF46486c),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IItemScreen(
                            itemNumber: itemNumber,
                            itemScore: itemScore,
                            itemQuality: itemQuality,
                            itemName: itemName,
                            isIDIScreen: false,
                            testName: testName,
                          )));
            },
            child: ScreenTypeLayout(
              tablet: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    //TODO: learn to use positioned or stacks next time
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.file,
                        color: Color(0xFF2b2622),
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          itemName,
                          style: defaultTextStyle.copyWith(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                      width: 85, height: 85, child: itemQualityImage()),
                ),
              ]),
              desktop: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    //TODO: learn to use positioned or stacks next time
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.file,
                        color: Color(0xFF2b2622),
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          itemName,
                          style: defaultTextStyle.copyWith(fontSize: 40),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                      width: 100, height: 100, child: itemQualityImage()),
                ),
              ]),
              mobile: Stack(children: [
                Positioned(
                  left: 10,
                  right: 50,
                  top: 30,
                  child: Row(
                    //TODO: learn to use positioned or stacks next time

                    children: [
                      FaIcon(
                        FontAwesomeIcons.file,
                        color: Color(0xFF2b2622),
                        size: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                            child: Text(
                          itemName,
                          style: defaultTextStyle.copyWith(fontSize: 37),
                        )),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 240,
                  top: 14,
                  child: SizedBox(
                      width: 67, height: 67, child: itemQualityImage()),
                )
              ]),
            ),
          ),
        ),
      );
    });
  }
}
