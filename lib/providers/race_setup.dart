import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';

class RaceSetup extends ChangeNotifier {
  Race currentRaceSelected = races2023[0];
  String raceTrackUrl = raceTrackUrls[0];

  RaceSetup();

  get currentRace => currentRaceSelected;
  get currentRaceTrackUrl => raceTrackUrl;
  setRace(Race r) {
    currentRaceSelected = r;
    selectRaceTrack();
    notifyListeners();
  }

  setRaceTrackUrl(String s) {
    raceTrackUrl = s;
  }

  void selectRaceTrack() {
    for (int i = 0; i < races2023.length; i++) {
      if (currentRaceSelected == races2023[i]) {
        setRaceTrackUrl(raceTrackUrls[i]);
      }
    }
  }
}
