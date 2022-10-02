import 'package:item_performance/Model/test_model.dart';
import 'item_processing.dart';
import 'dart:developer';

class ProcessingTest {
  ProcessingTest._PrivateConstructor();
  static final instance = ProcessingTest._PrivateConstructor();
  Test processTest(String testName, DateTime? testDate,
      List itemPerformanceIndexList, List? changeList) {
    log('testName is $testName');
    int testQ = testQuality(itemPerformanceIndexList);

    Test test = Test(
        testName: testName,
        testDate: testDate,
        itemIndexDifficultyList: itemPerformanceIndexList,
        testQuality: testQ,
        changeList: changeList);

    return test;
  }

  int quality(List IDIList) {
    double badPoint = 0;
    for (double i in IDIList) {
      if (i != 0.00000001) {
        if (i <= 0.20) {
          badPoint++;
        } else if (i < 0.30) {
          //TODO: determine the quality based on the number percentages of too hard + too easy to the total item ratio instead
          badPoint = badPoint + 0.5;
        } else if (i < 0.85) {
          badPoint = badPoint + 0.5;
        } else if (i >= 0.85) {
          badPoint++;
        }
      }
    }
    double q = badPoint / IDIList.length;
    print(q);
    if (q < 0.65) {
      return 2;
    } else if (q < 0.75) {
      return 1;
    } else if (q <= 1) {
      return 0;
    }
    return 1;
  }

  int getTestQuality(double bq, double qq, double gq) {
    //TODO: Next time, maybe  determine the quality based on the degree of how hard or easy the items are rather than just 3 quality

    //TODO: automatically add questionable/ unacceptable to changelist????

    //TODO: create a menu with 2 buttons between testlist and idi (IDI List button, changelist button)
    log('getTestQuality');
    log('bq is $bq');
    log('qq is $qq');
    log('gq is $gq');
    if (bq >= gq) {
      return 0;
    } else if (qq >= gq) {
      return 2;
    } else if ((bq + qq) >= gq) {
      if (qq > bq) {
        return 2;
      } else {
        return 0;
      }
    } else {
      return 1;
    }
  }

  int testQuality(List itemPerformanceIndexList) {
    double badPoint = 0;
    double questionablePoint = 0;
    double goodPoint = 0;
    int removedItem = 0;
    for (double i in itemPerformanceIndexList) {
      if (i != 0.00000001) {
        log('i is $i');
        if (i <= 0.20) {
          badPoint++;
        } else if (i < 0.30) {
          //TODO: determine the quality based on the number percentages of too hard + too easy to the total item ratio instead
          questionablePoint++;
        } else if (i < 0.7) {
          goodPoint++;
        } else if (i < 0.85) {
          questionablePoint++;
        } else if (i >= 0.85) {
          badPoint++;
        }
      } else {
        removedItem++;
      }
    }
    log('badpoint is $badPoint');
    double bq = badPoint / (itemPerformanceIndexList.length - removedItem);

    double qq =
        questionablePoint / (itemPerformanceIndexList.length - removedItem);
    double gq = goodPoint / (itemPerformanceIndexList.length - removedItem);
    print('q is $bq');

    return getTestQuality(bq, qq, gq);
  }
}
