import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/setupChange.dart';
import 'package:flutter_complete_guide/supabase/motorcycle_setup_functions.dart';

bool frontSuspensionVisibility = false;
bool brakeVisibility = false;
bool rearSuspensionVisibility = false;
bool ecuVisibility = false;

var data = null;
var oldData = null;

void motorcycleSetup({required BuildContext context}) {
  bool history = false;
  late Future<dynamic> getData = getCurrentSetup();

  showDialog(
    context: context,
    builder: ((ctx) => StatefulBuilder(builder: (context, setState) {
          //
          bool checkWhichIconClicked(String t) {
            if (t == 'Front Suspension') return frontSuspensionVisibility;
            if (t == 'Brakes') return brakeVisibility;
            if (t == 'Rear Suspension') return rearSuspensionVisibility;
            if (t == 'ECU') return ecuVisibility;

            return false;
          }

          void toggle(String t) {
            if (t == 'Front Suspension') {
              frontSuspensionVisibility = !frontSuspensionVisibility;
              brakeVisibility = false;
              rearSuspensionVisibility = false;
              ecuVisibility = false;
            }
            if (t == 'Brakes') {
              brakeVisibility = !brakeVisibility;
              frontSuspensionVisibility = false;
              rearSuspensionVisibility = false;
              ecuVisibility = false;
            }
            if (t == 'Rear Suspension') {
              rearSuspensionVisibility = !rearSuspensionVisibility;
              frontSuspensionVisibility = false;
              brakeVisibility = false;
              ecuVisibility = false;
            }
            if (t == 'ECU') {
              ecuVisibility = !ecuVisibility;
              brakeVisibility = false;
              rearSuspensionVisibility = false;
              frontSuspensionVisibility = false;
            }
          }

          String showData(String t) {
            if (data == null)
              return '';
            else {
              if (t == 'Front Suspension')
                return data['front_suspension'].toString();
              if (t == 'Brakes') return data['brakes'].toString();
              if (t == 'Rear Suspension')
                return data['rear_suspension'].toString();
              if (t == 'ECU') return data['ECU'].toString();
            }
            return '';
          }

          void changeData(String t, String s) {
            setState(
              () {
                if (t == 'Front Suspension') {
                  if (s == '+') {
                    data['front_suspension']++;
                  } else
                    data['front_suspension']--;
                }

                if (t == 'Brakes') {
                  if (s == '+') {
                    data['brakes']++;
                  } else
                    data['brakes']--;
                }
                if (t == 'Rear Suspension') {
                  if (s == '+') {
                    data['rear_suspension']++;
                  } else
                    data['rear_suspension']--;
                }

                if (t == 'ECU') {
                  if (s == '+') {
                    data['ECU']++;
                  } else
                    data['ECU']--;
                }
              },
            );
          }

          //
          Row popUpMenu({required String type}) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: checkWhichIconClicked(type),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.all(10),
                      height: (type.length > 10) ? 180 : 160,
                      width: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(type,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () => changeData(type, '+'),
                              ),
                              Text(
                                showData(type),
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () => changeData(type, '-'),
                              )
                            ],
                          ),
                          Expanded(child: Container()),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  brakeVisibility = false;
                                  frontSuspensionVisibility = false;
                                  rearSuspensionVisibility = false;
                                  ecuVisibility = false;
                                });
                                print(oldData);
                                print(data);
                                saveChanges(data);
                              },
                              child: Text('Done'))
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(
                      () {
                        toggle(type);
                      },
                    ),
                    icon: Icon(
                      Icons.center_focus_strong,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
          //
          //
          return FutureBuilder(
            future: getData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                data = snapshot.data;
                if (oldData == null) oldData = snapshot.data;
                print('initial old data' + oldData.toString());
              }
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Setup'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          history = !history;
                        });
                      },
                      child: Text(
                        history ? 'Hide History' : 'View History',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
                actions: [
                  Container(
                    decoration: history
                        ? BoxDecoration()
                        : BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://rare-gallery.com/thumbs/957117-Ducati-motorcycle-Martini-side-view-bokeh-digital-art.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: history
                        ? StreamBuilder<List<SetupChange>>(
                            stream: getSetupChanges(),
                            builder: (context, snapshot) {
                              var list = [];
                              if (snapshot.hasData) {
                                list = snapshot.data!;

                                return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: ((context, index) {
                                    var changes =
                                        list[index].changes.split(',');
                                    var pre =
                                        list[index].previousSettings.split(',');
                                    var after =
                                        list[index].afterSettings.split(',');
                                    return ListTile(
                                      leading: Text(
                                        list[index].dateTime,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      title: Column(
                                        children: [
                                          for (int i = 0;
                                              i < changes.length;
                                              i++)
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Text(changes[i],
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                SizedBox(width: 10),
                                                Text(pre[i],
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                SizedBox(width: 10),
                                                Icon(Icons.arrow_right_alt),
                                                SizedBox(width: 10),
                                                Text(after[i],
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                SizedBox(width: 60),
                                              ],
                                            ),
                                          SizedBox(height: 20)
                                        ],
                                      ),
                                    );
                                  }),
                                );
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            },
                          )
                        : CustomMultiChildLayout(
                            delegate: _MyDelegate(
                              position: Offset.zero,
                              popupHeight:
                                  MediaQuery.of(context).size.height * 0.75,
                              popupWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            children: [
                              LayoutId(
                                  id: 1,
                                  child: popUpMenu(type: 'Front Suspension')),
                              LayoutId(id: 2, child: popUpMenu(type: 'Brakes')),
                              LayoutId(
                                  id: 3,
                                  child: popUpMenu(type: 'Rear Suspension')),
                              LayoutId(id: 4, child: popUpMenu(type: 'ECU')),
                            ],
                          ),
                  )
                ],
              );
            },
          );
        })),
  );
}

class _MyDelegate extends MultiChildLayoutDelegate {
  _MyDelegate(
      {required this.position,
      required this.popupHeight,
      required this.popupWidth});

  final Offset position;
  final double popupHeight;
  final double popupWidth;

  @override
  void performLayout(Size size) {
    //front suspension
    if (hasChild(1)) {
      var firstSize = layoutChild(
        1,
        BoxConstraints(),
      );
      positionChild(
        1,
        Offset(
            !frontSuspensionVisibility
                ? popupWidth * 0.77
                : popupWidth * 0.77 - 150,
            popupHeight * 0.495),
      );
    }

    //brakes
    if (hasChild(2)) {
      var secondSize = layoutChild(
        2,
        BoxConstraints(),
      );
      positionChild(
        2,
        Offset(!brakeVisibility ? popupWidth * 0.85 : popupWidth * 0.85 - 150,
            popupHeight * 0.675),
      );
    }
    //rear suspension
    if (hasChild(3)) {
      var thirdSize = layoutChild(
        3,
        BoxConstraints(),
      );
      positionChild(
        3,
        Offset(
            !rearSuspensionVisibility
                ? popupWidth * 0.395
                : popupWidth * 0.395 - 150,
            popupHeight * 0.335),
      );
    }
    //ecu
    if (hasChild(4)) {
      var fourthSize = layoutChild(
        4,
        BoxConstraints(),
      );
      positionChild(
        4,
        Offset(!ecuVisibility ? popupWidth * 0.46 : popupWidth * 0.46 - 150,
            popupHeight * 0.5),
      );
    }
  }

  @override
  bool shouldRelayout(_MyDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
