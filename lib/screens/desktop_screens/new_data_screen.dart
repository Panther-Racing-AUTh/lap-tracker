import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/supabase/data_functions.dart';
import 'package:flutter_complete_guide/widgets/chart_widget.dart';
import 'package:flutter_complete_guide/widgets/race_track_selector.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    AppSetup setup = Provider.of<AppSetup>(context);
    dateController.text = DateFormat('dd/MM/yyyy').format(setup.date);

    //checks if user came from chat and executes the appropriate function
    if (setup.mainScreenDesktopIndex == 2 && setup.chatId != -1)
      openChartInPage();
    //show dialog to select lap
    showLapDialog({
      required BuildContext context,
      required Map session,
      required double screenWidth,
      required double screenHeight,
    }) =>
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(actions: [
              FutureBuilder<List>(
                future: getLapFromSession(session['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List laps = snapshot.data!;
                    return Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.6,
                      child: (laps.isNotEmpty)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                  Container(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Showing results for ',
                                            style: TextStyle(fontSize: 20)),
                                        Text(
                                          session['type'],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 24),
                                        ),
                                        Text('  session',
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("No"),
                                        SizedBox(width: screenWidth * 0.6),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: laps.length,
                                        itemBuilder: (context, index) {
                                          //return list tile for each result found
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Lap ' +
                                                    (index + 1).toString())
                                              ],
                                            ),
                                            onTap: () async {
                                              //get data for selected lap
                                              Navigator.of(context).pop();
                                              setState(() {
                                                isLoadingChart = true;
                                              });
                                              setup.loadedData = await
                                                  //getDataFromLap(laps[index]['id']);
                                                  getData();
                                              setState(() {
                                                isLoadingChart = false;
                                                fetchedData = true;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ])
                          : Container(
                              height: screenHeight * 0.1,
                              child: Center(
                                  child: Text(
                                'No laps found',
                                style: TextStyle(fontSize: 22),
                              )),
                            ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ]);
          },
        );

    return Stack(
      children: [
        Visibility(
          visible: isLoadingRacetrack,
          child: Container(
            color: Colors.white.withOpacity(0.5),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        Column(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  //show date picker
                  Container(
                    width: 200,
                    height: 50,
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.date_range),
                          labelText: 'Enter Date'),
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
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  // show race track selector
                  Container(
                    height: 50,
                    //width: 300,
                    child: RaceTrackSelector(),
                  ),
                  //button to search for session
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoadingRacetrack = true;
                      });
                      //assign fetched sessions to local variable
                      final List? sessions = await searchData(
                          dateTime: setup.date, race: setup.racetrack);

                      setState(() {
                        isLoadingRacetrack = false;
                      });

                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              actions: [
                                //show search results to user
                                Container(
                                  width: screenWidth * 0.7,
                                  height: screenHeight * 0.6,
                                  child: (sessions!.isNotEmpty)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                              Container(
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'Showing results for track  ',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                    Text(
                                                      setup.racetrack.name,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 24),
                                                    ),
                                                    Text('  on the day of ',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                    Text(
                                                      '${setup.date.year}-${setup.date.month.toString().padLeft(2, '0')}-${setup.date.day.toString().padLeft(2, '0')}',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 24),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ListTile(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("No"),
                                                    SizedBox(
                                                        width:
                                                            screenWidth * 0.2),
                                                    Text("Time"),
                                                    SizedBox(
                                                        width:
                                                            screenWidth * 0.2),
                                                    Text("Session")
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: sessions.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //return list tiles for each session
                                                      return ListTile(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text((index + 1)
                                                                .toString()),
                                                            SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.2),
                                                            Text(sessions[index]
                                                                        [
                                                                        'event_date']
                                                                    ['date']
                                                                .toString()
                                                                .split('T')[1]),
                                                            SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.2),
                                                            Text(sessions[index]
                                                                ['type'])
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          //search for laps based on the selected session
                                                          Navigator.of(context)
                                                              .pop();
                                                          showLapDialog(
                                                            context: context,
                                                            session:
                                                                sessions[index],
                                                            screenHeight:
                                                                screenHeight,
                                                            screenWidth:
                                                                screenWidth,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ])
                                      //no data screen
                                      : Container(
                                          height: screenHeight * 0.1,
                                          child: Center(
                                              child: Text(
                                            'No data matching your filters',
                                            style: TextStyle(fontSize: 22),
                                          )),
                                        ),
                                )
                              ],
                            );
                          }));
                    },
                    child: Text(
                      'Search Sessions',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                  SizedBox(width: 500),
                ],
              ),
            ),
            //when data is fetched the chart customization is made visible
            if (fetchedData && !isLoadingChart) EchartsPage()
          ],
        ),
      ],
    );
  }
}
