import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_complete_guide/providers/race_setup.dart';
import 'package:provider/provider.dart';

class RaceTrackSelector extends StatefulWidget {
  const RaceTrackSelector({Key? key}) : super(key: key);

  @override
  State<RaceTrackSelector> createState() => _RaceTrackSelectorState();
}

class _RaceTrackSelectorState extends State<RaceTrackSelector> {
  int index = 0;

  @override
  Widget build(BuildContext ctx) {
    List<Race> races = races2023;
    RaceSetup setup = Provider.of<RaceSetup>(context);

    CountryFlags getIcon(int index) {
      return CountryFlags.flag(races[index].country);
    }

    return PopupMenuButton<Race>(
      icon: getIcon(index),
      itemBuilder: (ctx) {
        return races.map((Race r) {
          return PopupMenuItem(
            value: r,
            child: Text(r.gpName),
          );
        }).toList();
      },
      onSelected: (Race? value) {
        setState(
          () {
            index =
                races.indexWhere((element) => element.gpName == value!.gpName);
          },
        );
        setup.setRace(races2023[index]);
      },
    );
  }
}
