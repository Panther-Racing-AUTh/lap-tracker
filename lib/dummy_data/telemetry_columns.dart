import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_complete_guide/names.dart';

final List<PlutoColumn> telemetry_columns = <PlutoColumn>[
  PlutoColumn(
    title: telemetry_columns_date,
    field: 'date',
    type: PlutoColumnType.date(),
  ),
  PlutoColumn(
    title: telemetry_columns_racing_time,
    field: 'racing_time',
    type: PlutoColumnType.time(defaultValue: '00:00:00:00'),
  ),
  PlutoColumn(
    title: telemetry_columns_id,
    field: 'id',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: telemetry_columns_rpm,
    field: 'rpm',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: telemetry_columns_oil_pressure,
    field: 'oil_pressure',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: telemetry_columns_air_intake_pressure,
    field: 'air_intake_pressure',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: telemetry_columns_air_intake_temperature,
    field: 'air_intake_temperature',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: telemetry_columns_throttle_position,
    field: 'throttle_position',
    type: PlutoColumnType.currency(),
  ),
  PlutoColumn(
    title: telemetry_columns_fuel_temperature,
    field: 'fuel_temperature',
    type: PlutoColumnType.number(),
  ),
];
