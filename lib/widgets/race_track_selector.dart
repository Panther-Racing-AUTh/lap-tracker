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
  late int index;

  @override
  void initState() {
    AppSetup setup = Provider.of<AppSetup>(context, listen: false);
    index = setup.raceSelectorIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    AppSetup setup = Provider.of<AppSetup>(context);
    List<RaceTrack> races = setup.races2023;
    CountryFlags getIcon(int index) {
      return CountryFlags.flag(
        races[index].countryCode,
        height: 25,
        width: 25,
      );
    }

    return Row(
      children: [
        getIcon(setup.raceSelectorIndex),
        SizedBox(width: 10),
        PopupMenuButton<RaceTrack>(
          child: Row(
            children: [
              Text(races[setup.raceSelectorIndex].name),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          itemBuilder: (ctx) {
            return races.map((RaceTrack r) {
              return PopupMenuItem(
                value: r,
                child: Text(r.name),
              );
            }).toList();
          },
          onSelected: (RaceTrack? value) {
            setState(
              () {
                index =
                    races.indexWhere((element) => element.name == value!.name);
                setup.setTrack(value!.id);
              },
            );

            setup.raceSelectorIndex = index;
          },
        ),
      ],
    );
  }
}
