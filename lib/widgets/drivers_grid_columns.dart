import 'package:pluto_grid/pluto_grid.dart';

final List<PlutoColumn> driver_columns = [
  PlutoColumn(
    title: 'Position',
    field: 'position',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Team Number',
    field: 'id',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Rider Name',
    field: 'name',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Team',
    field: 'team',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Best Lap',
    field: 'best_lap',
    type: PlutoColumnType.time(),
  ),
  PlutoColumn(
    title: 'Last Lap',
    field: 'last_lap',
    type: PlutoColumnType.time(),
  ),
];

final List<PlutoColumnGroup> driver_columnGroups = [
  PlutoColumnGroup(
      title: 'Position', fields: ['position'], expandedColumn: true),
  PlutoColumnGroup(title: 'Team Number', fields: ['id'], expandedColumn: true),
  PlutoColumnGroup(title: 'Rider Name', fields: ['name'], expandedColumn: true),
  PlutoColumnGroup(title: 'Team', fields: ['team'], expandedColumn: true),
  PlutoColumnGroup(
      title: 'Best Lap', fields: ['best_lap'], expandedColumn: true),
  PlutoColumnGroup(
      title: 'Last Lap', fields: ['last_lap'], expandedColumn: true),
];
late final PlutoGridStateManager stateManager;
