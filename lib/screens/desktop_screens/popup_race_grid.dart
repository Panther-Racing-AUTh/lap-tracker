import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PopUpRaceGrid extends StatefulWidget {
  const PopUpRaceGrid({super.key});

  @override
  State<PopUpRaceGrid> createState() => _PopUpRaceGridState();
}

final List<PlutoColumn> columns = <PlutoColumn>[
  PlutoColumn(
    title: 'Id',
    field: 'id',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Name',
    field: 'name',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Age',
    field: 'age',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Role',
    field: 'role',
    type: PlutoColumnType.select(<String>[
      'Programmer',
      'Designer',
      'Owner',
    ]),
  ),
  PlutoColumn(
    title: 'Joined',
    field: 'joined',
    type: PlutoColumnType.date(),
  ),
  PlutoColumn(
    title: 'Working time',
    field: 'working_time',
    type: PlutoColumnType.time(),
  ),
];

final List<PlutoRow> rows = [
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike'),
      'age': PlutoCell(value: 20),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'working_time': PlutoCell(value: '09:00'),
    },
  ),
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user2'),
      'name': PlutoCell(value: 'Jack'),
      'age': PlutoCell(value: 25),
      'role': PlutoCell(value: 'Designer'),
      'joined': PlutoCell(value: '2021-02-01'),
      'working_time': PlutoCell(value: '10:00'),
    },
  ),
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user3'),
      'name': PlutoCell(value: 'Suzi'),
      'age': PlutoCell(value: 40),
      'role': PlutoCell(value: 'Owner'),
      'joined': PlutoCell(value: '2021-03-01'),
      'working_time': PlutoCell(value: '11:00'),
    },
  ),
];

/// columnGroups that can group columns can be omitted.
final List<PlutoColumnGroup> columnGroups = [
  PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
  PlutoColumnGroup(title: 'User information', fields: ['name', 'age']),
  PlutoColumnGroup(title: 'Status', children: [
    PlutoColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
    PlutoColumnGroup(title: 'Etc.', fields: ['joined', 'working_time']),
  ]),
];

class _PopUpRaceGridState extends State<PopUpRaceGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          columnGroups: columnGroups,
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          configuration: const PlutoGridConfiguration(),
        ),
      ),
    );
  }
}
