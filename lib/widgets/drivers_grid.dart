import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../widgets/drivers_grid_columns.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DriversDataWidget extends StatefulWidget {
  @override
  State<DriversDataWidget> createState() => _DriversDataWidgetState();
}

class _DriversDataWidgetState extends State<DriversDataWidget> {
  final _stream = supabase
      .from('drivers_data')
      .stream(primaryKey: ['id']).order('position', ascending: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final List<PlutoRow> drivers_fetchedRows = [];

          snapshot.data?.forEach((data) => {print('Fetched: ${data}')});

          snapshot.data?.forEach((data) => {
                drivers_fetchedRows.add(
                  PlutoRow(cells: {
                    'id': PlutoCell(value: data['id']),
                    'position': PlutoCell(value: data['position']),
                    'name': PlutoCell(value: data['rider_name']),
                    'team': PlutoCell(value: data['team']),
                    'best_lap': PlutoCell(value: data['best_lap']),
                    'last_lap': PlutoCell(value: data['last_lap']),
                  }),
                )
              });

          var drivers_plutogrid = PlutoGrid(
            columns: driver_columns,
            columnGroups: driver_columnGroups,
            rows: [],
          );

          drivers_fetchedRows.forEach((element) {
            drivers_plutogrid.rows.add(element);
          });
          return drivers_plutogrid;
        }
      },
    );
  }
}
