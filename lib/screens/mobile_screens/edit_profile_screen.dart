import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/person.dart';
import '../../names.dart';
import '../../providers/app_setup.dart';
import '../../supabase/profile_functions.dart';
import 'package:provider/provider.dart' as provider;

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Person newProfile = Person(name: '', about: '', department: '', role: '');
  final _globalKey = GlobalKey<FormState>();

  late Future<List> dataFuture;

  @override
  void initState() {
    AppSetup appSetup = provider.Provider.of<AppSetup>(context);
    super.initState();
    dataFuture = getUserProfile(id: appSetup.supabase_id);
  }

  static List<String> items = [
    dept_electronics,
    dept_aerodynamics,
    dept_suspension,
    dept_intake_exhaust,
    dept_frame_subframe,
    dept_social_media,
    dept_public_relations,
    no_dept,
  ];

  @override
  Widget build(BuildContext context) {
    Person? currentProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text(edit_profile),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            currentProfile = snapshot.data![1];
            if (newProfile.department == '')
              newProfile.department = currentProfile!.department;
            return ListView(
              children: [
                Form(
                  key: _globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 20),
                      _title(name),
                      _nameForm(currentProfile!),
                      SizedBox(height: 40),
                      _title(department),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                            itemHeight: 50,
                            isExpanded: true,
                            value: currentDepartment(newProfile),
                            icon: const Icon(Icons.unfold_more),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: ((value) {
                              setState(() {
                                if (value == items[0])
                                  newProfile.department = 'electronics';
                                else if (value == items[1])
                                  newProfile.department = 'aerodynamics';
                                else if (value == items[2])
                                  newProfile.department = 'suspension';
                                else if (value == items[3])
                                  newProfile.department = 'intake_exhaust';
                                else if (value == items[4])
                                  newProfile.department = 'frame';
                                else if (value == items[5])
                                  newProfile.department =
                                      'social_media_manager';
                                else if (value == items[6])
                                  newProfile.department = 'public_relations';
                                else
                                  newProfile.department = 'department';
                                print(newProfile.department);
                              });
                            })),
                      ),
                      SizedBox(height: 40),
                      _title(role),
                      _roleForm(currentProfile!),
                      SizedBox(height: 40),
                      _title(about),
                      _aboutForm(currentProfile!),
                      SizedBox(height: 60),
                      _saveButton(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: OutlinedButton(
        child: Text(
          save_changes,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: _saveForm,
      ),
    );
  }

  Widget _aboutForm(Person currentProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        onSaved: (newValue) => newProfile.about = newValue!,
        maxLines: 5,
        initialValue: currentProfile.about,
        validator: (value) {
          if (value!.isEmpty)
            return about_cannot_empty;
          else if (value.length < 40) {
            return about_not_long;
          } else
            return null;
        },
      ),
    );
  }

  Widget _roleForm(Person currentProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        onSaved: (newValue) => newProfile.role = newValue!,
        initialValue: currentProfile.role,
        validator: (value) {
          if (value!.isEmpty) {
            return role_cannot_empty;
          } else
            return null;
        },
      ),
    );
  }

  Widget _nameForm(Person currentProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        onSaved: (newValue) => newProfile.name = newValue!,
        initialValue: currentProfile.name,
        validator: (value) {
          if (value!.isEmpty) {
            return name_cannot_empty;
          } else
            return null;
        },
      ),
    );
  }

  void _saveForm() {
    final isValid = _globalKey.currentState!.validate();
    if (isValid) {
      _globalKey.currentState!.save();
      saveProfile(newProfile);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(saved_changes),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  String currentDepartment(Person p) {
    if (p.department == 'electronics') return items[0];
    if (p.department == 'aerodynamics') return items[1];
    if (p.department == 'suspension') return items[2];
    if (p.department == 'intake_exhaust') return items[3];
    if (p.department == 'frame') return items[4];
    if (p.department == 'social_media_manager') return items[5];
    if (p.department == 'public_relations')
      return items[6];
    else
      return items[7];
  }
}
