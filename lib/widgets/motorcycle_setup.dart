import 'package:flutter/material.dart';

class MotorcycleSetup extends StatefulWidget {
  @override
  State<MotorcycleSetup> createState() => _MotorcycleSetupState();
}

bool frontSuspensionVisibility = false;
bool brakeVisibility = false;
bool rearSuspensionVisibility = false;
bool ecuVisibility = false;

class _MotorcycleSetupState extends State<MotorcycleSetup> {
  bool history = false;
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.motorcycle,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: ((ctx) => StatefulBuilder(
                builder: (context, setState) {
                  //
                  bool checkWhichIconClicked(String t) {
                    if (t == 'Front Suspension')
                      return frontSuspensionVisibility;
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

                  //
                  Row popUpMenu({required String type}) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: checkWhichIconClicked(type),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          color: Colors.black, size: 30),
                                      Text(
                                        '  8  ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Icon(Icons.remove,
                                          color: Colors.black, size: 30)
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
                            icon: Icon(Icons.center_focus_strong, size: 45),
                          ),
                        ],
                      );
                  //
                  //
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
                            ? ListView.builder(
                                itemCount: 5,
                                itemBuilder: ((context, index) => ListTile(
                                      leading: const Icon(Icons.list),
                                      trailing: const Text(
                                        "GFG",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 15),
                                      ),
                                      title: Text("List item $index"),
                                    )),
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
                                      child:
                                          popUpMenu(type: 'Front Suspension')),
                                  LayoutId(
                                      id: 2, child: popUpMenu(type: 'Brakes')),
                                  LayoutId(
                                      id: 3,
                                      child:
                                          popUpMenu(type: 'Rear Suspension')),
                                  LayoutId(
                                      id: 4, child: popUpMenu(type: 'ECU')),
                                ],
                              ),
                      )
                    ],
                  );
                },
              )),
        );
      },
    );
  }
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
