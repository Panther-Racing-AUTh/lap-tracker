import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
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
    AppSetup setup = Provider.of<AppSetup>(context);

    CountryFlags getIcon(int index) {
      return CountryFlags.flag(
        races[index].country,
        height: 25,
        width: 25,
      );
    }

    return Row(
      children: [
        getIcon(index),
        SizedBox(width: 10),
        PopupMenuButton<Race>(
          child: Row(
            children: [
              Text(races[index].gpName),
              Icon(Icons.arrow_drop_down),
            ],
          ),
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
                index = races
                    .indexWhere((element) => element.gpName == value!.gpName);
              },
            );
            setup.setRace(races2023[index]);
          },
        ),
      ],
    );
  }
}
