import 'package:flutter_complete_guide/names.dart';
import 'package:pluto_grid/pluto_grid.dart';

final List<PlutoColumn> driver_columns = [
  PlutoColumn(
    title: drivers_grid_columns_position,
    field: 'position',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: drivers_grid_columns_team_number,
    field: 'id',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: drivers_grid_columns_rider_name,
    field: 'name',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: drivers_grid_columns_team,
    field: 'team',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: drivers_grid_columns_best_lap,
    field: 'best_lap',
    type: PlutoColumnType.time(),
  ),
  PlutoColumn(
    title: drivers_grid_columns_last_lap,
    field: 'last_lap',
    type: PlutoColumnType.time(),
  ),
];

final List<PlutoColumnGroup> driver_columnGroups = [
  PlutoColumnGroup(
      title: drivers_grid_columns_position,
      fields: ['position'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: drivers_grid_columns_team_number,
      fields: ['id'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: drivers_grid_columns_rider_name,
      fields: ['name'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: drivers_grid_columns_team, fields: ['team'], expandedColumn: true),
  PlutoColumnGroup(
      title: drivers_grid_columns_best_lap,
      fields: ['best_lap'],
      expandedColumn: true),
  PlutoColumnGroup(
      title: drivers_grid_columns_last_lap,
      fields: ['last_lap'],
      expandedColumn: true),
];
late final PlutoGridStateManager stateManager;
