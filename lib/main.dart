// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/practise.dart';
import 'package:task_manager/task%20model.dart';

import 'home view.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Task>(TaskAdapter());

  var box = await Hive.openBox<Task>("task");

  box.values.forEach((element) {
    if (element.createdAt!.day != DateTime.now().day) {
      box.delete(element.id);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black)),
      ),
      home:
      HomeView(),
    );
  }
}
