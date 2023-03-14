import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/supabase/data_functions.dart';
import 'package:flutter_complete_guide/widgets/race_track_selector.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewDataScreen extends StatefulWidget {
  const NewDataScreen({super.key});

  @override
  State<NewDataScreen> createState() => _NewDataScreenState();
}

late TextEditingController dateController;
bool isLoading = false;

class _NewDataScreenState extends State<NewDataScreen> {
  @override
  void initState() {
    dateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    AppSetup setup = Provider.of<AppSetup>(context);
    dateController.text = DateFormat('dd/MM/yyyy').format(setup.date);
    return Stack(
      children: [
        Visibility(
          visible: isLoading,
          child: Container(
            color: Colors.white.withOpacity(0.5),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.date_range), labelText: 'Enter Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: setup.date,
                        firstDate: DateTime(2022, 1, 1),
                        lastDate: DateTime(2025, 12, 31),
                      );

                      if (newDate != null) {
                        setState(() {
                          dateController.text =
                              DateFormat('dd/MM/yyyy').format(newDate);
                          setup.setDate(newDate);
                        });
                      } else
                        print('not selected');
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  //width: 300,
                  child: RaceTrackSelector(),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final List? res = await searchData(
                        dateTime: setup.date, race: setup.racetrack);
                    print(res);
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            actions: [
                              Container(
                                color: Colors.pink,
                                height: screenHeight * 0.8,
                                width: screenWidth * 0.8,
                                child: (res != null)
                                    ? ListView.builder(
                                        itemCount: res.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: Text(
                                              (index + 1).toString(),
                                            ),
                                            title: Row(
                                              children: [],
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text(
                                        'No data matching your filters',
                                        style: TextStyle(fontSize: 22),
                                      )),
                              )
                            ],
                          );
                        }));
                  },
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 19),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
