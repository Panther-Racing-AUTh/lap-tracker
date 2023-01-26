import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';

class RaceSetup extends ChangeNotifier {
  //TODO: store settings and preferences locally on the device
  Race currentRaceSelected = races2023[0];

  RaceSetup();

  get currentRace => currentRaceSelected;

  setRace(Race r) {
    currentRaceSelected = r;
    notifyListeners();
  }
}
