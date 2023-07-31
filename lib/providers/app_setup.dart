import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/event.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:flutter_complete_guide/supabase/motorcycle_setup_functions.dart';

import '../models/vehicle.dart';
import '../supabase/data_functions.dart';

//stores global data to access from every page

class AppSetup extends ChangeNotifier {
  AppSetup();
  //TODO: store settings and preferences locally on the device

  int raceSelectorIndex = 0;
  int vehicleSelectorIndex = 0;
  List chartList = [
    DateTime.now(),
    1,
  ];
  var loadedData;
  String role = 'a';
  int supabase_id = -1;
  Vehicle proposalVehicle = Vehicle.empty();
  int mainScreenDesktopIndex = 0;
  int chatId = -1;
  bool isOverview = true;
  late List allUsers;
  late List<RaceTrack> races2023;
  late List<Vehicle> vehicles;
  String username = '';
  String userEmail = '';
  String userDepartment = '';
  Session session = Session.empty();
  Event eventDate = Event.empty();
  int currentProposalPoolId = 0;

  // String proposalTitle = '';
  // String proposalDescription = '';
  // String proposalReason = '';

  List timeConstraints = [null, null];

  get chartPreferences => chartList;
  get mainScreenDesktopInd => mainScreenDesktopIndex;
  get date => chartList[0];
  get racetrack => races2023[raceSelectorIndex];

  setList(List l) {
    chartList = [chartList[0], chartList[1]] + l;
    print(chartList);
    notifyListeners();
  }

  setListFull(List l) {
    chartList = l;
    notifyListeners();
  }

  bool listContainsItem(dynamic item) {
    return chartList.skip(1).contains(item);
  }

  bool listContainsAllItems() {
    return chartList.length == 8;
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
    Map l = await getCurrentUserIdInt();
    proposalVehicle = await getVehicle(11);
    supabase_id = l['id'];
    role = await getUserRole(id: supabase_id);
    races2023 = await getRaceTracks();
    vehicles = await getVehicles();
    print(role + 'from setValuesAuto');
    username = l['full_name'];
    userEmail = l['email'];
    userDepartment = l['department'];
    return true;
  }

  void setChatId(int id) {
    chatId = id;
    notifyListeners();
  }

  void setOverview(bool value) {
    isOverview = value;
    notifyListeners();
  }

  void setTrack(int value) {
    chartList[1] = value;
  }
}
