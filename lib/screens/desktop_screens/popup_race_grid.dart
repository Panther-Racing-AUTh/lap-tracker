import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/diagram_comparison_button.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../models/event.dart';
import '../../queries.dart';

class PopUpRaceGrid extends StatefulWidget {
  const PopUpRaceGrid({super.key});

  @override
  State<PopUpRaceGrid> createState() => _PopUpRaceGridState();
}

final List<PlutoColumn> columns = <PlutoColumn>[
  PlutoColumn(
    title: 'Date',
    field: 'date',
    type: PlutoColumnType.date(),
  ),
  PlutoColumn(
    title: 'Racetrack',
    field: 'racetrack',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Country',
    field: 'country',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Session',
    field: 'session',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Description',
    field: 'description',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Session Type',
    field: 'sessiontype',
    type: PlutoColumnType.text(),
  ),
];

class _PopUpRaceGridState extends State<PopUpRaceGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Subscription(
            options: SubscriptionOptions(document: gql(getEvents)),
            builder: (result) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              print(result.data);
              //#########
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

              final List<PlutoRow> fetchedRows = [];

              events.forEach(
                (event) => {
                  event.sessions.forEach((session) {
                    fetchedRows.add(
                      PlutoRow(
                        cells: {
                          'date': PlutoCell(value: event.date),
                          'session': PlutoCell(value: event.id),
                          'racetrack': PlutoCell(value: session.raceTrack.name),
                          'country':
                              PlutoCell(value: session.raceTrack.country),
                          'description': PlutoCell(value: event.description),
                          'sessiontype': PlutoCell(value: session.type),
                        },
                      ),
                    );
                  })
                },
              );

              /// columnGroups that can group columns can be omitted.
              final List<PlutoColumnGroup> columnGroups = [
                PlutoColumnGroup(
                  title: 'Date',
                  fields: ['date'],
                  expandedColumn: true,
                ),
                PlutoColumnGroup(
                  title: 'Session',
                  fields: ['session'],
                  expandedColumn: true,
                ),
                PlutoColumnGroup(
                  title: 'Racetrack',
                  fields: ['racetrack'],
                  expandedColumn: true,
                ),
                PlutoColumnGroup(
                  title: 'Country',
                  fields: ['country'],
                  expandedColumn: true,
                )
              ];

              return PlutoGrid(
                columns: columns,
                rows: fetchedRows,
                columnGroups: columnGroups,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                configuration: const PlutoGridConfiguration(),
              );
            },
          )),
    );
  }
}
