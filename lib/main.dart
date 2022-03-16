import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';

import 'utils/model.dart';
import 'package:task1/details.dart';
import 'package:task1/utils/model.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();

  List<TaskModel> tasks = [];

  late TaskModel currentTask;
  @override
  Widget build(BuildContext context) {
    final TodoHelper _todoHelper = TodoHelper();
    return Scaffold(
        appBar: AppBar(
          title: Text("TASK 1"),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () async {
                setState(() {});
                currentTask = TaskModel(
                  id: hashCode,
                  first_name: textController.text,
                  last_name: textController.text,
                  email: textController.text,
                  gender: textController.text,
                );
                _todoHelper.insertTask(currentTask);
                List<TaskModel> list = await _todoHelper.getAllTask();
                setState(() {
                  tasks = list;
                });
              },
              child: Text("Upload"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: ReadJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text("${data.error}"));
              } else if (data.hasData) {
                var items = data.data as List<DetailsList>;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 120.0,
                      height: 180.0,
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2, right: 2),
                                child: Text(
                                    '${items[index].first_name} ${items[index].last_name}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3, right: 2),
                                child: Text(
                                  items[index].email.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2, right: 8),
                                child: Text(
                                  items[index].gender.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  List<dynamic> details = [];

  Future<List<DetailsList>> ReadJsonData() async {
    final jsondata = await rootBundle.loadString('lib/assets/task1.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => DetailsList.fromJson(e)).toList();
  }
}
