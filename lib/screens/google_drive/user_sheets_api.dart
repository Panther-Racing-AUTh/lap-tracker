import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

class UserSheetsApi {
  static final _spreadsheetId = '1TFuf9HsIZprOaKAVxrlM3XLyuOg4NFNXrqjbCpanBNc';
  static const _credentials = r''' 
    {
      "type": "service_account",
      "project_id": "tensile-medium-368722",
      "private_key_id": "9c146e59ca2e2735de8fa904486b07512ba5adfd",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrcsB9Kz2sYNsB\nmlL95PLDzZ4t64KsNw6lhJLP9ht2r1D3RaXenpkqyd2jD67h/NfzIgf6Ob9cAa6+\n6gdej6oZGbFGVlf9ZhuvvMhQM0HFeHxa059T/Ck3Fk+BBKBK7irV1Klf3GCU8gYj\njv/ofKDGCtBLOxu9jOzNe9rivLRS5las4F/+c/WkbPfP54dPvnwWgTgoaudTzeEe\nByZExYS4wsQXG7TsIyD46byfO/SxXDVD45HfZFPztAk2x4uv17cwLitE9wQRaNzY\nEIwRjDgqSvs34eLWPs+k3Hguc8rhBBAE1SgEAz9I+hCfdkrpSRA+rjt/YIOCkzgM\nQW9QsJiTAgMBAAECggEAC52CnPhI/VyyebFS3hCcwdc0WDgUakZwn5YTvDMYOTo3\nagk165cjGVsDwQBXAMh4eOhdUf6HkFws0pJYXXeuNnUfJXzECU7ZoVZQ294dHpvD\nEQQ1TyNOR4UjbcI6edkY3dPChdQQVwbuk4oknEOVQNWKtw4SGw1pHaK+eY3/SX5l\nAScjcmnrckZVjiEwVObPyauhOMiif37EQVxIw9jzAz2Z1vG03OLHUP3EYxOu5aAz\nrlo47RsfgyYVAQl6krcaz7CkSZySZXUo5J/617PXdqsqVW5VyEQ0fZqa8lKT5XGF\nGdL81gUp/P+ceuXPrfIgK0pVYjHHT33+Rb8ze4kfQQKBgQDePCZybiJjz3laz53B\ngnMfHXDrR0DXCkr25X2Hb3rM8fvCE/fX6eZxb9gA53CvX/ub0Opv/kLlZlSZF7nh\nf2kUtVmLpsHiTS78Ob0cCRuBZo7fXC9XQkvGYOx+OqYK561hVeoo6VCXxzgpnxVf\nA5uLh6v24wTV0T/9wosQSeiHNQKBgQDFfz9ttHLnYnTGt/FMma65qJtvODxTKZyH\ngOyrR5X4HIleAKEbXDQkBGTpVYqUlE/rLPt68QqQUu5rjzoy8SSDpRFH2TMORsni\n0mXrNUIss+Z8sEzh6hczmNySWIBcVx+lQ+Z2DTS6wVG7CXjCKsNOb157PWL4zhQp\n7ZsV/UpxpwKBgHfHncVRXRHE0pjCjDmvUNM1cBYvul/s+Uinmofz6xEpX9NUJeJm\n/ECp0pdyJscviZKLAMDKH047YF9/bT2ACagSsqfVgmyxwyBJEodY1U1idKEos49p\neSP8O5sxiysXgdiTkPjp//k+dCPizYb/j8edoW8ZHxMLjFz+jSuDWmP9AoGBAKEx\ndKGjsEzubQVsSIQOwy9BUGv8aDAwPFPUhFZfvSWelPemZ9ge72eeNobDjLIsQvZd\n5nu3lLmrFnGvmv7NFtJjvbD4s9UpLcn1k73f4D0AMFUAyB9zorA4SX8gwNOdQHTw\n8H7V1H3BH2YbGvbPVE0GVQUdW1RbTtXR2sydyU7tAoGAOkdhF1HeKbO8Goqo881B\nNkHAPNqvqC6taspl7UPssIii645amB1vQ7hjcyzrfIx5foqahI1s5fbyyrsA/hk7\nVWOdpfqGvYZAIAOcOosvOWuy8//kjoul/O3qdHJZiNK23OjgMr4A8byWg0B748qn\nzno96yfPpUZifzhstyh8xLk=\n-----END PRIVATE KEY-----\n",
      "client_email": "panther-gsheet-recap-2024-2025@tensile-medium-368722.iam.gserviceaccount.com",
      "client_id": "109786098136099760396",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/panther-gsheet-recap-2024-2025%40tensile-medium-368722.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
  ''';

  static final _gsheets = GSheets(_credentials);

  // Creating a Sheet.
  static Worksheet? userSheet;
  static String? name;

