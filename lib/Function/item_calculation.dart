import 'dart:developer' as dev;

import 'dart:math';

class Calculation {
  double calculateItemDifficultyIndex(List gradedStudentList,
      int totalResponseNumber, int individualItemNumber) {
    //Need to use getGradedStudentList to process the rawCSVData to gradedStudentList

    dev.log('gradedStudentL is $gradedStudentList');

    int allPortion = 0;
    for (var score in gradedStudentList) {
      allPortion = score[individualItemNumber] + allPortion;
    }

    double difficultyIndex = allPortion / gradedStudentList.length;

    return double.parse(difficultyIndex
        .toStringAsFixed(2)); //return a double with 2 decimal points
  }

  List getGradedStudentList(List rawDataList, int maxScore, int numberOfItem) {
    List fullScore = [];
    List? sortedList = [];

    for (var i in rawDataList) {
      if (i.contains('/ $maxScore')) {
        print('a');
        fullScore.add(double.parse((i.split(' / '))[
            0])); // i(string).split creates a List<String> which has both of the splitted elements

      }
    }
    print(fullScore);
    sortedList = (quicksort(fullScore));
    dev.log('$sortedList');

    List studentGradedList = [];
    int n = 0;
    while (n < sortedList!.length) {
      studentGradedList.add([]);
      n++;
    }
    n = 0;
    int index = 0;
    int studentMaxScoreN = 0;
    while (studentMaxScoreN < studentGradedList.length) {
      try {
        while (index < rawDataList.length) {
          // print('${sortedList[studentMaxScoreN]}0 / $maxScore');

          // print('${a[index]}');
          // print('${sortedList[studentMaxScoreN]}0 / $maxScore');
          if (studentMaxScoreN != sortedList.length) {
            // print('student is $studentMaxScoreN');
            if (rawDataList[index] ==
                ('${sortedList[studentMaxScoreN]}0 / $maxScore')) {
              // print(numberOfItem);
              int it = 1;
              int i = 0;
              while (i < numberOfItem) {
                // print(a[index+it]);
                if (rawDataList[index + it].contains('.00')) {
                  if (rawDataList[index + it].contains('0.00')) {
                    studentGradedList[n + studentMaxScoreN].add(0);

                    i++;
                  } else {
                    studentGradedList[n + studentMaxScoreN].add(1);
                    i++;
                  }
                }
                it++;
              }
              studentMaxScoreN++;
            }
          }

          index++;
          // print('a.length is ${a.length}');
          // print('$index');
          if (studentMaxScoreN < sortedList.length) {
            if (index == rawDataList.length) {
              index = 0;
            }
          }
        }
      } catch (e) {
        print(e);
      }

      n++;

      // if(studentMaxScoreN<studentGradedList.length-1){
      //   n++;
      // }
    }

    return studentGradedList;
  }

  List? quicksort(List list) {
    if (list.length != 0) {
      int pivotLocation = (list.length - 1) ~/ 2;
      double pivot = list[pivotLocation];

      List? sortedList = [];
      List? smaller = [];
      List? bigger = [];
      int? tries = 0;

      if ((list.length > 1) && (list[0] != null)) {
        int index = 0;

        for (double i in list) {
          if ((i > pivot) && (i != pivot)) {
            smaller.add(i);
          } else if ((i < pivot) && (i != pivot)) {
            bigger.add(i);
          } else if ((i == pivot) && (index != pivotLocation)) {
            sortedList.add(i);
          }
          index++;
        }

        smaller = quicksort(smaller);
        bigger = quicksort(bigger);
      }

      sortedList.add(pivot);

      sortedList = smaller! + sortedList + bigger!;

      return sortedList;
    } else {
      print('returned []');
      return [];
    }
  }
}
