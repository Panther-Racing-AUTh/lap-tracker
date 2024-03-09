// import 'package:flutter/material.dart';
// import 'package:flutter_complete_guide/dummy_data/telemetry_columns.dart';
// import 'package:flutter_complete_guide/dummy_data/telemetry_column_groups.dart';
// // import 'package:pluto_grid/pluto_grid.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final supabase = Supabase.instance.client;

// class DataDesktopWidget extends StatefulWidget {
//   @override
//   State<DataDesktopWidget> createState() => _DataDesktopWidgetState();
// }

// class _DataDesktopWidgetState extends State<DataDesktopWidget> {
//   // Persist the stream in a local variable to prevent refetching upon rebuilds

//   final _stream = supabase
//       .from('telemetry_system_data')
//       .stream(primaryKey: ['id']).order('racing_time', ascending: true);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: _stream,
//       builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           final List<PlutoRow> fetchedRows = [];

//           snapshot.data?.forEach((data) => {print('Fetched: ${data}')});

//           snapshot.data?.forEach((data) => {
//                 fetchedRows.add(
//                   PlutoRow(cells: {
//                     'id': PlutoCell(value: data['id']),
//                     'racing_time': PlutoCell(value: data['racing_time']),
//                     'date': PlutoCell(value: data['date']),
//                     'rpm': PlutoCell(value: data['rpm']),
//                     'oil_pressure': PlutoCell(value: data['oil_pressure']),
//                     'air_intake_pressure':
//                         PlutoCell(value: data['air_intake_pressure']),
//                     'air_intake_temperature':
//                         PlutoCell(value: data['air_intake_temperature']),
//                     'throttle_position':
//                         PlutoCell(value: data['throttle_position']),
//                     'fuel_temperature':
//                         PlutoCell(value: data['fuel_temperature']),
//                   }),
//                 )
//               });

//           var plutogrid = PlutoGrid(
//             columns: telemetry_columns,
//             columnGroups: telemetry_columnGroups,
//             rows: [],
//             onLoaded: (PlutoGridOnLoadedEvent event) {
//               //stateManager = event.stateManager;
//               event.stateManager.setShowColumnFilter(true);
//             },
//             onChanged: (PlutoGridOnChangedEvent event) async {
//               print(event);
//               print(event.column.field);

//               print(
//                   'I am updating ${event.column.field} from ${event.oldValue} to ${event.row.cells[event.column.field]?.value}');

//               await supabase.from('telemetry_system_data').update({
//                 event.column.field: event.row.cells[event.column.field]?.value
//               }).match({'id': event.row.cells['id']?.value});
//             },
//           );
//           fetchedRows.forEach((element) {
//             plutogrid.rows.add(element);
//             print('insterted: ${element.toJson()}');
//           });
//           return plutogrid;
//         }
//       },
//     );
//   }
// }
