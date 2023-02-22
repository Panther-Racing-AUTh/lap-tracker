import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

int _selected = 0;

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return (_selected == 0)
        ? GridView(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            children: windows,
          )
        : Container(child: windows.elementAt(_selected - 1));
  }

  Widget Section(int id, {required String text, required Color color}) =>
      GestureDetector(
        child: Container(
          child: Center(child: Text(text)),
          color: color,
        ),
        onTap: () {
          setState(() {
            (_selected == 0) ? _selected = id : _selected = 0;
          });
        },
      );

  late List<Widget> windows = [
    Section(text: 'Window 1', color: Colors.yellow, 1),
    Section(text: 'Window 2', color: Colors.blue, 2),
    Section(text: 'Window 3', color: Colors.green, 3),
    Section(text: 'Window 4', color: Colors.blue, 4),
    Section(text: 'Window 5', color: Colors.pink, 5),
    Section(text: 'Window 6', color: Colors.lightGreen, 6),
  ];
}
