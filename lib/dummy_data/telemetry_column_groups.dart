import 'package:flutter_complete_guide/names.dart';
import 'package:pluto_grid/pluto_grid.dart';

final List<PlutoColumnGroup> telemetry_columnGroups = [
  PlutoColumnGroup(
      title: telemetry_columns_date, fields: ['date'], expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_racing_time,
      fields: ['racing_time'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_rpm, fields: ['rpm'], expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_oil_pressure,
      fields: ['oil_pressure'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_air_intake_pressure,
      fields: ['air_intake_pressure'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_air_intake_temperature,
      fields: ['air_intake_temperature'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_throttle_position,
      fields: ['throttle_position'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: telemetry_columns_fuel_temperature,
      fields: ['fuel_temperature'],
      expandedColumn: true),
  // PlutoColumnGroup(
  //     title: 'User information', fields: ['id', 'age', 'name', 'role']),
];
late final PlutoGridStateManager stateManager;
