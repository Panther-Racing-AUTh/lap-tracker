import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:flutter_complete_guide/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/vehicle.dart';
import '../../providers/app_setup.dart';
import '../../supabase/proposal_functions.dart';

//selected part
Part selectedPart = Part(name: 'name', measurementUnit: '', value: -1);

//title of proposal
TextEditingController title = TextEditingController();
//description of proposal
TextEditingController description = TextEditingController();
//reason of proposal
TextEditingController reason = TextEditingController();
//new value of proposed part
TextEditingController change = TextEditingController();

//displays alert dialog to show the proposal
void showProposal(
    {required BuildContext context, required Proposal? proposal}) {
  AppSetup setup = Provider.of<AppSetup>(context, listen: false);
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  var _selectedIndex = 0;
  List<SetupPage> _pages = [];
  // title.text = setup.proposalTitle;
  // description.text = setup.proposalDescription;
  // reason.text = setup.proposalReason;

  //check if proposal already exists in the pool
  //if it does it is previewed to the interface
  //else a blank one is created
  if (proposal == null)
    print('proposal is null');
  else {
    print(proposal.id);
    title.text = proposal.title;
    description.text = proposal.description;
    reason.text = proposal.reason;
    change.text = proposal.partValueTo.split(' ')[0];
    selectedPart = Part(
      name: proposal.partName!,
      measurementUnit: proposal.partMeasurementUnit!,
      value: int.parse(proposal.partValueFrom.split(' ')[0]),
    );
    //calculateTitle();
  }
  showDialog(
    context: context,
    builder: (context) {
      return Query(
        options: QueryOptions(document: gql(getCurrentProposalPool)),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            print('exception');
            print(result.exception);
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            print('loading');
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          print(result.data);
          int currentProposalPoolId = result.data!['proposal_pool'][0]['id'];
          print('current proposal pool open has id: ' +
              currentProposalPoolId.toString());
          return StatefulBuilder(
            builder: (context, setState1) {
              void updateParent() {
                setState1(
                  () {},
                );
              }

              Vehicle v = setup.proposalVehicle;
              // dynamically create side menu for the systems of the vehicle
              List<NavigationRailDestination> navigationRailDestinations = [];
              for (int i = 0; i < v.systems.length; i++) {
                navigationRailDestinations.add(
                  NavigationRailDestination(
                    icon: Icon(Icons.source),
                    label: Text(v.systems[i].name),
                  ),
                );
              }
              // dynamically create page of every system of the vehicle
              if (_pages.isEmpty)
                for (int i = 0; i < v.systems.length; i++) {
                  _pages.add(
                    SetupPage(
                      subsystems: v.systems[i].subsystems,
                      updateParent: updateParent,
                    ),
                  );
                }
              print(_pages.length);
              //set index to the correct page if proposal already existed
              if (proposal != null)
                for (int i = 0; i < _pages.length; i++) {
                  print(_pages[i]);
                  print(_pages.length);
                  if (partBelongsToSubsystems(
                      selectedPart, _pages[i].subsystems)) {
                    print(i);
                    print('object');
                    _selectedIndex = i;
                    break;
                  }
                }
              //custom textfield
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
                          //show window with vehicle divided into systems
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
                          //title of proposal
                          Text(
                              (selectedPart.name == 'name')
                                  ? 'Select a part to generate title'
                                  : (int.tryParse(change.text) == null)
                                      ? 'Enter a valid value for the change'
                                      // : setup.proposalTitle,
                                      : title.text,
                              style: TextStyle(fontSize: 25)),
                          SizedBox(height: 15),
                          //description of proposal
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
                          //reason of proposal
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
                            //assign new value
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
                                          : ' ' +
                                              selectedPart.value.toString()),
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
                                          if ((int.tryParse(change.text) !=
                                                  null) &&
                                              selectedPart.name != 'name')
                                            // setup.proposalTitle =
                                            //     calculateTitle();
                                            title.text = calculateTitle();
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
                //buttons on the bottom of the dialog
                actions: [
                  TextButton(
                    child: Text('DISCARD', style: TextStyle(fontSize: 25)),
                    onPressed: () {
                      // setup.proposalDescription = '';
                      // setup.proposalReason = '';
                      // setup.proposalTitle = '';
                      // selectedPart =
                      //     Part(name: 'name', measurementUnit: '', value: -1);
                      change.text = '';
                      Navigator.of(context).pop();
                    },
                  ),
                  //button to save proposal
                  TextButton(
                    //check if new value is a number and a part has been selected
                    onPressed: !((int.tryParse(change.text) != null) &&
                            selectedPart.name != 'name')
                        ? null
                        : () {
                            //send proposal to database
                            sendProposal(
                              proposal: Proposal(
                                partId: selectedPart.id!,
                                partName: selectedPart.name,
                                partMeasurementUnit:
                                    selectedPart.measurementUnit,
                                userId: setup.supabase_id,
                                userRole: setup.role,
                                userDepartment: setup.userDepartment,
                                // title: setup.proposalTitle,
                                title: title.text,
                                description: description.text,
                                reason: reason.text,
                                poolId: currentProposalPoolId,
                                partValueFrom: selectedPart.value.toString() +
                                    ' ' +
                                    selectedPart.measurementUnit,
                                partValueTo: change.text.toString() +
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
    },
  );
}

//ui to build the vehicle systems pages

//for each system a new page is built with the vehicle's subsystems, parts and values
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
                  //if a part is selected its color changes and the selectedPart variable is changed
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPart = widget.subsystems[index].parts[index1];
                      });
                      widget.updateParent();

                      if (int.tryParse(change.text) != null)
                        // setup.proposalTitle = calculateTitle();
                        title.text = calculateTitle();
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

//called to dynamically calculate title
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

bool partBelongsToSubsystems(Part part, List<Subsystem> subSystems) {
  for (int i = 0; i < subSystems.length; i++) {
    for (int j = 0; j < subSystems[i].parts.length; j++) {
      if (part.name == subSystems[i].parts[j].name) return true;
    }
  }
  return false;
}
