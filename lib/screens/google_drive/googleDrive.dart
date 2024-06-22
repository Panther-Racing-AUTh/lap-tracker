import 'dart:io';
import 'package:flutter_complete_guide/screens/google_drive/secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

// Google Drive OAuth credentials
const _clientId = "458142783844-113ld95i6phn8bqfdr38g2s8npq3n9cl.apps.googleusercontent.com";
const _clientSecret = "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";
const _scopes = ['https://www.googleapis.com/auth/drive'];
const _redirectUri = 'http://localhost:44801'; // Ensure this matches exactly with the registered URI

// Shared folder ID extracted from the link
const _folderId = '1oiO87uYJLPpizrpcfc4JkkorNU7P1EiQ';

class GoogleDrive {
  final storage = SecureStorage();

  // Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      var authClient = await clientViaUserConsent(
          ClientId(_clientId, _clientSecret), _scopes, (url) async {
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false, forceWebView: false); // Ensure using external browser
        } else {
          throw 'Could not launch $url';
        }
      }, listenPort: 44801); // Ensure this matches the registered URI
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken!);
      return authClient;
    } else {
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"]!, credentials["data"]!,
                  DateTime.parse(credentials["expiry"]!)),
              credentials["refreshToken"],
              _scopes));
    }
  }

  // Upload File to the specified folder
  Future<void> upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    var fileToUpload = ga.File()
      ..name = p.basename(file.absolute.path)
      ..parents = [_folderId]; // Set the parent folder ID

    var response = await drive.files.create(
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
    print("Result ${response.toJson()}");
  }
}
