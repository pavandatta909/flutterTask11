import 'dart:io';
import 'package:task1/details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "taskDetails";
final String Column_id = "id";
final String Column_first_name = "first_name";
final String Column_last_name = "last_name";
final String Column_email = "email";
final String Column_gender = "gender";

class TaskModel {
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  int id;

  TaskModel(
      {required this.first_name,
      required this.id,
      required this.last_name,
      required this.email,
      required this.gender});

  Map<String, dynamic> fromMap() {
    return {
      Column_first_name: this.first_name,
      Column_last_name: this.last_name,
      Column_email: this.email,
      Column_gender: this.gender,
    };
  }
}

class TodoHelper {
  late Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    print("db location: " + dataDirectory.path);
    db = await openDatabase(join(await getDatabasesPath(), "databasetask.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_first_name TEXT, $Column_last_name TEXT, $Column_email TEXT, $Column_gender TEXT)");
    }, version: 1);
    print("table created successfully");
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      int result = 0;
      // for (var task in tableName) {
      //   result = await db.insert(tableName, task.toMap());
      // }
      db.insert(tableName, task.fromMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // db.rawInsert(
      //     'INSERT INTO my_table(id, first_name, last_name, email, gender) VALUES(?, ?, ?, ?, ?)',
      //     [
      //       Column_id,
      //       Column_first_name,
      //       Column_last_name,
      //       Column_email,
      //       Column_gender
      //     ]);
      print("data inserted successfully");
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    return List.generate(tasks.length, (i) {
      return TaskModel(
          first_name: tasks[i][Column_first_name],
          id: tasks[i][Column_id],
          last_name: tasks[i][Column_last_name],
          email: tasks[i][Column_email],
          gender: tasks[i][Column_gender]);
    });
  }
}


// class Details {
//   final int id;
//   final String first_name;
//   final String last_name;
//   final String email;
//   final String gender;

//   Details(
//       {required this.id,
//       required this.first_name,
//       required this.last_name,
//       required this.email,
//       required this.gender});

//   Details.fromMap(Map<String, dynamic> res)
//       : id = res["id"],
//         first_name = res["first_name"],
//         last_name = res["last_name"],
//         email = res["email"],
//         gender = res["gender"];

//   Map<String, Object?> toMap() {
//     return {
//       'id': id,
//       'first_name': first_name,
//       'last_name': last_name,
//       'email': email,
//       'gender': gender
//     };
//   }
// }


