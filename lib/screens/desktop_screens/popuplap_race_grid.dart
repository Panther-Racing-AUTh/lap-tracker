// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:pluto_grid/pluto_grid.dart';

// import '../../models/event.dart';
// import '../../queries.dart';

// class PopUpRaceLapGrid extends StatefulWidget {
//   PopUpRaceLapGrid(this.loadedData, this.session);
//   Function loadedData;
//   Session? session;
//   @override
//   State<PopUpRaceLapGrid> createState() => _PopUpRaceLapGridState();
// }

// final List<PlutoColumn> lapcolumns = <PlutoColumn>[
//   // PlutoColumn(
//   //   title: 'Date',
//   //   field: 'date',
//   //   type: PlutoColumnType.date(),
//   // ),
//   PlutoColumn(
//     title: 'Lap',
//     field: 'lap',
//     type: PlutoColumnType.text(),
//   ),
// ];

// class _PopUpRaceLapGridState extends State<PopUpRaceLapGrid> {
//   @override
//   Widget build(BuildContext context) {
//     final List<PlutoRow> lapfetchedRows = [];
//     widget.session!.laps.forEach(
//       (lap) {
//         lapfetchedRows.add(
//           PlutoRow(
//             cells: {
//               // 'date': PlutoCell(value: event.date),
//               'lap': PlutoCell(value: lap.order),
//             },
//           ),
//         );
//       },
//     );

//     // events.forEach(
//     //   (event) => {
//     //     event.sessions.forEach((session) {
//     //       session.laps.forEach((lap) {
//     //         print('The lap is ${lap.order}');
//     //       });
//     //     })
//     //   },
//     // );

//     /// columnGroups that can group columns can be omitted.
//     final List<PlutoColumnGroup> lapcolumnGroups = [
//       // PlutoColumnGroup(
//       //   title: 'Date',
//       //   fields: ['date'],
//       //   expandedColumn: true,
//       // ),
//       PlutoColumnGroup(
//         title: 'Lap',
//         fields: ['lap'],
//         expandedColumn: true,
//       ),
//     ];
//     return Scaffold(
//         body: Container(
//       padding: const EdgeInsets.all(15),
//       child: PlutoGrid(
//         columns: lapcolumns,
//         rows: lapfetchedRows,
//         columnGroups: lapcolumnGroups,
//         mode: PlutoGridMode.select,
//         onChanged: (PlutoGridOnChangedEvent event) {
//           print(event);
//         },
//         onSelected: (PlutoGridOnSelectedEvent) {
//           print('Panagiwth kane ta dika sou twra');
//           widget.loadedData();
//           Navigator.of(context).popUntil((route) => route.isFirst);
//         },
//         onLoaded: (PlutoGridOnLoadedEvent event) {
//           //stateManager = event.stateManager;
//           event.stateManager.setShowColumnFilter(true);
//         },
//         configuration: const PlutoGridConfiguration(),
//       ),
//     ));
//   }
// }
