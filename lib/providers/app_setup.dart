import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';

class AppSetup extends ChangeNotifier {
  //TODO: store settings and preferences locally on the device
  Race currentRaceSelected = races2023[0];
  List chartList = [DateTime.now()];

  String role = 'a';
  AppSetup();
  int mainScreenDesktopIndex = 0;
  String chatId = '0';
  get currentRace => currentRaceSelected;
  get chartPreferences => chartList;
  get mainScreenDesktopInd => mainScreenDesktopIndex;
  get date => chartList[0];

  setRace(Race r) {
    currentRaceSelected = r;
    notifyListeners();
  }

  setList(List l) {
    chartList = [chartList[0], chartList[1], chartList[2]] + l;
    notifyListeners();
  }

  setListFull(List l) {
    chartList = l;
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

  void setTimeConstraints(dynamic start, dynamic end) {
    chartList[0] = start;
    chartList[1] = end;
    notifyListeners();
  }

  void setTimeConstraintsAuto(dynamic value, int index) {
    chartList[index] = value;
    notifyListeners();
  }

  void setXAxis(dynamic value) {
    chartList[2] = value;
    notifyListeners();
  }

  void setDate(DateTime dateTime) {
    chartList[0] = dateTime;
    notifyListeners();
  }

  Future<bool> setRoleAuto() async {
    role = await getUserRoleAuto();
    return true;
  }

  void setChatId(String id) {
    chatId = id;
    notifyListeners();
  }
}
