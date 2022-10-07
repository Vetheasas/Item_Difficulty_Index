import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:item_performance/constant.dart';

import 'package:item_performance/Model/item_model.dart';

import 'package:item_performance/Function/item_processing.dart';

import 'package:provider/provider.dart';
import 'package:item_performance/Data/list_data.dart';
import 'package:item_performance/DataBase/database_helper.dart';
import 'package:responsive_builder/responsive_builder.dart';

int timeDeleted = 0;

class IItemScreen extends StatefulWidget {
  late int itemQuality;
  late int itemNumber;
  late double itemScore;
  late String itemName;
  late bool isIDIScreen;
  late String testName;

  IItemScreen(
      {required this.itemNumber,
      required this.itemScore,
      required this.itemQuality,
      required this.itemName,
      required this.isIDIScreen,
      required this.testName});
  @override
  State<IItemScreen> createState() => _IItemScreenState();
}

class _IItemScreenState extends State<IItemScreen> {
  ProcessingItem process = ProcessingItem();
  late bool keepOrRevise;

  late String description;
  late bool bigFontSize;

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  Widget itemQualityImage() {
    if (widget.itemQuality == 0) {
      return Image.asset(
        'images/Cross.png',
        fit: BoxFit.scaleDown,
      );
    } else if (widget.itemQuality == 1) {
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

  void showAll() {
    log('itemNumber is ${widget.itemNumber}');
  }

  void insertItemInDB(int columnId) async {
    dbHelper.getTestTableName(widget.testName);
    double changeListItem = await dbHelper
        .getSpecificIDI(widget.itemNumber); // ITEM NUMBER KINDA MESSED UP
    log('changeListItem is $changeListItem');
    Map<String, dynamic> erasedItem = {
      dbHelper.columnId: columnId,
      dbHelper.columnItemIDI: 0.00000001,
    };
    final IDIrowsAffected = await dbHelper.update(erasedItem);
    Map<String, dynamic> changeItem = {
      dbHelper.columnId: columnId,
      dbHelper.columnChangeList:
          changeListItem, //TODO: create dynamic index to the item with the help of parallel list(dynamic(removeList) and itemList)
    }; // check whether the item already existed in the database using hash??, THERE ARE DOUBLE ITEM FROM THIS
    dbHelper.addToCLNumber(await dbHelper.update(changeItem));
  }

  @override
  void initState() {
    // keepOrRevise= (widget.itemPerformanceIndex[widget.itemIndex])
    showAll();
    description = process.getDescription(widget.itemScore);
    if (description.length > 50) {
      bigFontSize = false;
    } else {
      bigFontSize = true;
    }

    super.initState();
  }

  List<Item> itemList = [];
  List<double> newIDIList = [];
  void refreshItemPerformanceList() async {
    // refresh itemPerformanceList and pop( return true to )
    newIDIList = await DatabaseHelper.instance
        .getIDIList(widget.testName); // get new idiList
    itemList = process.process(newIDIList, widget.testName);
    Provider.of<ListData>(context, listen: false).resetList();
    Provider.of<ListData>(context, listen: false).createItemsList(
        itemList, //TODO: test removing item => see if it actually refreshes immediately
        false); //TODO: test out changelist from multiple test_x
    Navigator.pop(context, true);
    //TODO: WHY DO I NEED TO DO THIS TWICE TO ACTUALLY REFRESH? WHY DOES IT ONLY REFRESH AFTER I ADD ITEM TO CHANGELIST AGAIN?
    //TODO: IMPORTANT => MAKE TEST BUTTON UP TO DATE WITH THE NEW IDI TOO
  }

  double getItemFontSize(SizingInformation sizingInformation) {
    if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
      return 42;
    } else if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
      return 84;
    } else {
      return 60;
    }
  }

  double getDescriptionFontSize(SizingInformation sizingInformation) {
    if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
      return 27;
    } else if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
      return 60;
    } else {
      return 35;
    }
  }

  double getDescriptionTextFontSize(SizingInformation sizingInformation) {
    if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
      return bigFontSize ? 22 : 14;
    } else if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
      return 40;
    } else {
      return 35;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFF2b2622)),
          title: Text(
            '',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${widget.itemName}',
                      style: defaultTextStyle.copyWith(
                          fontSize: getItemFontSize(sizingInformation),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Transform.scale(
                        scale: 1.4,
                        child: itemQualityImage(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 67),
                    child: Text(
                      'Description',
                      style: defaultTextStyle.copyWith(
                          fontSize: getDescriptionFontSize(sizingInformation),
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Center(
                      child: Text(
                        'Item index score = ${widget.itemScore}.\n'
                        '${description}', // create a function to give the right the description by comparing idi from small to big
                        textAlign: TextAlign.center,
                        style: defaultTextStyle.copyWith(
                            color: Colors.black87,
                            fontSize:
                                getDescriptionTextFontSize(sizingInformation),
                            height: 1.2,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                widget.isIDIScreen
                    ? MenuButton(
                        //TODO: add a remove version!!!
                        buttonText: 'Add To Change List',
                        goRoute: () {
                          //TODO: rewrite this  => Make changeList based on the changeList column of each table/test instead with the same process as the Test List
                          insertItemInDB(widget
                              .itemNumber); //TODO: Make this refreshes the item screen!!!!!!

                          refreshItemPerformanceList();

                          //TODO: change the index of each item everytime one item is deleted whether it smaller or bigger than timeDeleted(int)

                          // widget.itemPerformanceIndex.removeAt(widget.itemIndex);
                        },
                      )
                    : Container(), //TODO: add remove Item button/ function here
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MenuButton extends StatelessWidget {
  late String buttonText;
  late VoidCallback goRoute;
  MenuButton({required this.buttonText, required this.goRoute});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        return Padding(
          padding: EdgeInsets.only(
              left: 0,
              right: 0,
              top: sizingInformation.deviceScreenType == DeviceScreenType.mobile
                  ? 30
                  : 70,
              bottom:
                  sizingInformation.deviceScreenType == DeviceScreenType.mobile
                      ? 50
                      : 70),
          child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                elevation: MaterialStateProperty.all(10),
                backgroundColor: MaterialStateProperty.all(
                  Color(0xFF9792bd),
                ),
              ),
              onPressed: goRoute,
              child: Container(
                  width: 270,
                  child: Center(
                    child: Text(
                      buttonText,
                      style: defaultTextStyle.copyWith(fontSize: 25),
                    ),
                  ))),
        );
      }),
    );
  }
}
