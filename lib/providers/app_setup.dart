import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';

class AppSetup extends ChangeNotifier {
  //TODO: store settings and preferences locally on the device
  Race currentRaceSelected = races2023[0];
  List chartList = [
    '00:00:00.000',
    '01:00:00.000',
    '',
  ];
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
    chartList = [chartList[0], chartList[1], chartList[2]] + l;
    print(chartList);
    notifyListeners();
  }

  setListFull(List l) {
    chartList = l;
    print(chartList);
    notifyListeners();
  }

  bool listContainsItem(dynamic item) {
    return chartList.skip(3).contains(item);
  }

  bool listContainsAllItems() {
    return chartList.length == 9;
  }

  void removeItemFromlist(dynamic item) {
    chartList.remove(item);
    print(chartList);
    notifyListeners();
  }

  void addItemTolist(dynamic item) {
    chartList.add(item);
    print(chartList);
    notifyListeners();
  }

  void setIndex(int i) {
    mainScreenDesktopIndex = i;
    print(chartList);
    notifyListeners();
  }

  bool checkIndex(int i) {
    return mainScreenDesktopIndex == i;
  }

  void setTimeConstraints(dynamic start, dynamic end) {
    chartList[0] = start;
    chartList[1] = end;
    print(chartList);
    notifyListeners();
  }

  void setTimeConstraintsAuto(dynamic value, int index) {
    chartList[index] = value;
    print(chartList);
    notifyListeners();
  }

  void setXAxis(dynamic value) {
    chartList[2] = value;
    print(chartList);
    notifyListeners();
  }
}
