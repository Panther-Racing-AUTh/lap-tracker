import 'package:flutter/material.dart';

class MotorcycleSetup extends StatefulWidget {
  @override
  State<MotorcycleSetup> createState() => _MotorcycleSetupState();
}

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
                builder: (context, setState) => AlertDialog(
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
                      height: 600,
                      width: 1000,
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
                          : Container(),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
