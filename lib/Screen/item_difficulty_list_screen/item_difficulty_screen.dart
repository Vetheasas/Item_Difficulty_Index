import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:item_performance/Screen/change_screen.dart';
import 'package:item_performance/constant.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'package:item_performance/Function/item_processing.dart';
import 'package:item_performance/Model/item_model.dart';

import 'package:provider/provider.dart';
import 'package:item_performance/Data/list_data.dart';
import 'package:item_performance/Data/load_data.dart';
import 'package:item_performance/DataBase/database_helper.dart';
import 'dart:io' show Platform;

class ItemDifficultyScreen extends StatefulWidget {
  late String testName;
  ItemDifficultyScreen({required this.testName});
  @override
  State<ItemDifficultyScreen> createState() => _ItemDifficultyScreenState();
}

ProcessingItem process = ProcessingItem();
bool isProcessed = false;

class _ItemDifficultyScreenState extends State<ItemDifficultyScreen> {
  List<Widget> itemPerformance = [];
  void loadData() async {
    DatabaseHelper.instance.getTestTableName(widget
        .testName); //set the correct test name so that changeList can query the correct data
    await DatabaseHelper.instance.recognisedInCList(context);
    print('done reg');
    Provider.of<LoadData>(context, listen: false)
        .loadData(widget.testName, false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<Item> itemList = [];
  List<double> newIDIList = [];
  void refreshItemPerformanceList() async {
    newIDIList = await DatabaseHelper.instance.getIDIList(
        Provider.of<ListData>(context, listen: false)
            .getTestName()); // get new idiList
    itemList = process.process(newIDIList,
        Provider.of<ListData>(context, listen: false).getTestName());
    Provider.of<ListData>(context, listen: false).resetList();
    Provider.of<ListData>(context, listen: false).createItemsList(
        itemList, //TODO: test removing item => see if it actually refreshes immediately
        false); //TODO: test out changelist from multiple test_x
    // Navigator.of(context).pop(true);
  }

//TODO: Make 2 different appbar for both windows and isAndroid!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          height: Platform.isAndroid ? 80 : 56,
          decoration: BoxDecoration(color: Color(0xFF7070a0)),
          child: Padding(
            padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButton(
                  color: Color(0xFF2c2724),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                Padding(
                  padding: Platform.isAndroid
                      ? const EdgeInsets.only(left: 5, top: 2, right: 12)
                      : const EdgeInsets.only(left: 33, top: 2, right: 0),
                  child: Text(
                    'IDI',
                    style: defaultTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Platform.isAndroid ? 15 : 23),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 64,
                    child: Padding(
                      padding: Platform.isAndroid
                          ? EdgeInsets.only(
                              top: 2,
                              left: MediaQuery.of(context).size.width - 230,
                              bottom: 6)
                          : EdgeInsets.only(
                              top: 2,
                              left: MediaQuery.of(context).size.width - 270,
                              bottom: 6),
                      child: Row(
                        children: [
                          Text(
                            'Change List',
                            style: defaultTextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: Platform.isAndroid ? 15 : 20),
                          ),
                          Transform.scale(
                            scaleX: -1, //flip BackButton
                            child: IconButton(
                              color: Color(0xFF2c2724),
                              icon: Icon(Icons.arrow_back),
                              tooltip: 'Change List',
                              onPressed: () {
                                Provider.of<LoadData>(context, listen: false)
                                    .resetList();
                                DatabaseHelper.instance.resetList();
                                loadData();
                                print(
                                    'ChangeList is${Provider.of<LoadData>(context, listen: false).getChangeList}');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChangeScreen()));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        // return with isAndroid back button == true (not the back button on the appbar )
        onWillPop: () async {
          Navigator.pop(context, true);
          return true;
        },
        child: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: Color(0xFF46486c)),
            child: ScreenTypeLayout(
              mobile: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        Provider.of<ListData>(context, listen: true).getIDIList,
                  )),
              tablet: GridView.count(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                crossAxisCount: 3,
                children:
                    Provider.of<ListData>(context, listen: true).getIDIList,
              ),
              desktop: GridView.count(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                crossAxisCount: 4,
                children:
                    Provider.of<ListData>(context, listen: true).getIDIList,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
