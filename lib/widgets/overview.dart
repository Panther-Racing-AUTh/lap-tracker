import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/echarts_widget.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';

class Overview extends StatefulWidget {
  Overview(double this.width);
  double width;
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
    final screenHeight = MediaQuery.of(context).size.height;
    return (_selected == 0)
        ? Container(
            width: widget.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: windows[0],
                          width: constraints.maxWidth / 3,
                          height: constraints.maxHeight / 2,
                        ),
                        Container(
                          child: windows[1],
                          width: constraints.maxWidth / 3,
                          height: constraints.maxHeight / 2,
                        ),
                        Container(
                          child: windows[2],
                          width: constraints.maxWidth / 3,
                          height: constraints.maxHeight / 2,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: windows[3],
                          width: constraints.maxWidth / 3,
                          height: constraints.maxHeight / 2,
                        ),
                        Container(
                          child: windows[4],
                          width: constraints.maxWidth / 3,
                          height: constraints.maxHeight / 2,
                        ),
                        Container(
                          child: windows[5],
                          width: constraints.maxWidth / 3,
                          height: constraints.maxHeight / 2,
                        )
                      ],
                    )
                  ],
                );
              },
            ),
          )
        : Container(child: windows.elementAt(_selected - 1));
  }

  late List<Widget> windows = [
    Section(
      title: 'Powertrain',
      color: Color.fromARGB(255, 247, 224, 158),
      1,
      manageState,
    ),
    Section(
      title: 'Electronics',
      color: Colors.orange,
      2,
      manageState,
    ),
    Section(
      title: 'Aerodynamics',
      color: Colors.green,
      3,
      manageState,
    ),
    Section(
      title: 'Intake & Exhaust',
      color: Colors.red,
      4,
      manageState,
    ),
    Section(
      title: 'Suspension',
      color: Colors.yellow,
      5,
      manageState,
    ),
    Section(
      title: 'Hands-On Team',
      color: Colors.blue,
      6,
      manageState,
    ),
  ];
}

class Section extends StatefulWidget {
  const Section(
    int this.id,
    Function this.notifyParent, {
    required String this.title,
    required Color this.color,
    String this.changeProposal = 'This is a change proposal adsfdsfdsfdsf',
    String this.reason =
        'This is a reason given for the proposed change adsfdsfdsfdsf',
  });
  final title;
  final id;
  final color;
  final notifyParent;
  final changeProposal;
  final reason;
  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    print(widget.title);
    print(widget.id);
    print(widget.color);
    print(widget.notifyParent);
    print(widget.changeProposal);
    print(widget.reason);
    print('------------------------------------------');
    return GestureDetector(
      child: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(side: BorderSide(width: 4)),
                    child: customText(
                      'APPROVE ',
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: customText(
                      'STATE',
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: customText(
                widget.title,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText(
                    'Change Proposal',
                    size: 25,
                    bold: true,
                  ),
                  SizedBox(height: 5),
                  customText(
                    (widget.changeProposal.length < 35 ||
                            _selected == widget.id)
                        ? widget.changeProposal
                        : widget.changeProposal.replaceRange(35, null, '...'),
                    size: 30,
                  ),
                ],
              ),
            ),
            if (_selected == widget.id)
              Container(
                height: 1,
                width: 400,
                child: EchartsWidget(
                    finalList: [], isMessage: false, showDetails: false),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText(
                    'Reason',
                    size: 25,
                    bold: true,
                  ),
                  SizedBox(height: 5),
                  customText(
                    (widget.reason.length < 35 || _selected == widget.id)
                        ? widget.reason
                        : widget.reason.replaceRange(35, null, '...'),
                    size: 30,
                  ),
                ],
              ),
            ),
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

Stack customText(String text, {double size: 14, bold: false}) => Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.white,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            color: Colors.black,
          ),
        ),
      ],
    );
TextStyle style(double size, {bold: false}) => TextStyle(
      //backgroundColor: Colors.white,
      //color: Colors.white,
      fontSize: size,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = Colors.white,
    );
