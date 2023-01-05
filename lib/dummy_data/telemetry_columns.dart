import 'package:pluto_grid/pluto_grid.dart';

final List<PlutoColumn> telemetry_columns = <PlutoColumn>[
  PlutoColumn(
    title: 'Date',
    field: 'date',
    type: PlutoColumnType.date(),
  ),
  PlutoColumn(
    title: 'Racing Time',
    field: 'racing_time',
    type: PlutoColumnType.time(defaultValue: '00:00:00:00'),
  ),
  PlutoColumn(
    title: 'Id',
    field: 'id',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Average RPM',
    field: 'average_rpm',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Oil Pressure',
    field: 'oil_pressure',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Air Intake Pressure',
    field: 'air_intake_pressure',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Air Intake Temperature',
    field: 'air_intake_temperature',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Throttle Position',
    field: 'throttle_position',
    type: PlutoColumnType.currency(),
  ),
  PlutoColumn(
    title: 'Fuel Temperature',
    field: 'fuel_temperature',
    type: PlutoColumnType.number(),
  ),
];
