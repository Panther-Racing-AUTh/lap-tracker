import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

class UserSheetsApi {
  static final _spreadsheetId = '1pZzEa5TYPNe7um1LR0pvg3hrFOzQaS8qpENM2pek3fE';
  static const _credentials = r''' 
    {
      "type": "service_account",
      "project_id": "tensile-medium-368722",
      "private_key_id": "ec2d017746d5e1e9b037945799418547ec8015cd",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDQ5iy7/i04V2G\n3d4vRMfrnNJholA9uI6grnThy9vV0kxQGdMwvBOjI0/JCGOz8/UNfaaIDzuQp9ID\nHEa3QnHF/vf8y3c2Tk1vFXGgx9I52qel5IrbwdB8m9kcrWWyNPKXr1j7NzKL8xto\nHSSir0DfRsnGrrDzFl3LsZgEIU+hVUP81NuvnL8nJTXwMTBQlrpMUMsJutfIXjWF\n3v4RRm+Acua+jnk8zR3A3Up43dV0FpBxgSehJ9g/su6wkN2l74Zpd8adwopdlPeR\n1PtfQXTIeSaWpeCYMOgu0oC4xExHU14zK0bIY7C5XmVEvdXjQo+TJY5bB6IBFOEE\nmg5oL5yBAgMBAAECggEABtnSa9XIUrVVAhg69UrbHlDDX15R5SZ6Z5gTXQA5a3I8\nT/OmAZ/ZqwfAQwAGun+41XM3Am9RYlEHCOmnMAMWaZFZa07KtRaweBEnKlJUdYfu\nyZ7gAdeWHGcd6hgJ2UOrDsgdzbuZLAiYqbGbEVOniaXqyqwipHbAjfbiS+PMzs7W\nm3O3GrNgCvldYCi0aiepPFKhWi8Uiblmj/Bay/4zUO1Dxz628Z6eGMZeaI6fR6vj\nJrfdxsaFTU7BtG0BLwyiZybamuQ3qfmdw9O9T8zCABP3m1fMUM28qKRxSIaCrKoA\nOeRIUL/Qu8nEZ/5g0i8CUCR0WZx+8oAR2HUdYOmWaQKBgQD9FiaLv5QRA0EGHRzO\nXfM2g+a336rL+UWFwHi/+eyqkrUkiclNJkaSmTwuTQe7K2VA7CKj8u57/znk9Jrg\n3WgetnCVEiGQfBahzsRCrG+eyVFuilJs3Mc6k6M9eYhju3ozU54NVXLjdiMUZdsV\nJEueQ1qNoxAQr7qv+gc52OTbOQKBgQDFgwrTNeJ+QVmCKvEGklb8AxpFLJph65O8\nMFhz2t5SB/coFxKOfAcuN1+DeFyOre7NDYsavu7TvzTxDaSsUvrWJzR6ZohLnul7\nVG0Sbgj0c3nAgLylR1ATS8ORkxBo84l20L5CFnoCe6LyX8sg/OK1OtUQxXSo0t/S\n/QXikimjiQKBgCU4KrcGl5ng5qEliuT2gBwWTcngxNd2czj2U0u4T4vOQ4F6GfaU\nmHBaxLTycx6dhSiFEZsW0Oe/Yx4+ssA7D2Lk5a2mmvUKqrFlHQvJHCk35hfhk7ma\nxlng+HLD+sDgA1qlA2tmk5zL9OC9EfkL+2rs8NY/ks9BaK0Ukhd5xD5RAoGBAJzM\nl39tu813m9OWu5n3+04+OFDKRBWQq8wupUn0a6K76B7Pkk/Dbv/lvdHlb7Vlp7rq\nEZC+G2PG3ASyTBTyG2h/3018sJ84HStnrt9+s2U9d1631QtxPcTT1QJwugpXrL3C\noghdR6dI9+dq3RvnJyOw/Q0/dInCPyaE8HMajivhAoGAJnBeMQ0z0YwLGvYENg5I\n+mdVeUzp9qkorI2p+ihzNxiiFjGbJAwPkWPNIPU9eLnBN8DIXgzgGskZjMdwKvFa\nXUrt1qQmQsz7TyeEQc5rEARKeMuMA50OWv4TAKB7zJcbFeJXimQI46/MI3ofsRTy\nuVla0Hf7832x6Gg9ZsEDW5Y=\n-----END PRIVATE KEY-----\n",
      "client_email": "panther-gsheet-recap@tensile-medium-368722.iam.gserviceaccount.com",
      "client_id": "115128944597052789491",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/panther-gsheet-recap%40tensile-medium-368722.iam.gserviceaccount.com",
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

class UserFields {
  static final String submit_date = 'Submit Date';
  static final String recap_list = 'Recap List';
  static final String future_list = 'Future List';
  static final String message = 'Message';

  static List<String> getFields() => [submit_date, recap_list, future_list, message];
}
