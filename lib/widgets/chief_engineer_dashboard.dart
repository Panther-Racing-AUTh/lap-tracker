import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../queries.dart';
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
double boxHeight = 0;
double boxWidth = 0;

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
    AppSetup setup = Provider.of<AppSetup>(context);
    // if (setup.currentProposalPoolId == 0) return Text('No pools are open...');
    return Subscription(
        options: SubscriptionOptions(
          document: gql(getProposalsFromProposalPool),
          variables: {'proposal_pool_id': setup.currentProposalPoolId},
        ),
        builder: (result) {
          print('result has exception');
          print(result.hasException);
          if (result.hasException) {
            print('exception');
            print(result.exception);
            return Text(result.exception.toString());
          }
          print('result loading ');
          print(result.isLoading);
          if (result.isLoading) {
            print('loading');
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          // print('chief engineer dashboard');
          // print(result.data);
          // print(result.data!['proposal'].length);
          Map<String, Proposal> proposals = {};
          List<Proposal> healthChecks = [];
          print("starting");
          print(result.source);
          print(result.source!.isEager);

          // print(result.data);
          for (var proposal in result.data!['proposal']) {
            // if (proposals.length > 6) break;
            // print(proposal['title']);
            // print(proposal['user']);
            // print(proposal['proposal_states'][0]);
            if (proposal['user'] == null) {
              healthChecks.add(
                Proposal.fromJson(
                  proposal,
                  ProposalState.fromJson(
                    proposal['proposal_states'][0],
                  ),
                ),
              );
            } else if (!proposals.containsKey(proposal['user']['department'])) {
              proposals.addAll({
                proposal['user']['department']: Proposal.fromJson(
                  proposal,
                  ProposalState.fromJson(
                    proposal['proposal_states'][0],
                  ),
                ),
              });
            }
          }

          print('done');
          //all six windows of each department initialization with custom widget
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
              title: 'Drivetrain',
              color: Colors.red,
              proposal: proposals['drivetrain'],
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
            HandsOnSection(
              title: 'Hands-On Team',
              color: Colors.blue,
              proposals: healthChecks,
              6,
              manageState,
            ),
          ];
          print(result.data);
          print("ending");
          return (_selected == 0)
              ? Container(
                  width: widget.width,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      boxHeight = constraints.maxHeight / 2;
                      boxWidth = constraints.maxWidth / 3;
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
                                ? Theme.of(context).secondaryHeaderColor
                                : (widget.proposal!.state!.state == 'APPROVED')
                                    ? Colors.green
                                    : (widget.proposal!.state!.state == 'NEW')
                                        ? Colors.blue
                                        : (widget.proposal!.state!.state ==
                                                'DONE')
                                            ? Colors.green
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
                              child: Text(
                                'APPROVE',
                                style: TextStyle(
                                  fontSize: customFontSize(boxWidth),
                                ),
                              ),
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
                                        proposal: Proposal.empty(),
                                        affectPart: false,
                                      );
                                    },
                            ),
                          if (widget.proposal != null && !hands)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text('REJECT',
                                  style: TextStyle(
                                      fontSize: customFontSize(boxWidth))),
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
                                        proposal: Proposal.empty(),
                                        affectPart: false,
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
                        color: Theme.of(context).secondaryHeaderColor),
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
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    (widget.proposal!.description),
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                  ),
                                ],
                              ),
                            ),
                            //show proposal part name
                            Text(
                              widget.proposal!.partName ?? 'part name',
                              style: TextStyle(
                                  fontSize: 25,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            //show proposal part current value
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.proposal!.partValueFrom,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                Text(
                                  '  -->  ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                //show proposal part suggested value
                                Text(
                                  widget.proposal!.partValueTo,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
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

class HandsOnSection extends StatefulWidget {
  HandsOnSection(
    int this.id,
    Function this.notifyParent, {
    required String this.title,
    required Color this.color,
    required List<Proposal?> this.proposals,
  });

  final title;
  final id;
  final color;
  final notifyParent;
  final List<Proposal?> proposals;
  @override
  State<HandsOnSection> createState() => _HandsOnSectionState();
}

class _HandsOnSectionState extends State<HandsOnSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),

                    //show proposal

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Checks Completed',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Center(
                                    child:
                                        //show part of title if title is too big, show everything when zoomed in
                                        ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.proposals.length,
                                  itemBuilder: (context, index) {
                                    Proposal prop = widget.proposals[index]!;
                                    Color c = (prop.state!.state == 'DONE')
                                        ? Colors.green
                                        : Colors.red;
                                    return ListTile(
                                      leading: Icon(
                                        prop.state!.state == 'DONE'
                                            ? Icons.done
                                            : Icons.close,
                                        color: c,
                                      ),
                                      title: Text(
                                        (prop.title.length < 35 ||
                                                _selected == widget.id)
                                            ? prop.title
                                            : prop.title
                                                .replaceRange(30, null, '...'),
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                      ),
                                    );
                                  },
                                )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 15, color: widget.color),
        ),
      ),
      onTap: () {
        //zoom in or out if window is tapped
        (_selected == 0) ? _selected = widget.id : _selected = 0;
        widget.notifyParent();
      },
    );
  }
}

double customFontSize(double boxWidth) {
  if (boxWidth > 400) {
    return 35;
  } else
    return 20;
}
