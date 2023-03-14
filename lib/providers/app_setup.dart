import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';

import '../supabase/data_functions.dart';

class AppSetup extends ChangeNotifier {
  //TODO: store settings and preferences locally on the device

  int raceSelectorIndex = 0;
  List chartList = [DateTime.now()];

  String role = 'a';
  int supabase_id = 4;
  AppSetup();
  int mainScreenDesktopIndex = 0;
  int chatId = 0;
  late List allUsers;
  late List<RaceTrack> races2023;

  get chartPreferences => chartList;
  get mainScreenDesktopInd => mainScreenDesktopIndex;
  get date => chartList[0];
  get racetrack => races2023[raceSelectorIndex];
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

  Future<bool> setValuesAuto() async {
    supabase_id = await getCurrentUserIdInt();
    role = await getUserRole(id: supabase_id);
    races2023 = await getRaceTracks();
    return true;
  }

  void setChatId(int id) {
    chatId = id;
    notifyListeners();
  }
}