  static Future init(BuildContext context) async {
    try {
      final appSetup = provider.Provider.of<AppSetup>(context, listen: false);

      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      userSheet = await _getWorkSheet(spreadsheet, title: 'Main-Recap');
      name = appSetup.username;
      // Generate the pattern for 3 weeks
      final pattern = _generatePattern();

      // Insert the pattern in the first row starting from the second column if not already present
      final headerRow = await userSheet!.values.row(1);
      if (headerRow.isEmpty) {
        await userSheet!.values.insertRow(1, pattern, fromColumn: 3);
      }

      final lastRow = await _findLastUserRow();

      var rowIndex = await _findRowIndexByKey(name!);
      if (rowIndex == -1) {
        print('Row with key $name not found.');
        await userSheet!.values.insertValue(name!, column: 1, row: lastRow);
        final userFields = UserFields.getFields();
        await userSheet!.values.insertColumn(2, userFields, fromRow: lastRow);
        rowIndex = lastRow;
      }

    } catch (e) {
      print('init error $e');
    }
  }

  static List<String> _generatePattern() {
    final days = ["Monday", "Wednesday", "Saturday"];
    final pattern = <String>[];
    final startDate = DateTime(2024, 5, 1);

    for (int i = 0; i < 48 * 7; i++) {
      final date = startDate.add(Duration(days: i));
      if (days.contains(DateFormat('EEEE').format(date))) {
        pattern.add('[${DateFormat('EEEE').format(date)}, ${DateFormat('dd/MM/yyyy').format(date)}]');
      }
    }
    return pattern;
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<int> _findColumnIndexByKey(String key) async {
    final headerRow = await userSheet!.values.row(1);
    for (int i = 0; i < headerRow.length; i++) {
      final compositeKey = headerRow[i];
      if (compositeKey == key) {
        return i + 1; // Columns are 1-based index in GSheets
      }
    }
    return -1; // Not found
  }

  static Future<int> _findRowIndexByKey(String key) async {
    final headerColumn = await userSheet!.values.column(1);
    for (int i = 0; i < headerColumn.length; i++) {
      final compositeKey = headerColumn[i];
      if (compositeKey == key) {
        return i + 1; // Rows are 1-based index in GSheets
      }
    }
    return -1; // Not found
  }

  static Future<int> _findLastUserRow() async {
    final allRows = await userSheet!.values.allRows(fromRow: 1);
    return allRows.length + 2; // Each user occupies 4 rows
  }

  static Future insertUser(Map<String, dynamic> user, String key) async {
    if (userSheet == null) return;
    final columnIndex = await _findColumnIndexByKey(key);
    if (columnIndex == -1) {
      print('Column with key $key not found.');
      return;
    }

    final rowIndex = await _findRowIndexByKey(name!);
    final userEntries = user.entries.toList();

    for (int i = 0; i < userEntries.length; i++) {
      await userSheet!.values.insertValue(userEntries[i].value, column: columnIndex, row: rowIndex+i);
    }
  }
}

class UserFields {
  static final String submit_date = 'Submit Date';
  static final String recap_list = 'Recap List';
  static final String future_list = 'Future List';
  static final String message = 'Message';

