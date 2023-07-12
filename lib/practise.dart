import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HivePractise extends StatefulWidget {
  const HivePractise({super.key});

  @override
  State<HivePractise> createState() => _HivePractiseState();
}

class _HivePractiseState extends State<HivePractise> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var box = await Hive.openBox("data");
                  box.put("1", "tarik");
                  print("added in data");
                },
                child: Text("add")),
            ElevatedButton(
                onPressed: () async {
                  var box = Hive.box("data");
                  var data = box.get("1");
                  print(data);
                },
                child: Text("get")),
            ElevatedButton(
                onPressed: () {
                  var box = Hive.box("data");
                  box.put("1", "nobody");
                  print("updated successfully");
                },
                child: Text("update")),
            ElevatedButton(
                onPressed: () {
                  var box = Hive.box("data");
                  box.delete("1");
                },
                child: Text("delete")),
            ValueListenableBuilder<Box>(
                builder: (context,box, snapshot) {
              return Text(box.values.toString());
            }, valueListenable: Hive.box("data").listenable(),)
          ],
        ),
      ),
    );
  }
}
