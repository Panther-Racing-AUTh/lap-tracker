import 'package:flutter/material.dart';
import 'popup_race_grid.dart';

class NewDataScreen extends StatefulWidget {
  const NewDataScreen({super.key});

  @override
  State<NewDataScreen> createState() => _NewDataScreenState();
}

late TextEditingController dateController;
bool isLoadingRacetrack = false;
bool isLoadingChart = false;
bool fetchedData = false;

class _NewDataScreenState extends State<NewDataScreen>
    with AutomaticKeepAliveClientMixin<NewDataScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    dateController = TextEditingController();
    super.initState();
  }

  //called to open chart from chat to data screen
  void openChartInPage() {
    setState(() {
      isLoadingChart = false;
      fetchedData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Choose your Race'),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: PopUpRaceGrid(),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Show Available Races'),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 70),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8)),
        ),
      ],
    );
  }
}
