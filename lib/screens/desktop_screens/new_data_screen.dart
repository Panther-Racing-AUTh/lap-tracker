import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/widgets/race_track_selector.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewDataScreen extends StatefulWidget {
  const NewDataScreen({super.key});

  @override
  State<NewDataScreen> createState() => _NewDataScreenState();
}

late TextEditingController dateController;

class _NewDataScreenState extends State<NewDataScreen> {
  @override
  void initState() {
    dateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppSetup setup = Provider.of<AppSetup>(context);
    dateController.text = DateFormat('dd/MM/yyyy').format(setup.date);
    return Column(
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
            Container(
              height: 50,
              width: 300,
              child: RaceTrackSelector(),
            ),
          ],
        )
      ],
    );
  }
}
