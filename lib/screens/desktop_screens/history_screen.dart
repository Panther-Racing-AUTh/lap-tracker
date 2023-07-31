import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:timelines/timelines.dart';

import '../../models/event.dart';
import '../../models/proposal.dart';
import '../../queries.dart';
import '../../supabase/proposal_functions.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen(this.width);
  double width;
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

Event _selectedEvent = Event.empty();
Session _selectedSession = Session.empty();
List<ProposalPool> pools = [];
ProposalPool _selectedPool = ProposalPool.empty();

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryScreen> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Subscription(
      options: SubscriptionOptions(
        document: gql(getAllEvents),
      ),
      builder: (result) {
        if (result.hasException) {
          print(result.exception);
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }

        List<Event> events = [];
        for (var event in result.data!['event_date']) {
          List<Session> sessions = [];
          for (var session in event['sessions']) {
            List<Lap> laps = [];
            for (var lap in session['laps']) {
              laps.add(Lap.fromJson(lap));
            }
            sessions.add(Session.fromJson(session, laps));
          }
          events.add(Event.fromJson(event, sessions));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.width * 0.2 - 16,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: SessionSelector(
                  events,
                  () => setState(() {}),
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
            ),
            Container(
              width: widget.width * 0.8,
              child: (pools.isNotEmpty)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: _selectedPool.id != 0,
                          child: PoolDetails(events, widget.width * 0.4),
                        ),
                        Expanded(
                          child: Timeline.builder(
                            shrinkWrap: true,
                            itemCount: 2 * pools.length - 1,
                            itemBuilder: (context, index) {
                              var currentPool = pools[index ~/ 2];
                              if (index.isEven)
                                return TimelineTile(
                                  oppositeContents: Text(
                                    currentPool.proposals.length.toString() +
                                        ' proposals',
                                  ),
                                  contents: Container(
                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: Card(
                                      color:
                                          (_selectedPool.id == currentPool.id)
                                              ? Colors.lightGreenAccent
                                              : Theme.of(context).cardColor,
                                      child: ListTile(
                                        title: Container(
                                          child: Text(
                                              currentPool.createdAt.toString()),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if (_selectedPool.id ==
                                                currentPool.id) {
                                              _selectedPool.id = 0;
                                            } else {
                                              _selectedPool.id = currentPool.id;
                                              _selectedPool.createdAt =
                                                  currentPool.createdAt;
                                              _selectedPool.ended =
                                                  currentPool.ended;
                                              _selectedPool.proposals =
                                                  currentPool.proposals;
                                              _selectedPool.sessionId =
                                                  currentPool.sessionId;
                                              _selectedPool.vehicleId =
                                                  currentPool.vehicleId;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  node: TimelineNode(
                                    indicator: DotIndicator(),
                                    startConnector: SolidLineConnector(),
                                    endConnector: SolidLineConnector(),
                                  ),
                                );
                              if (index.isOdd)
                                return SizedBox(
                                  height: 20.0,
                                  child: SolidLineConnector(),
                                );
                              return Container();
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'Select Filters and apply!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            )
          ],
        );
      },
    );
  }
}

class SessionSelector extends StatefulWidget {
  SessionSelector(this.events, this.refreshState);
  List<Event> events;
  Function refreshState;
  @override
  State<SessionSelector> createState() => _SessionSelectorState();
}

class _SessionSelectorState extends State<SessionSelector> {
  @override
  void initState() {
    _selectedEvent = widget.events[0];
    _selectedSession = widget.events[0].sessions[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Events',
              style: TextStyle(fontSize: 20),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return Card(
                  child: ListTile(
                    title: Text(event.description),
                    tileColor: (event.id == _selectedEvent.id)
                        ? Colors.lightGreenAccent
                        : Colors.white,
                    onTap: () {
                      setState(() {
                        _selectedEvent = event;
                        _selectedSession = event.sessions[0];
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              'Sessions',
              style: TextStyle(fontSize: 20),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedEvent.sessions.length,
              itemBuilder: (context, index) {
                final session = _selectedEvent.sessions[index];
                return Card(
                  child: ListTile(
                    title: Text(session.type),
                    tileColor: (session.id == _selectedSession.id)
                        ? Colors.lightGreenAccent
                        : Colors.white,
                    onTap: () {
                      setState(() {
                        _selectedSession = session;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
        TextButton(
          onPressed: () async {
            print("selected session id is: " + _selectedSession.id.toString());
            final props =
                await getProposalsForSession(sessionId: _selectedSession.id);
            print('object');
            setState(() {
              pools = props;
              widget.refreshState();
            });
          },
          child: Text('Search'),
        )
      ],
    );
  }
}

class PoolDetails extends StatefulWidget {
  PoolDetails(this.events, this.width);
  List<Event> events;
  double width;
  @override
  State<PoolDetails> createState() => _PoolDetailsState();
}

class _PoolDetailsState extends State<PoolDetails> {
  @override
  Widget build(BuildContext context) {
    print('oh no');
    Event e = widget.events.firstWhere((element) =>
        element.sessions
            .firstWhere((element) => element.id == _selectedPool.sessionId)
            .id ==
        _selectedPool.sessionId);
    print(e.id);
    Session s = e.sessions
        .firstWhere((element) => element.id == _selectedPool.sessionId);
    print(_selectedEvent.id);
    print(_selectedSession.id);
    print(_selectedPool.id);
    print(_selectedPool.proposals.length);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: widget.width,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Session Type: ' + s.type,
            style: TextStyle(fontSize: 25),
          ),
          Text(
            'Date: ' + _selectedPool.createdAt.toString(),
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'All Proposals: ',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2 * _selectedPool.proposals.length,
                  itemBuilder: (context, index) {
                    final prop = _selectedPool.proposals[index ~/ 2];

                    if (index.isEven)
                      return Container(
                        height: 50 + prop.states!.length * 30,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                        ),
                        child: ListTile(
                          title: Column(
                            children: [
                              Text(
                                prop.title,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: prop.states!.length,
                                  itemBuilder: (context, ind) {
                                    return Column(
                                      children: [
                                        Text(
                                          'State: ' +
                                              prop.states![ind].state +
                                              ' at: ' +
                                              prop.states![ind].createdAt
                                                  .toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    else
                      return SizedBox(
                        height: 10,
                      );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
