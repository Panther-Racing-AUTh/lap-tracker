import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/widgets/echarts_widget.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';
import 'package:provider/provider.dart';

import '../supabase/proposal_functions.dart';

class Overview extends StatefulWidget {
  Overview(double this.width);
  double width;
  @override
  State<Overview> createState() => _OverviewState();
}

int _selected = 0;

class _OverviewState extends State<Overview> {
  final _stream = getProposals();
  void manageState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<Map<String, Proposal>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final proposals = snapshot.data!;
            print(proposals['electronics']!.state!.state);
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
                        child: Text(
                          (widget.proposal == null)
                              ? 'Waiting for proposal'
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.proposal != null)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: Text('APPROVE',
                                  style: TextStyle(fontSize: 35)),
                              onPressed: () {
                                changeProposalState(
                                  newState: ProposalState(
                                    id: widget.proposal!.state!.id,
                                    proposalId: widget.proposal!.id!,
                                    changedByUserId: setup.supabase_id,
                                    state: 'APPROVED',
                                  ),
                                );
                              },
                            ),
                          if (widget.proposal != null)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text('REJECT',
                                  style: TextStyle(fontSize: 35)),
                              onPressed: () {
                                changeProposalState(
                                  newState: ProposalState(
                                    id: widget.proposal!.state!.id,
                                    proposalId: widget.proposal!.id!,
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
                if (widget.proposal == null) Text('No proposal yet'),
                if (widget.proposal != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Change Proposal',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).selectedRowColor),
                            ),
                            SizedBox(height: 5),
                            Text(
                              (widget.proposal!.title.length < 35 ||
                                      _selected == widget.id)
                                  ? widget.proposal!.title
                                  : widget.proposal!.title
                                      .replaceRange(35, null, '...'),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).selectedRowColor),
                            ),
                          ],
                        ),
                      ),
                      if (_selected == widget.id)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                            Text(
                              widget.proposal!.partName,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context).selectedRowColor),
                            ),
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
        (_selected == 0) ? _selected = widget.id : _selected = 0;
        widget.notifyParent();
      },
    );
  }
}
