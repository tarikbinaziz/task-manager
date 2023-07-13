// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/hive%20data%20store.dart';
import 'package:task_manager/task%20model.dart';

import 'consts/color.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController? _scrollController;
  bool _isVisible = true;
  // @override
  // void initState() {
  //   super.initState();
  //   controller = ScrollController();
  //   // controller!.addListener(() {
  //   //   setState(() {
  //   //     fabIsVisible =
  //   //         controller!.position.userScrollDirection == ScrollDirection.forward;
  //   //   });
  //   // }
  //   // );
  // }
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController!.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    } else if (_scrollController!.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:_isVisible? FloatingActionButton(
        backgroundColor: mainColor,
        elevation: 20,
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  cursorColor: Colors.black,
                  onSubmitted: (value) {
                    Navigator.pop(context);
                    DatePicker.showTimePicker(context,
                        showTitleActions: true,
                        showSecondsColumn: false, onConfirm: (date) {
                      var task = Task.create(name: value, createdAt: date);
                      HiveDataStore().addTask(task);
                      print("data is added");
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your task",
                    contentPadding: EdgeInsets.only(left: 16),
                  ),
                  autofocus: true,
                ),
              );
            },
          );
        },
        child:Icon(Icons.add),
      ):null,
      appBar: AppBar(
        title: Text(
          "Whats's up for today?",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ValueListenableBuilder<Box<Task>>(
        builder: (context, box, widget) {
          var data = HiveDataStore().box.values.toList();
          data.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

          if (data.isEmpty) {
            return Center(
              child: Lottie.asset("assets/lottie/animation_lk0o99qw.json",
                  width: MediaQuery.sizeOf(context).width / 1.2),
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                // User started scrolling
                setState(() {
                  _isVisible = false;
                });
              } else if (scrollNotification is ScrollEndNotification) {
                // User stopped scrolling
                setState(() {
                  _isVisible = true;
                });
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    var datas = data[index];
                    return Dismissible(
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('This task was deleted',
                              style: TextStyle(
                                color: Colors.grey,
                              ))
                        ],
                      ),
                      onDismissed: (direction) {
                        HiveDataStore().deleteTask(datas);
                      },
                      key: Key(datas.id!),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(datas.name.toString()),
                          trailing: Text(
                            DateFormat('hh:mm a').format(datas.createdAt!),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
        valueListenable: HiveDataStore().valueListenable(),
      ),
    );
  }
}
