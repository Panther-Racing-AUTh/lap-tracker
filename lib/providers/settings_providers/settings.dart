import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:googleapis/connectors/v1.dart';

class SettingsProvider extends ChangeNotifier{
  bool isNewHomepage=false;


  void setIsNewHomepage(bool value) {
    isNewHomepage = value;
    notifyListeners(); // Notify listeners that the state has changed
  }
}
