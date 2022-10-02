import 'package:item_performance/Model/item_model.dart';
import 'package:item_performance/constant.dart';

class ProcessingItem {
  List<Item> process(List itemDifficultyIndexList, String testName) {
    //Process  itemDifficultyIndexList to itemlist for the item_performance_screen
    int i = 0;
    List<Item> list = [];
    print('process list is $itemDifficultyIndexList');
    while (i < itemDifficultyIndexList.length) {
      print('here');
      print(itemDifficultyIndexList[i]);
      if (itemDifficultyIndexList[i] == 0.00000001) {
        print('Skip');
        i++;
      } else if (itemDifficultyIndexList[i] < 0.2) {
        list.add(Item(
            keep: 0,
            itemNumber: i + 1,
            itemScore: itemDifficultyIndexList[i],
            testName: testName));
        i++;
      } else if (itemDifficultyIndexList[i] < 0.3) {
        list.add(Item(
            keep: 2,
            itemNumber: i + 1,
            itemScore: itemDifficultyIndexList[i],
            testName: testName));
        i++;
      } else if (itemDifficultyIndexList[i] < 0.7) {
        list.add(Item(
            keep: 1,
            itemNumber: i + 1,
            itemScore: itemDifficultyIndexList[i],
            testName: testName));
        i++;
      } else if (itemDifficultyIndexList[i] < 0.85) {
        list.add(Item(
            keep: 2,
            itemNumber: i + 1,
            itemScore: itemDifficultyIndexList[i],
            testName: testName));
        i++;
      } else if (itemDifficultyIndexList[i] >= 0.85) {
        list.add(Item(
            keep: 0,
            itemNumber: i + 1,
            itemScore: itemDifficultyIndexList[i],
            testName: testName));
        i++;
      }
    }
    print(itemDifficultyIndexList);
    print(list);
    return list;
  }

  bool isGood(double itemDifficultyIndex, Item item) {
    bool isGood = true;

    if (item.itemScore < 0.3) {
      isGood = false;
    } else if (item.itemScore < 0.70) {
      isGood = true;
    } else if (item.itemScore < 0.8) {
      isGood = false;
    }
    print(isGood);
    return isGood;
  }

  int itemQuality(double IDI) {
    int itemQ = 0;

    if (IDI <= 0.20) {
      itemQ = 0;
    } else if (IDI < 0.30) {
      itemQ = 2;
    } else if (IDI < 0.70) {
      itemQ = 1; //
    } else if (IDI < 0.85) {
      itemQ = 2;
    } else if (IDI >= 0.85) {
      itemQ = 0;
    }
    // log('Quality of the test is $quality');
    // > 1 = error

    return itemQ;
  }

  String getDescription(double itemDifficultyIndex) {
    String description = '';

    if (itemDifficultyIndex <= 0.20) {
      description = aboutIDIRating[0];
    } else if (itemDifficultyIndex < 0.3) {
      description = aboutIDIRating[1];
    } else if (itemDifficultyIndex < 0.70) {
      description = aboutIDIRating[2];
    } else if (itemDifficultyIndex < 0.85) {
      description = aboutIDIRating[3];
    } else if (itemDifficultyIndex >= 0.85) {
      description = aboutIDIRating[4];
    }
    return description;
  }
}
