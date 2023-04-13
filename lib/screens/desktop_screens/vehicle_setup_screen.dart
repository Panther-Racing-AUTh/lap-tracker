import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_complete_guide/models/setupChange.dart';
import 'package:flutter_complete_guide/supabase/motorcycle_setup_functions.dart';

import '../../models/vehicle.dart';

class EditVehicleSetup extends StatefulWidget {
  EditVehicleSetup(this.backFunction, this.vehicleId);
  Function({required bool edit, required Vehicle vehicle}) backFunction;
  int vehicleId;
  @override
  State<EditVehicleSetup> createState() => _EditVehicleSetupState();
}

class _EditVehicleSetupState extends State<EditVehicleSetup> {
  late Future<Vehicle> myFuture;
  //index for which page of systems is displayed
  var _selectedIndex = 0;
  //list of pages for each system
  List<Widget> _pages = [];
  @override
  void initState() {
    myFuture = getVehicle(widget.vehicleId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Vehicle>(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Vehicle v = snapshot.data!;
          print(v.systems.length);
          List<NavigationRailDestination> navigationRailDestinations = [];
          //add each system to the side menu
          for (int i = 0; i < v.systems.length; i++) {
            navigationRailDestinations.add(
              NavigationRailDestination(
                icon: Icon(Icons.source),
                label: Text(v.systems[i].name),
              ),
            );
          }
          //add a new page for each system with custom widget
          for (int i = 0; i < v.systems.length; i++) {
            _pages.add(
              SetupPage(
                subsystems: v.systems[i].subsystems,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //height: screenHeight * 0.1,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //back button
                        BackButton(
                          onPressed: () =>
                              widget.backFunction(edit: false, vehicle: v),
                        ),
                        //edit vehicle button, takes user to new screen to edit vehicle
                        IconButton(
                            onPressed: () =>
                                widget.backFunction(edit: true, vehicle: v),
                            icon: Icon(Icons.edit)),
                      ],
                    ),
                    //information of the vehicle
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(v.name, style: TextStyle(fontSize: 20)),
                              SizedBox(width: 50),
                              Text(v.year, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Text(v.description, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //show side menu and the page it corresponds to
              SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.8,
                  width: screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (v.systems.length >= 2)
                        NavigationRail(
                          destinations: navigationRailDestinations,
                          selectedIndex: _selectedIndex,
                          groupAlignment: 0,
                          onDestinationSelected: (value) {
                            setState(() {
                              _selectedIndex = value;
                            });
                          },
                          labelType: NavigationRailLabelType.all,
                        ),
                      if (v.systems.length >= 2)
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      SizedBox(width: 10),
                      Container(child: _pages[_selectedIndex]),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

//custom widget for each system to display subsystems, parts and information for each system
//it is a nested ListView.builder for each subsystem and its parts
class SetupPage extends StatefulWidget {
  SetupPage({required this.subsystems});
  List<Subsystem> subsystems;
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.subsystems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //subsystem name
                Text(
                  widget.subsystems[index].name,
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.subsystems[index].parts.length,
                  itemBuilder: ((context, index1) {
                    return Card(
                      elevation: 1,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IntrinsicWidth(
                              stepWidth:
                                  MediaQuery.of(context).size.width * 0.5,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      //part name
                                      Text(
                                        widget.subsystems[index].parts[index1]
                                            .name,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      //part measurement unit
                                      Text(
                                        '(' +
                                            widget.subsystems[index]
                                                .parts[index1].measurementUnit +
                                            ')',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  //part value
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      widget
                                          .subsystems[index].parts[index1].value
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
/*
ListviewFromTitle(Part part) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: data.length + 1,
    itemBuilder: (context, index) {
      if (index == 0)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 5),
          ],
        );
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: Container(
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data[index - 1],
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.remove,
                              size: 16,
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white),
                          child: Text(
                            '3',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.add,
                            size: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      );
    },
  );
}
*/
/*
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
*/
