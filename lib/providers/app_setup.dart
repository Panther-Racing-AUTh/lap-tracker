import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';

class AppSetup extends ChangeNotifier {
  //TODO: store settings and preferences locally on the device
  Race currentRaceSelected = races2023[0];
  List chartList = [];
  int mainScreenDesktopIndex = 0;
  AppSetup();

  get currentRace => currentRaceSelected;
  get chartPreferences => chartList;
  get mainScreenDesktopInd => mainScreenDesktopIndex;

  setRace(Race r) {
    currentRaceSelected = r;
    notifyListeners();
  }

  setList(List l) {
    chartList = l;
    notifyListeners();
  }

  bool listContainsItem(dynamic item) {
    return chartList.contains(item);
  }

  bool listContainsAllItems() {
    return chartList.length == 6;
  }

  void removeItemFromlist(dynamic item) {
    chartList.remove(item);
    notifyListeners();
  }

  void addItemTolist(dynamic item) {
    chartList.add(item);
    notifyListeners();
  }

  void setIndex(int i) {
    mainScreenDesktopIndex = i;
    notifyListeners();
  }

  bool checkIndex(int i) {
    return mainScreenDesktopIndex == i;
  }
}
