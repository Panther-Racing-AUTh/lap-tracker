import 'package:gsheets/gsheets.dart';

class UserSheetsApi {
  static final _spreadsheetId = '1M8DSdypMfUjMLTzilC-kJRmST98ATOvl0W_HY7RysT4';
  static const _credentials = r''' 
    {
      "type": "service_account",
      "project_id": "utility-pad-425713-t7",
      "private_key_id": "f3b85ae9b5a1115f28f7d5ec01ffb8c15deea4c5",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNd5Jn7dSG+ma5\ntFvZF8ID8m+ibycRpoGDJGpBo30KA+k346iyjERgf+CPp9tIVaJueW2beJq51tdk\n6spr7yXL1dr0t+JfwTQEYc1GVvK1u/RKhjL4dL+pMXp1v1kd2KKQ3A2Zcn2LFB8F\n8wcOueB8YwFhSudX4a012oJRuWVtEVYIg2NILTZuZmSPPUn+QSXQK5cKk0m5hYNY\nkXT2f2kms11F9HAiTJHhf+2LLPo29TLiO1csGm3ggn+ffvEa/kA00fvhzT0RDxhF\nZRfSI1j2FpBoWtTprfUTdjBaQYzl+TYot5hK0sj8bD8JJQMbQ47xDqil5ivvLFUW\nR7X6th2PAgMBAAECggEAL8WE00gvOUDgAH5oOoX1FKDaBszMKyTpCNo/IErISDtX\njqiOcRD+1ub0icIP0HYkoYX3D4ZPhzTl+K9EaCr+wTFUSsC0T+omU3x/00JlBQ8R\nwgAIus6+PzLjU5wtNqzHQ2H+gXZmrR79BY+XTPu3r4P/bqURO9QbRyGqWiD+bYiH\nLyO1FtAz3piYwyAY2p09XwisSmw+0O3+T5y7xqvLaa2pK2hCLPHxIBam8UhnD+Ah\nOG1iMsu3Qt/mV0ANLkc4Vrsx6QY114oiS6Tn9OMRJrPRtldtr4iWG/6NGYR9v4l2\nsrrp3DUw+t5b9d5iIPieef+ARR304QnHKQAt/LUjzQKBgQDm6lXvFAbwTqlABFy2\niDI13QRRxMFu2h5vUOcgtvJmzc3XtWCoX4qzOGVDXF1ZFYQOEQ12ySKREnwxllnY\nTzxvh2H6tOkBJ7xGtWPy9h1bSOdPG5Nke6kWOPBm8Xqht2VdL9LfZs5stalfWWc8\nnEqlLrQlC2PtTZrnlZtyq1d5IwKBgQDjyYd+QjCg4m8OQLAbQd+6StXVFbGTr3LI\nxQZZIWR3wC1n6RNwT1fdZmag4FrGaj6QVyEMDpAq/DCsJoXNdvL0gXYTXeWjnh/K\nFOCiDZOYOKFqvpNw0RrPTaEtu7ZBoRZVlFbyyKGPoGmH38B2qWXxHayFoESAlzDn\nlpvdnhhupQKBgBCILmbTdDu4Jf3jUg/vaEja7fg8seyRySQHEsUQ1AHwMhCDd8wW\nKwPxwa406qn6FF49ck1S0Rq5zBJwxTXrVlRVyPn+AcCHa79UNTerzyY97fGH8+F5\nyP1CTlPQbgst6h/l0J8V6Sl3SAz/hZidR+rTkSolyp2utKxn1Z08DyMpAoGAf9cC\nCRVCz3hllZ0ueQ2+b4JCgkWblOQ5yn3xMyKvjRm5IgFIXJbbHDG1VYK0z3ifRkjw\nDiE6PjWtZ2BzZb3lWt4xk2r2T56V/sc6zxhJhnv587ujagShREkwNUeNYUX0D/Gh\n3r5FFiOUNqKYFMC7qtfZlGE/MOApnUAEmBt7YNUCgYEAw0WZSWpAKcTTcn8aZetE\nIIHoL0Qz791jCPr42HSUjYW+JUD1e+aoC89I1KM2Vrb9Z5H4Wixhos4bOhOjBGGP\nC2qRaozzIVCur1jnykfYwSxUtw3K7/g30QgL067cpNv973T+1AUTk01/XTz8ePmH\nDSXQGBjVhK8SToMVRcS+iYA=\n-----END PRIVATE KEY-----\n",
      "client_email": "gsheets@utility-pad-425713-t7.iam.gserviceaccount.com",
      "client_id": "108222002735367407813",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40utility-pad-425713-t7.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
  ''';

  static final _gsheets = GSheets(_credentials);

  // Creating a Sheet.
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Users');

      // Insert the pattern "Monday, Wednesday, Saturday" in the first row
      final pattern = ["Monday", "Wednesday", "Saturday"];
      await _userSheet!.values.insertRow(1, pattern);

      // Insert the user fields in the second row
      final userFields = UserFields.getFields();
      await _userSheet!.values.insertRow(2, userFields);
    } catch (e) {
      print('init error $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insertUser(Map<String, dynamic> user) async {
    if (_userSheet == null) return;
    await _userSheet!.values.map.appendRow(user);
  }
}

class UserFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String email = 'email';
  static final String isBeginner = 'isBeginner';

  static List<String> getFields() => [id, name, email, isBeginner];
}
