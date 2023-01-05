import 'package:pluto_grid/pluto_grid.dart';

final List<PlutoColumnGroup> telemetry_columnGroups = [
  PlutoColumnGroup(title: 'Date', fields: ['date'], expandedColumn: true),
  PlutoColumnGroup(
      title: 'Racing Time', fields: ['racing_time'], expandedColumn: true),
  PlutoColumnGroup(
      title: 'Average RPM', fields: ['average_rpm'], expandedColumn: true),
  PlutoColumnGroup(
      title: 'Oil Pressure', fields: ['oil_pressure'], expandedColumn: true),
  PlutoColumnGroup(
      title: 'Air Intake Pressure',
      fields: ['air_intake_pressure'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: 'Air Intake Temperature',
      fields: ['air_intake_temperature'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: 'Throttle Position',
      fields: ['throttle_position'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: 'Fuel Temperature',
      fields: ['fuel_temperature'],
      expandedColumn: true),
  // PlutoColumnGroup(
  //     title: 'User information', fields: ['id', 'age', 'name', 'role']),
];
late final PlutoGridStateManager stateManager;
