import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

int _selected = 0;

class _OverviewState extends State<Overview> {
  void manageState() {
    setState(() {});
  }

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

  late List<Widget> windows = [
    Section(text: 'Window 1', color: Colors.yellow, 1, manageState),
    Section(text: 'Window 2', color: Colors.blue, 2, manageState),
    Section(text: 'Window 3', color: Colors.green, 3, manageState),
    Section(text: 'Window 4', color: Colors.blue, 4, manageState),
    Section(text: 'Window 5', color: Colors.pink, 5, manageState),
    Section(text: 'Window 6', color: Colors.lightGreen, 6, manageState),
  ];
}

class Section extends StatefulWidget {
  const Section(int this.id, Function this.notifyParent,
      {required String this.text, required Color this.color});
  final text;
  final id;
  final color;
  final notifyParent;

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text),
            if (_selected == widget.id)
              GestureDetector(
                onTap: (() => setState(() {
                      count++;
                    })),
                child: Text(count.toString()),
              )
          ],
        )),
        color: widget.color,
      ),
      onTap: () {
        (_selected == 0) ? _selected = widget.id : _selected = 0;
        widget.notifyParent();
      },
    );
  }
}
