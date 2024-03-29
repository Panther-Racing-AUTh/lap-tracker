import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';
import 'package:provider/provider.dart';

import '../supabase/proposal_functions.dart';

class Overview extends StatefulWidget {
  Overview(double this.width);
  double width;
  @override
  State<Overview> createState() => _OverviewState();
}

//index to determine what to render on screen:
//0: show all 6 windows
//1: show powertrain window
//2: show electronics window
//3: show aerodynamics window
//4: show intake & exhaust window
//5: show suspension window
//6: show hands-on team

int _selected = 0;

class _OverviewState extends State<Overview> {
  late final _stream;
  void manageState() {
    setState(() {});
  }

  @override
  void initState() {
    _stream = getProposals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<Map<String, Proposal>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final proposals = snapshot.data!;
            //all six windows of each department initialization with custm widget
            late List<Widget> windows = [
              Section(
                title: 'Powertrain',
                color: Color.fromARGB(255, 247, 224, 158),
                proposal: proposals['powertrain'],
                1,
                manageState,
              ),
              Section(
                title: 'Electronics',
                color: Colors.orange,
                proposal: proposals['electronics'],
                2,
                manageState,
              ),
              Section(
                title: 'Aerodynamics',
                color: Colors.green,
                proposal: proposals['aerodynamics'],
                3,
                manageState,
              ),
              Section(
                title: 'Intake & Exhaust',
                color: Colors.red,
                proposal: proposals['intake_exhaust'],
                4,
                manageState,
              ),
              Section(
                title: 'Suspension',
                color: Colors.yellow,
                proposal: proposals['suspension'],
                5,
                manageState,
              ),
              Section(
                title: 'Hands-On Team',
                color: Colors.blue,
                proposal: proposals['hands_on'],
                6,
                manageState,
              ),
            ];

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
                                  padding: EdgeInsets.all(15),
                                  child: windows[0],
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight / 2,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: windows[1],
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight / 2,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: windows[2],
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight / 2,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: windows[3],
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight / 2,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: windows[4],
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight / 2,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
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
          return Center(child: CircularProgressIndicator());
        });
  }
}

//custom widget for each department
class Section extends StatefulWidget {
  const Section(
    int this.id,
    Function this.notifyParent, {
    required String this.title,
    required Color this.color,
    required Proposal? this.proposal,
  });
  final title;
  final id;
  final color;
  final notifyParent;
  final Proposal? proposal;
  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    //checks if window is that of the hands team
    bool hands = widget.id == 6;
    AppSetup setup = Provider.of<AppSetup>(context);
    // print(widget.title);
    // print(widget.id);
    // print(widget.color);
    // print(widget.notifyParent);

    // print('------------------------------------------');
    return GestureDetector(
      child: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:
                            //proposal state
                            Text(
                          (widget.proposal == null)
                              ? (hands)
                                  ? 'Waiting for response'
                                  : 'Waiting for proposal'
                              : widget.proposal!.state!.state,
                          style: TextStyle(
                            fontSize: 30,
                            color: (widget.proposal == null)
                                ? Theme.of(context).selectedRowColor
                                : (widget.proposal!.state!.state == 'APPROVED')
                                    ? Colors.green
                                    : (widget.proposal!.state!.state == 'NEW')
                                        ? Colors.blue
                                        : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //buttons for approval and rejection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.proposal != null && !hands)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: Text('APPROVE',
                                  style: TextStyle(fontSize: 35)),
                              onPressed: (widget.proposal!.state == 'DONE')
                                  ? null
                                  : () {
                                      print('1');
                                      changeProposalState(
                                        newState: ProposalState(
                                          proposalId:
                                              widget.proposal!.proposalId!,
                                          changedByUserId: setup.supabase_id,
                                          state: 'APPROVED',
                                        ),
                                      );
                                    },
                            ),
                          if (widget.proposal != null && !hands)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text('REJECT',
                                  style: TextStyle(fontSize: 35)),
                              onPressed: (widget.proposal!.state == 'DONE')
                                  ? null
                                  : () {
                                      print('1');

                                      changeProposalState(
                                        newState: ProposalState(
                                          proposalId:
                                              widget.proposal!.proposalId!,
                                          changedByUserId: setup.supabase_id,
                                          state: 'DECLINED',
                                        ),
                                      );
                                    },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).selectedRowColor),
                  ),
                ),
                //show message if no proposal is made
                if (widget.proposal == null)
                  Text((hands) ? 'No Response yet' : 'No proposal yet'),
                //else show proposal
                if (widget.proposal != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (hands) ? 'Checks Completed' : 'Change Proposal',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).selectedRowColor),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Center(
                                child:
                                    //show part of title if title is too big, show everything when zoomed in
                                    Text(
                                  (widget.proposal!.title.length < 35 ||
                                          _selected == widget.id)
                                      ? widget.proposal!.title
                                      : widget.proposal!.title
                                          .replaceRange(30, null, '...'),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color:
                                          Theme.of(context).selectedRowColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selected == widget.id && !hands)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //proposal description
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).selectedRowColor),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    (widget.proposal!.description),
                                    style: TextStyle(
                                        fontSize: 30,
                                        color:
                                            Theme.of(context).selectedRowColor),
                                  ),
                                ],
                              ),
                            ),
                            //show proposal part name
                            Text(
                              widget.proposal!.partName,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context).selectedRowColor),
                            ),
                            //show proposal part current value
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.proposal!.partValueFrom,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).selectedRowColor),
                                ),
                                Text(
                                  '  -->  ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).selectedRowColor),
                                ),
                                //show proposal part suggested value
                                Text(
                                  widget.proposal!.partValueTo,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).selectedRowColor),
                                ),
                              ],
                            ),
                            //customText(widget.proposal!.)
                          ],
                        ),
                      //show reason
                      if (!hands)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Reason',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).selectedRowColor),
                              ),
                              SizedBox(height: 5),
                              Text(
                                (widget.proposal!.reason.length < 35 ||
                                        _selected == widget.id)
                                    ? widget.proposal!.reason
                                    : widget.proposal!.reason
                                        .replaceRange(35, null, '...'),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).selectedRowColor),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        decoration:
            BoxDecoration(border: Border.all(width: 15, color: widget.color)),
      ),
      onTap: () {
        //zoom in or out if window is tapped
        (_selected == 0) ? _selected = widget.id : _selected = 0;
        widget.notifyParent();
      },
    );
  }
}