  static List<String> getFields() => [submit_date, recap_list, future_list, message];
}

class UserSheetsApiOld {
  static final _spreadsheetId = '1TFuf9HsIZprOaKAVxrlM3XLyuOg4NFNXrqjbCpanBNc';
  static const _credentials = r''' 
    {
      "type": "service_account",
      "project_id": "tensile-medium-368722",
      "private_key_id": "9c146e59ca2e2735de8fa904486b07512ba5adfd",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrcsB9Kz2sYNsB\nmlL95PLDzZ4t64KsNw6lhJLP9ht2r1D3RaXenpkqyd2jD67h/NfzIgf6Ob9cAa6+\n6gdej6oZGbFGVlf9ZhuvvMhQM0HFeHxa059T/Ck3Fk+BBKBK7irV1Klf3GCU8gYj\njv/ofKDGCtBLOxu9jOzNe9rivLRS5las4F/+c/WkbPfP54dPvnwWgTgoaudTzeEe\nByZExYS4wsQXG7TsIyD46byfO/SxXDVD45HfZFPztAk2x4uv17cwLitE9wQRaNzY\nEIwRjDgqSvs34eLWPs+k3Hguc8rhBBAE1SgEAz9I+hCfdkrpSRA+rjt/YIOCkzgM\nQW9QsJiTAgMBAAECggEAC52CnPhI/VyyebFS3hCcwdc0WDgUakZwn5YTvDMYOTo3\nagk165cjGVsDwQBXAMh4eOhdUf6HkFws0pJYXXeuNnUfJXzECU7ZoVZQ294dHpvD\nEQQ1TyNOR4UjbcI6edkY3dPChdQQVwbuk4oknEOVQNWKtw4SGw1pHaK+eY3/SX5l\nAScjcmnrckZVjiEwVObPyauhOMiif37EQVxIw9jzAz2Z1vG03OLHUP3EYxOu5aAz\nrlo47RsfgyYVAQl6krcaz7CkSZySZXUo5J/617PXdqsqVW5VyEQ0fZqa8lKT5XGF\nGdL81gUp/P+ceuXPrfIgK0pVYjHHT33+Rb8ze4kfQQKBgQDePCZybiJjz3laz53B\ngnMfHXDrR0DXCkr25X2Hb3rM8fvCE/fX6eZxb9gA53CvX/ub0Opv/kLlZlSZF7nh\nf2kUtVmLpsHiTS78Ob0cCRuBZo7fXC9XQkvGYOx+OqYK561hVeoo6VCXxzgpnxVf\nA5uLh6v24wTV0T/9wosQSeiHNQKBgQDFfz9ttHLnYnTGt/FMma65qJtvODxTKZyH\ngOyrR5X4HIleAKEbXDQkBGTpVYqUlE/rLPt68QqQUu5rjzoy8SSDpRFH2TMORsni\n0mXrNUIss+Z8sEzh6hczmNySWIBcVx+lQ+Z2DTS6wVG7CXjCKsNOb157PWL4zhQp\n7ZsV/UpxpwKBgHfHncVRXRHE0pjCjDmvUNM1cBYvul/s+Uinmofz6xEpX9NUJeJm\n/ECp0pdyJscviZKLAMDKH047YF9/bT2ACagSsqfVgmyxwyBJEodY1U1idKEos49p\neSP8O5sxiysXgdiTkPjp//k+dCPizYb/j8edoW8ZHxMLjFz+jSuDWmP9AoGBAKEx\ndKGjsEzubQVsSIQOwy9BUGv8aDAwPFPUhFZfvSWelPemZ9ge72eeNobDjLIsQvZd\n5nu3lLmrFnGvmv7NFtJjvbD4s9UpLcn1k73f4D0AMFUAyB9zorA4SX8gwNOdQHTw\n8H7V1H3BH2YbGvbPVE0GVQUdW1RbTtXR2sydyU7tAoGAOkdhF1HeKbO8Goqo881B\nNkHAPNqvqC6taspl7UPssIii645amB1vQ7hjcyzrfIx5foqahI1s5fbyyrsA/hk7\nVWOdpfqGvYZAIAOcOosvOWuy8//kjoul/O3qdHJZiNK23OjgMr4A8byWg0B748qn\nzno96yfPpUZifzhstyh8xLk=\n-----END PRIVATE KEY-----\n",
      "client_email": "panther-gsheet-recap-2024-2025@tensile-medium-368722.iam.gserviceaccount.com",
      "client_id": "109786098136099760396",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/panther-gsheet-recap-2024-2025%40tensile-medium-368722.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
  ''';

  static final _gsheets = GSheets(_credentials);

  // Creating a Sheet.
  static Worksheet? userSheet;

  static Future init(BuildContext context) async {
    try {
      final appSetup=provider.Provider.of<AppSetup>(context,listen: false);

      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      userSheet = await _getWorkSheet(spreadsheet, title: appSetup.username);


      // Generate the pattern for 3 weeks
      final pattern = _generatePattern();

      // Insert the pattern in the first row starting from the second column
      await userSheet!.values.insertRow(1, pattern, fromColumn: 2);


      // Insert the user fields in the second row
      final userFields = UserFields.getFields();
      await userSheet!.values.insertColumn(1,fromRow: 2, userFields);


    } catch (e) {
      print('init error $e');
    }
  }

  static List<String> _generatePattern() {
    final days = ["Monday", "Wednesday", "Saturday"];
    final pattern = <String>[];
    final dateFormat = DateFormat('dd/MM');
    final startDate = DateTime(2024,5,1);

    for (int i = 0; i < 48 * 7; i++) {
      final date = startDate.add(Duration(days: i));
      if (days.contains(DateFormat('EEEE').format(date))) {
        pattern.add('[${DateFormat('EEEE').format(date)}, ${DateFormat('dd/MM/yyyy').format(date)}]');
      }
    }
    return pattern;
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<int> _findColumnIndexByKey(String key) async {
    final headerRow = await userSheet!.values.row(1);
    for (int i = 0; i < headerRow.length; i++) {
      final compositeKey = headerRow[i];
      //print(headerRow[i].toString());
      if (compositeKey == '${key}') {
        return i + 1; // Columns are 1-based index in GSheets
      }
    }
    return -1; // Not found
  }

  static Future insertUser(Worksheet? userSheet,Map<String, dynamic> user,String key) async {
    if (userSheet == null) return;
    final columnIndex = await _findColumnIndexByKey(key);
    if (columnIndex == -1) {
      print('Column with key $key not found.');
      return;
    }
    await userSheet.values.map.insertColumn(columnIndex, user, fromRow: 2);
  }

}

