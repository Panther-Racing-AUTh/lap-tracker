import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HandsOnScreen extends StatefulWidget {
  const HandsOnScreen({super.key});

  @override
  State<HandsOnScreen> createState() => _HandsOnScreenState();
}

List<bool> checks = [];

class _HandsOnScreenState extends State<HandsOnScreen> {
  void checked() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(tasks[0]);
    for (int i = 0; i < tasks.length; i++) {
      checks.add(false);
    }
    return ListView.builder(
        itemCount: 4,
        itemBuilder: ((context, index) {
          return customListTile(
              id: index + 1, task: tasks[index], completed: checked);
        }));
  }
}

Widget customListTile(
        {required int id, required String task, required Function completed}) =>
    ListTile(
      tileColor: checks[id - 1] ? Colors.green : Colors.white,
      leading: Text(id.toString()),
      title: Text(task),
      trailing: ElevatedButton(
          onPressed: () {
            checks[id - 1] = true;
            completed();
          },
          child: Text('DONE')),
    );

List tasks = [
  'Check any visual damage.',
  'Check tires pressure.',
  'Check all temperatures.',
  'Check for dirt.',
];
