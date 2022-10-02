import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:item_performance/Model/test_model.dart';
import 'package:intl/intl.dart';
import 'package:item_performance/Function/test_processing.dart';
import 'package:item_performance/Data/load_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  late String
      table; //make it so that we don't have to use the table from here, create a place to store individual test name/ table

  String columnId = '_id';
  String columnTestDate = 'testDate';
  String columnItemIDI = 'IDI';
  String columnChangeList = 'changelist';
  List<int> changeListItemNumbers = [];
  List changeItem = [];

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void getTestTableName(String testName) {
    if (isNumeric(testName[0])) {
      testName =
          '_$testName'; //make sure that this is not numeric, so Sqflite will be able to name the table
    }
    table = testName;

    if (table.contains(" ")) {
      table = processTableName(
          table); //Sqflite can't take String with a space as a table's name, so we need to process it

    }
    // log('TABLE IS $table');
  }

  // only have a single app-wide reference to the database
  //there is only one object representing this class no matter how many variable that you set to it
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<bool> checkIfTableExist() async {
    Database db = await instance.database;
    late int? count;
    try {
      count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $table'));
      log('count is $count');
    } catch (e) {
      log('count is not tried $count');
    }

    if (count != null) {
      return false;
    } else {
      return true;
    }
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();

      var databaseFactory = databaseFactoryFfi;
      var filedirectory = Directory.current.path;
      // Directory documentsDirectory = await getApplicationDocumentsDirectory();
      // var documentsDirectory = await getDatabasePath();
      String path = join(filedirectory, _databaseName);
      Database db = await databaseFactory.openDatabase(path);
      // var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      if (await db.query('sqlite_master',
              where: 'name = ?', whereArgs: ['table']) ==
          []) {
        _onCreate(db, _databaseVersion);
      }

      return db; //TODO: create pc ui next time
    } else {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      return await openDatabase(path, version: _databaseVersion);
    }
  }

  String processTableName(String table) {
    List splitString = table.split(" ");
    table = '';
    for (var i in splitString) {
      if (i != splitString[splitString.length - 1]) {
        table = table + i + '_';
      } else {
        table = table + i;
      }
    }
    return table;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table( 
            $columnId INTEGER PRIMARY KEY,
            $columnTestDate TEXT NOT NULL,
            $columnItemIDI REAL NOT NULL,
            $columnChangeList REAL 
          )
          '''); //check if the table already existed, if it doesn't exist => create a new one
  }

  Future create() async {
    Database db = await instance.database;
    await _onCreate(db,
        _databaseVersion); //check if the table already existed, if it doesn't exist => create a new one
  }

  // Helper methods
  Future<List> createTestList() async {
    Database db = await instance.database;
    var tableNames = (await db
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name']
            as String) // what type of value/element to become a list
        .toList(
            growable: true); // to list create a list with that value/element
    tableNames.remove('android_metadata');
    return tableNames;
  }

  Future<bool> checkIfTableExisted(String rawTestName) async {
    List tableNames = await createTestList();
    String testName = processTableName(rawTestName);
    for (var i in tableNames) {
      print(i);
      print(testName);
      if (i == testName) {
        print(i);
        return true;
      }
    }
    print(tableNames);
    return false;
  }

  DateTime? toDateTime(String date) {
    late DateTime? dateFinished;

    List<String> dateSplit = (date.split(" "));
    List dateTest = (dateSplit[0]).split("-");
    // print('dateTest is $dateTest');
    String processedTestDate = '${dateTest[2]}/${dateTest[1]}/${dateTest[0]}';
    // print(' ${processedTestDate}');
    dateFinished = DateFormat('d/M/y').parse(processedTestDate);
    return dateFinished;
  }

  Future<List<Test>> getTestsList() async {
    Database db = await instance.database;
    ProcessingTest processTest = ProcessingTest.instance;
    List<Test> testList = [];
    List changeList = [];
    for (var i in await createTestList()) {
      //i.replaceAll('_', ' ') replace _ with a space
      // try {
      DateTime? testDate = toDateTime((await db.query(i,
          columns: [columnTestDate],
          where: '$columnId = ?',
          whereArgs: [1]))[0][columnTestDate] as String);
      testList.add(processTest.processTest(
          i, testDate, await getIDIList(i), await getChangeList(i)));
      print('table is $i');
      // } catch (e) {
      //   dev.log('The error is ${e}');
      // }
    }
    // dev.log('TESTSLIST IS $testList');
    return testList;
  }

  Future<List<double>> getChangeList(String testName) async {
    Database db = await instance.database;
    List<double> changeList = [];
    // (await db
    //     .query(testName, where: 'type = ?', whereArgs: ['table']))
    //     .map((row) => row['name']
    // as String) // what type of value/element to become a list
    //     .toList(
    //     growable: true)
    List changes = await db.query(
      testName,
      columns: [columnChangeList],
    ); //[0][columnItemIDI]
    if (changes[0][columnChangeList] != null) {
      print('changes is $changes');
      for (var i in changes) {
        if (i[columnChangeList] != null) {
          changeList.add(i[columnChangeList] as double);
        }
      }
    } else {
      return [];
    }
    // print('idiList is $testsidiList');
    return changeList;
  }

  Future<List<double>> getIDIList(String testName) async {
    Database db = await instance.database;
    List<double> testsidiList = [];
    // (await db
    //     .query(testName, where: 'type = ?', whereArgs: ['table']))
    //     .map((row) => row['name']
    // as String) // what type of value/element to become a list
    //     .toList(
    //     growable: true)
    var IDI = await db.query(
      testName,
      columns: [columnItemIDI],
    ); //[0][columnItemIDI]
    for (var i in IDI) {
      testsidiList.add(i[columnItemIDI] as double);
    }
    // print('idiList is $testsidiList');
    return testsidiList;
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, int numberOfItem) async {
    Database db = await instance.database; // name/get/call the database db

    // return db.rawInsert(
    //     'INSERT INTO $table(${columnTestDate}, ${columnItemIDI}) VALUES(?, ?) WHERE $columnId <= $numberOfItem',
    //     [row[columnTestDate], row[columnItemIDI]]);

    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId]; //set columnID in row when using the function

    await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
    return id;
  }

  int getChangeListNumber(int index) {
    return changeListItemNumbers[index];
  }

  void addToCLNumber(int changeListNumber) {
    changeListItemNumbers.add(changeListNumber);
    print('CHANGELIST ITEM NUMBER IS $changeListItemNumbers');
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<double> getSpecificIDI(int id) async {
    Database db = await instance.database;
    print('database');
    double IDI = (await db.query(table,
        columns: [columnItemIDI],
        where: '$columnId = ?',
        whereArgs: [id]))[0][columnItemIDI] as double; //[0][columnItemIDI]
    return IDI;
  }

  int get getChangeListLength {
    return changeItem.length;
  }

  void resetList() {
    changeItem = [];
  }

  Future<void> recognisedInCList(context) async {
    Database db = await instance.database;
    List all = await queryAllRows();
    print('all is $all');
    int i = 0;
    print('changeItem is ${changeItem}');
    print(
        'isEmpty is ${Provider.of<LoadData>(context, listen: false).changeListIsEmpty()}');
    print(
        'itemChangeList is ${Provider.of<LoadData>(context, listen: false).getChangeList}');
    bool isEmptyChangeList =
        Provider.of<LoadData>(context, listen: false).changeListIsEmpty();
    // if (changeItem.length !=
    //     Provider.of<LoadData>(context, listen: true).getChangeListIndex) {
    if (isEmptyChangeList == true) {
      print('true true');
      for (var a in all) {
        if (a['IDI'] == 0.00000001) {
          print('a[idi] is $a');
          changeItem.add(a);
        }
      }
    }

    print('changeItem is $changeItem');
  }
}
