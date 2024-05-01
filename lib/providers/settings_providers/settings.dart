import 'package:flutter/cupertino.dart';

class SettingsProvider extends ChangeNotifier{

  bool isNewHomepage=true;


  void setIsNewHomepage(bool value) {
    isNewHomepage = value;
    notifyListeners(); // Notify listeners that the state has changed
  }
}
