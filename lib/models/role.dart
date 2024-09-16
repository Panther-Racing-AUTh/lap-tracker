import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Role {
  int id;
  String role_name;
  Role(this.id, this.role_name);
}

class UserDataSource extends DataGridSource {
  UserDataSource({
    required List<Person> users,
    required List<DropdownMenuItem<Role>> allRolesDropdown,
    required Function changeRoleFunction,
  }) {
    List<Role> currentValue = [];
    for (int i = 0; i < users.length; i++) {
      for (int j = 0; j < allRolesDropdown.length; j++) {
        if (users[i].appRole.role_name == allRolesDropdown[j].value!.role_name)
          currentValue.add(allRolesDropdown[j].value!);
      }
    }

    @override
    Widget? buildEditWidget(
        DataGridRow dataGridRow,
        RowColumnIndex rowColumnIndex,
        GridColumn column,
        CellSubmit submitCell) {
      // The new cell value must be reset.
      // To avoid committing the [DataGridCell] value that was previously edited
      // into the current non-modified [DataGridCell].
      print('entered editing mode');
      return Container(
        child: DropdownButton<Role>(
          value: currentValue[rowColumnIndex.rowIndex],
          items: allRolesDropdown,
          onChanged: (Role? value) {
            users[rowColumnIndex.rowIndex].appRole.role_name = value!.role_name;
            currentValue[rowColumnIndex.rowIndex] = value;
            changeRoleFunction();
          },
        ),
      );
    }

    @override
    bool onCellBeginEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
        GridColumn column) {
      print('entered on cell begin editing');
      if (column.columnName == 'id') {
        // Return false, to restrict entering into the editing.
        return false;
      } else {
        return true;
      }
    }

    void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
        GridColumn column) {
      print('entered on cell submit');
    }

    _users = users.map<DataGridRow>(
      (u) {
        return DataGridRow(
          cells: [
            DataGridCell<int>(columnName: 'id', value: u.id),
            DataGridCell<String>(columnName: 'name', value: u.name),
            DataGridCell<String>(columnName: 'department', value: u.department),
            DataGridCell<String>(columnName: 'team_role', value: u.role),
            DataGridCell<DropdownButton>(
              columnName: 'role',
              value: DropdownButton<Role>(
                value: currentValue[users.indexOf(u)],
                items: allRolesDropdown,
                onChanged: (Role? value) {
                  u.appRole.role_name = value!.role_name;
                  changeRoleFunction();
                },
              ),
            ),
            DataGridCell<String>(columnName: 'created_at', value: u.created_at),
            DataGridCell<String>(
                columnName: 'last_modified', value: u.last_modified),
          ],
        );
      },
    ).toList();
  }

  List<DataGridRow> _users = [];

  @override
  List<DataGridRow> get rows => _users;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

List<GridColumn> AdminPanelColumns = [
  GridColumn(
    columnName: 'id',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'ID',
      ),
    ),
  ),
  GridColumn(
    columnName: 'name',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Profile',
      ),
    ),
  ),
  GridColumn(
    columnName: 'department',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Department',
      ),
    ),
  ),
  GridColumn(
    columnName: 'team_role',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Team Role',
      ),
    ),
  ),
  GridColumn(
    columnName: 'role',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Role',
      ),
    ),
  ),
  GridColumn(
    columnName: 'created_at',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Created At',
      ),
    ),
  ),
  GridColumn(
    columnName: 'last_modified',
    label: Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Last Modified At',
      ),
    ),
  ),
];
