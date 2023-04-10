import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:provider/provider.dart';

import '../../models/vehicle.dart';
import '../../providers/app_setup.dart';
import '../../supabase/proposal_functions.dart';

Part selectedPart = Part(name: 'name', measurementUnit: '', value: -1);

TextEditingController title = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController reason = TextEditingController();
TextEditingController change = TextEditingController();

void showProposal({required BuildContext context}) {
  AppSetup setup = Provider.of<AppSetup>(context, listen: false);
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  var _selectedIndex = 0;
  List<Widget> _pages = [];
  title.text = setup.proposalTitle;
  description.text = setup.proposalDescription;
  reason.text = setup.proposalReason;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState1) {
          void updateParent() {
            setState1(
              () {},
            );
          }

          Vehicle v = setup.proposalVehicle;

          List<NavigationRailDestination> navigationRailDestinations = [];
          for (int i = 0; i < v.systems.length; i++) {
            navigationRailDestinations.add(
              NavigationRailDestination(
                icon: Icon(Icons.source),
                label: Text(v.systems[i].name),
              ),
            );
          }

          for (int i = 0; i < v.systems.length; i++) {
            _pages.add(
              SetupPage(
                subsystems: v.systems[i].subsystems,
                updateParent: updateParent,
              ),
            );
          }
          TextField myTextField({
            required TextEditingController controller,
            required String label,
            bool isTitle = false,
            bool isDescription = false,
            bool isReason = false,
            required AppSetup setup,
          }) =>
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (isDescription) {
                    setup.proposalDescription = value;
                    setState1(
                      () {
                        setup.proposalTitle = calculateTitle();
                      },
                    );
                  } else if (isReason)
                    setup.proposalReason = value;
                  else
                    setup.proposalTitle = value;

                  setState1(
                    () {},
                  );
                },
              );

          return AlertDialog(
            title: Center(
              child: Text(
                "CURRENT PROPOSAL",
                style: TextStyle(fontSize: 20),
              ),
            ),
            content: Container(
              height: screenHeight * 0.9,
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Part:'),
                      SingleChildScrollView(
                        child: Container(
                          height: screenHeight * 0.7,
                          width: screenWidth * 0.45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (v.systems.length >= 2)
                                NavigationRail(
                                  destinations: navigationRailDestinations,
                                  selectedIndex: _selectedIndex,
                                  groupAlignment: 0,
                                  onDestinationSelected: (value) {
                                    setState1(() {
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
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          (selectedPart.name == 'name')
                              ? 'Select a part to generate title'
                              : (int.tryParse(change.text) == null)
                                  ? 'Enter a valid value for the change'
                                  : setup.proposalTitle,
                          style: TextStyle(fontSize: 25)),
                      SizedBox(height: 15),
                      Container(
                        width: screenWidth * 0.3,
                        child: myTextField(
                          isDescription: true,
                          setup: setup,
                          controller: description,
                          label: 'Description',
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: screenWidth * 0.3,
                        child: myTextField(
                          isReason: true,
                          setup: setup,
                          controller: reason,
                          label: 'Reason',
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text('Change value from',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Container(
                            alignment: Alignment.center,
                            color: Colors.grey.shade200,
                            width: 50,
                            child: TextField(
                              controller: TextEditingController(
                                  text: (selectedPart.value == -1)
                                      ? '    -'
                                      : ' ' + selectedPart.value.toString()),
                              enabled: false,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('to', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Container(
                              width: 50,
                              child: TextField(
                                controller: change,
                                onChanged: (value) {
                                  setState1(
                                    () {
                                      if ((int.tryParse(change.text) != null) &&
                                          selectedPart.name != 'name')
                                        setup.proposalTitle = calculateTitle();
                                    },
                                  );
                                },
                              )),
                          Text(selectedPart.measurementUnit)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('DISCARD', style: TextStyle(fontSize: 25)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: !((int.tryParse(change.text) != null) &&
                        selectedPart.name != 'name')
                    ? null
                    : () {
                        sendProposal(
                          proposal: Proposal(
                            partId: selectedPart.id!,
                            partName: selectedPart.name,
                            partMeasurementUnit: selectedPart.measurementUnit,
                            userId: setup.supabase_id,
                            userRole: setup.role,
                            userDepartment: setup.userDepartment,
                            title: setup.proposalTitle,
                            description: description.text,
                            reason: reason.text,
                            partValueFrom: selectedPart.value.toString() +
                                ' ' +
                                selectedPart.measurementUnit,
                            partValueTo:
                                (selectedPart.value + int.parse(change.text))
                                        .toString() +
                                    ' ' +
                                    selectedPart.measurementUnit,
                          ),
                        );
                      },
                child: Text('SAVE', style: TextStyle(fontSize: 25)),
              )
            ],
          );
        },
      );
    },
  );
}

class SetupPage extends StatefulWidget {
  SetupPage({required this.subsystems, required this.updateParent});
  List<Subsystem> subsystems;
  Function updateParent;
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    AppSetup setup = Provider.of<AppSetup>(context);
    return Expanded(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.subsystems.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subsystems[index].name,
                style: TextStyle(color: Colors.black, fontSize: 26),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.subsystems[index].parts.length,
                itemBuilder: ((context, index1) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPart = widget.subsystems[index].parts[index1];
                      });
                      widget.updateParent();

                      if (int.tryParse(change.text) != null)
                        setup.proposalTitle = calculateTitle();
                    },
                    child: Card(
                      color: (selectedPart.name ==
                              widget.subsystems[index].parts[index1].name)
                          ? Colors.yellow
                          : Colors.white,
                      elevation: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget
                                          .subsystems[index].parts[index1].name,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Text(
                                      '(' +
                                          widget.subsystems[index].parts[index1]
                                              .measurementUnit +
                                          ')',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.subsystems[index].parts[index1].value
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

String calculateTitle() {
  bool sign = false;
  if (int.parse(change.text) - selectedPart.value > 0) sign = true;
  if (sign) {
    return selectedPart.name +
        ' +' +
        (int.parse(change.text) - selectedPart.value).toString() +
        ' ' +
        selectedPart.measurementUnit;
  } else
    return selectedPart.name +
        ' ' +
        (int.parse(change.text) - selectedPart.value).toString() +
        ' ' +
        selectedPart.measurementUnit;
}
